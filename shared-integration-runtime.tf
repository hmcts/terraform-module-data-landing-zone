module "shared_integration_databricks" {
  source                = "./modules/azure-databricks"
  name                  = "${local.name}-integration-databricks001-${var.env}"
  resource_group        = azurerm_resource_group.this["shared-integration"].name
  location              = var.location
  common_tags           = var.common_tags
  vnet_id               = module.networking.vnet_ids["vnet"]
  public_subnet_name    = module.networking.subnet_names["vnet-data-bricks-public"]
  public_subnet_nsg_id  = module.networking.network_security_groups_ids["nsg"]
  private_subnet_name   = module.networking.subnet_names["vnet-data-bricks-private"]
  private_subnet_nsg_id = module.networking.network_security_groups_ids["nsg"]
}

resource "azurerm_eventhub_namespace" "this" {
  name                     = "${local.name}-integration-eventHubNamespace001-${var.env}"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.this["shared-integration"].name
  sku                      = "Standard"
  capacity                 = 1
  maximum_throughput_units = 2
  auto_inflate_enabled     = true
  zone_redundant           = true

  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags
}

module "shared_integration_eventhub_pe" {
  source = "./modules/azure-private-endpoint"

  name             = "${local.name}-integration-eventHubNamespace001-pe-${var.env}"
  resource_group   = azurerm_resource_group.this["shared-integration"].name
  location         = var.location
  subnet_id        = module.networking.subnet_ids["vnet-services"]
  common_tags      = var.common_tags
  resource_name    = azurerm_eventhub_namespace.this.name
  resource_id      = azurerm_eventhub_namespace.this.id
  subresource_name = "namespace"
}

resource "azurerm_data_factory" "this" {
  name                            = "${local.name}-integration-dataFactory001-${var.env}"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.this["shared-integration"].name
  tags                            = var.common_tags
  public_network_enabled          = false
  purview_id                      = var.purview_id
  managed_virtual_network_enabled = true

  identity {
    type = "SystemAssigned"
  }
}

module "shared_integration_datafactory_pe" {
  for_each = toset(["dataFactory", "portal"])
  source   = "./modules/azure-private-endpoint"

  name             = "${local.name}-integration-dataFactory001-${each.key}-${var.env}"
  resource_group   = azurerm_resource_group.this["shared-integration"].name
  location         = var.location
  subnet_id        = module.networking.subnet_ids["vnet-services"]
  common_tags      = var.common_tags
  resource_name    = azurerm_data_factory.this.name
  resource_id      = azurerm_data_factory.this.id
  subresource_name = each.key
}

resource "azurerm_data_factory_integration_runtime_azure" "this" {
  name                    = "AutoResolveIntegrationRuntime"
  data_factory_id         = azurerm_data_factory.this.id
  location                = "AutoResolve"
  virtual_network_enabled = true
}

resource "azurerm_data_factory_managed_private_endpoint" "purview" {
  count              = var.purview_id != "" && var.purview_id != null ? 1 : 0
  name               = "${local.name}-integration-dataFactory001-purview-${var.env}"
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = var.purview_id
  subresource_name   = "account"
}

resource "azurerm_data_factory_managed_private_endpoint" "purview_storage" {
  for_each           = toset(var.purview_managed_storage_id == null ? [] : ["blob", "queue"])
  name               = "${local.name}-integration-dataFactory001-purview-${each.key}-${var.env}"
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = var.purview_managed_storage_id
  subresource_name   = each.key
}

resource "azurerm_data_factory_managed_private_endpoint" "purview_eventhub" {
  count              = var.purview_managed_event_hub_id != null ? 1 : 0
  name               = "${local.name}-integration-dataFactory001-purview-eventhub-${var.env}"
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = var.purview_managed_event_hub_id
  subresource_name   = "namespace"
}

resource "azurerm_data_factory_managed_private_endpoint" "key_vault" {
  name               = "${local.name}-integration-dataFactory001-keyvault-${var.env}"
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = module.metadata_vault["meta001"].key_vault_id
  subresource_name   = "vault"
}

resource "azurerm_data_factory_linked_service_key_vault" "this" {
  name                     = module.metadata_vault["meta001"].key_vault_name
  data_factory_id          = azurerm_data_factory.this.id
  key_vault_id             = module.metadata_vault["meta001"].key_vault_id
  integration_runtime_name = azurerm_data_factory_integration_runtime_azure.this.name
}

resource "azurerm_data_factory_managed_private_endpoint" "mssql" {
  name               = "${local.name}-integration-dataFactory001-mssql-${var.env}"
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = module.metadata_mssql.mssql_server_id
  subresource_name   = "sqlServer"
}

resource "azurerm_data_factory_linked_service_sql_server" "this" {
  name              = module.metadata_mssql.mssql_server_name
  data_factory_id   = azurerm_data_factory.this.id
  connection_string = "Integrated Security=False;Encrypt=True;Connection Timeout=30;Data Source=${module.metadata_mssql.fqdn};Initial Catalog=${local.metadata_mssql_db_name}"
}

resource "azurerm_data_factory_managed_private_endpoint" "storage" {
  for_each           = toset(["raw", "curated"])
  name               = "${local.name}-integration-dataFactory001-${each.key}-${var.env}"
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = module.storage[each.key].storageaccount_id
  subresource_name   = "dfs"
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "this" {
  for_each          = toset(["raw", "curated"])
  name              = module.storage[each.key].storageaccount_name
  data_factory_id   = azurerm_data_factory.this.id
  connection_string = module.storage[each.key].storageaccount_primary_dfs_endpoint
}

resource "azurerm_data_factory_linked_service_azure_databricks" "this" {
  name            = module.shared_integration_databricks.workspace_name
  data_factory_id = azurerm_data_factory.this.id
  description     = "Azure Databricks Compute for Data Engineering"
  adb_domain      = "https://${module.shared_integration_databricks.workspace_url}"

  msi_work_space_resource_id = module.shared_product_databricks.workspace_id

  new_cluster_config {
    node_type             = "Standard_DS3_v2"
    cluster_version       = "7.3.x-scala2.12"
    min_number_of_workers = 1
    max_number_of_workers = 15
    driver_node_type      = "Standard_DS3_v2"

    custom_tags = var.common_tags

    spark_environment_variables = {
      PYSPARK_PYTHON = "/databricks/python3/bin/python3"
    }
  }
}

resource "azurerm_role_assignment" "datafactory_storage" {
  for_each             = toset(["raw", "curated"])
  scope                = module.storage[each.key].storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.this.identity[0].principal_id
}

resource "azurerm_role_assignment" "datafactory_databricks" {
  scope                = module.shared_integration_databricks.workspace_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_data_factory.this.identity[0].principal_id
}
