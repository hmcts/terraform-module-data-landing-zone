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

module "shared_integration_datafactory" {
  source = "git@github.com:hmcts/terraform-module-azure-datafactory?ref=main"

  env                              = var.env
  product                          = "data-landing"
  component                        = "shared-integration"
  name                             = "${local.name}-integration-dataFactory001"
  public_network_enabled           = false
  managed_virtual_network_enabled  = true
  purview_id                       = var.purview_id
  system_assigned_identity_enabled = true
  private_endpoint_enabled         = true
  private_endpoint_subnet_id       = module.networking.subnet_ids["vnet-services"]
  common_tags                      = var.common_tags

  managed_private_endpoints = {
    purview = {
      resource_id      = var.purview_id
      subresource_name = "account"
    }
    //purview-storage-blob = {
    //  resource_id      = var.purview_managed_storage_id
    //  subresource_name = "blob"
    //}
    //purview-storage-queue = {
    //  resource_id      = var.purview_managed_storage_id
    //  subresource_name = "queue"
    //}
    //purview_eventhub = {
    //  resource_id      = var.purview_managed_event_hub_id
    //  subresource_name = "namespace"
    //}
    keyvault = {
      resource_id      = module.metadata_vault["meta001"].key_vault_id
      subresource_name = "vault"
    }
    mssql = {
      resource_id      = module.metadata_mssql.mssql_server_id
      subresource_name = "sqlServer"
    }
    storage-raw = {
      resource_id      = module.storage["raw"].storageaccount_id
      subresource_name = "dfs"
    }
    storage-curated = {
      resource_id      = module.storage["curated"].storageaccount_id
      subresource_name = "dfs"
    }
  }

  linked_key_vaults = {
    "${module.metadata_vault["meta001"].key_vault_name}" = {
      resource_id              = module.metadata_vault["meta001"].key_vault_id
      integration_runtime_name = "AutoResolveIntegrationRuntime"
    }
  }

  linked_mssql_server = {
    "${module.metadata_mssql.mssql_server_name}" = {
      server_fqdn              = module.metadata_mssql.fqdn
      database_name            = local.metadata_mssql_db_name
      integration_runtime_name = "AutoResolveIntegrationRuntime"
    }
  }

  linked_blob_storage = {
    "${module.storage["raw"].storageaccount_name}" = {
      connection_string        = module.storage["raw"].storageaccount_primary_dfs_endpoint
      use_managed_identity     = true
      integration_runtime_name = "AutoResolveIntegrationRuntime"
    }
    "${module.storage["curated"].storageaccount_name}" = {
      connection_string        = module.storage["curated"].storageaccount_primary_dfs_endpoint
      use_managed_identity     = true
      integration_runtime_name = "AutoResolveIntegrationRuntime"
    }
  }

  linked_databricks = {
    "${module.shared_integration_databricks.workspace_name}" = {
      databricks_workspace_url = module.shared_integration_databricks.workspace_url
      databricks_workspace_id  = module.shared_integration_databricks.workspace_id
      integration_runtime_name = "AutoResolveIntegrationRuntime"
      new_cluster_config = {
        node_type             = "Standard_DS3_v2"
        cluster_version       = "7.3.x-scala2.12"
        min_number_of_workers = 1
        max_number_of_workers = 15
        driver_node_type      = "Standard_DS3_v2"
        spark_env_vars = {
          PYSPARK_PYTHON = "/databricks/python3/bin/python3"
        }
      }
    }
  }
}

resource "azurerm_role_assignment" "datafactory_storage" {
  for_each             = toset(["raw", "curated"])
  scope                = module.storage[each.key].storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.shared_integration_datafactory.identity.principal_id
}

resource "azurerm_role_assignment" "datafactory_databricks" {
  scope                = module.shared_integration_databricks.workspace_id
  role_definition_name = "Contributor"
  principal_id         = module.shared_integration_datafactory.identity.principal_id
}
