module "shared_integration_databricks" {
  source = "github.com/hmcts/terraform-module-databricks?ref=main"

  depends_on = [module.vnet_peer_hub]

  env                          = var.env
  product                      = "data-landing"
  component                    = "shared-integration"
  name                         = "${local.name}-integration-databricks001"
  existing_resource_group_name = azurerm_resource_group.this[local.shared_integration_resource_group].name
  location                     = var.location
  common_tags                  = var.common_tags
  vnet_id                      = module.networking.vnet_ids["vnet"]
  public_subnet_name           = module.networking.subnet_names["vnet-data-bricks-public"]
  public_subnet_nsg_id         = module.networking.network_security_groups_ids["nsg"]
  private_subnet_name          = module.networking.subnet_names["vnet-data-bricks-private"]
  private_subnet_nsg_id        = module.networking.network_security_groups_ids["nsg"]
}

resource "azurerm_eventhub_namespace" "this" {
  name                     = length("${local.name}-integration-eventHubNamespace001-${var.env}") > 50 ? "${local.short_name}-integration-eventHubNamespace001-${var.env}" : "${local.name}-integration-eventHubNamespace001-${var.env}"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.this[local.shared_integration_resource_group].name
  sku                      = "Premium"
  capacity                 = 1
  maximum_throughput_units = 2
  auto_inflate_enabled     = false


  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags
}

module "shared_integration_eventhub_pe" {
  source = "./modules/azure-private-endpoint"

  depends_on = [module.vnet_peer_hub]

  name             = "${local.name}-integration-eventHubNamespace001-pe-${var.env}"
  resource_group   = azurerm_resource_group.this[local.shared_integration_resource_group].name
  location         = var.location
  subnet_id        = module.networking.subnet_ids["vnet-services"]
  common_tags      = var.common_tags
  resource_name    = azurerm_eventhub_namespace.this.name
  resource_id      = azurerm_eventhub_namespace.this.id
  subresource_name = "namespace"
}

module "shared_integration_datafactory" {
  source = "github.com/hmcts/terraform-module-azure-datafactory?ref=main"

  depends_on = [module.vnet_peer_hub]

  env                              = var.env
  product                          = "data-landing"
  component                        = "shared-integration"
  name                             = "${local.name}-integration-dataFactory001"
  public_network_enabled           = false
  managed_virtual_network_enabled  = true
  purview_id                       = var.existing_purview_account != null ? var.existing_purview_account.resource_id : null
  system_assigned_identity_enabled = true
  private_endpoint_enabled         = true
  private_endpoint_subnet_id       = module.networking.subnet_ids["vnet-services"]
  common_tags                      = var.common_tags
  existing_resource_group_name     = azurerm_resource_group.this[local.shared_integration_resource_group].name
  github_configuration             = var.github_configuration

  global_parameters = {
    "dataLakeStorageAccountName" = {
      type  = "String"
      value = module.storage["raw"].storageaccount_name
    }
    "landingStorageAccountName" = {
      type  = "String"
      value = module.storage["landing"].storageaccount_name
    }
  }

  managed_private_endpoints = merge({
    keyvault = {
      resource_id      = module.metadata_vault["meta001"].key_vault_id
      subresource_name = "vault"
    }
    mssql = {
      resource_id      = module.metadata_mssql.mssql_server_id
      subresource_name = "sqlServer"
    }
    raw-blob = {
      resource_id      = module.storage["raw"].storageaccount_id
      subresource_name = "blob"
    }
    raw-dfs = {
      resource_id      = module.storage["raw"].storageaccount_id
      subresource_name = "dfs"
    }
    curated-blob = {
      resource_id      = module.storage["curated"].storageaccount_id
      subresource_name = "blob"
    }
    curated-dfs = {
      resource_id      = module.storage["curated"].storageaccount_id
      subresource_name = "dfs"
    }
    landing-blob = {
      resource_id      = module.storage["landing"].storageaccount_id
      subresource_name = "blob"
    }
    landing-dfs = {
      resource_id      = module.storage["landing"].storageaccount_id
      subresource_name = "dfs"
    }
    keyvault = {
      resource_id      = module.metadata_vault["meta002"].key_vault_id
      subresource_name = "vault"
    }
    xcutting-blob = {
      resource_id      = module.storage["xcutting"].storageaccount_id
      subresource_name = "blob"
    }
    xcutting-dfs = {
      resource_id      = module.storage["xcutting"].storageaccount_id
      subresource_name = "dfs"
    }
  }, var.adf_deploy_purview_private_endpoints ? local.adf_managed_purview_endpoints : {})

  linked_key_vaults = {
    "${module.metadata_vault["meta001"].key_vault_name}" = {
      resource_id              = module.metadata_vault["meta001"].key_vault_id
      integration_runtime_name = "AutoResolveIntegrationRuntime"
    }
    "${module.metadata_vault["meta002"].key_vault_name}" = {
      resource_id              = module.metadata_vault["meta002"].key_vault_id
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

  linked_mssql_databases = {
    "${local.metadata_mssql_db_name}" = {
      server_fqdn              = module.metadata_mssql.fqdn
      database_name            = local.metadata_mssql_db_name
      integration_runtime_name = "AutoResolveIntegrationRuntime"
    }
  }

  linked_blob_storage = {
    "${module.storage["raw"].storageaccount_name}" = {
      service_endpoint         = module.storage["raw"].storageaccount_primary_blob_endpoint
      use_managed_identity     = true
      integration_runtime_name = "AutoResolveIntegrationRuntime"
    }
    "${module.storage["curated"].storageaccount_name}" = {
      service_endpoint         = module.storage["curated"].storageaccount_primary_blob_endpoint
      use_managed_identity     = true
      integration_runtime_name = "AutoResolveIntegrationRuntime"
    }
    "${module.storage["xcutting"].storageaccount_name}" = {
      service_endpoint         = module.storage["xcutting"].storageaccount_primary_blob_endpoint
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

resource "azurerm_monitor_diagnostic_setting" "shared_integration_datafactory" {
  name                       = "shared-integration-datafactory-diag"
  target_resource_id         = module.shared_integration_datafactory.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  enabled_log {
    category_group = "allLogs"
  }
  metric {
    category = "AllMetrics"
  }
}

resource "azurerm_role_assignment" "shared_integration_datafactory_storage" {
  for_each             = toset(["raw", "curated", "landing", "workspace", "external", "xcutting"])
  scope                = module.storage[each.key].storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.shared_integration_datafactory.identity.principal_id
}

resource "azurerm_role_assignment" "datafactory_databricks" {
  scope                = module.shared_integration_databricks.workspace_id
  role_definition_name = "Contributor"
  principal_id         = module.shared_integration_datafactory.identity.principal_id
}
