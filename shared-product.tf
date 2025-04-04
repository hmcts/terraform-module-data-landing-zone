module "shared_product_databricks" {
  source = "github.com/hmcts/terraform-module-databricks?ref=main"

  providers = {
    databricks = databricks
  }

  env                          = var.env
  product                      = "data-landing"
  component                    = "shared-integration"
  name                         = "${local.name}-product-databricks001"
  existing_resource_group_name = azurerm_resource_group.this[local.shared_product_resource_group].name
  location                     = var.location
  common_tags                  = var.common_tags
  vnet_id                      = module.networking.vnet_ids["vnet"]
  public_subnet_name           = module.networking.subnet_names["vnet-data-bricks-product-public"]
  public_subnet_nsg_id         = module.networking.network_security_groups_ids["nsg"]
  private_subnet_name          = module.networking.subnet_names["vnet-data-bricks-product-private"]
  private_subnet_nsg_id        = module.networking.network_security_groups_ids["nsg"]
}

resource "random_password" "synapse_sql_password" {
  length           = 32
  special          = true
  override_special = "#$%&@()_[]{}<>:?"
  min_upper        = 4
  min_lower        = 4
  min_numeric      = 4
}

resource "azurerm_key_vault_secret" "synapse_sql_password" {
  name         = "${local.name}-product-synapse001-sql-password-${var.env}"
  value        = random_password.synapse_sql_password.result
  key_vault_id = module.metadata_vault["meta001"].key_vault_id
  depends_on   = [module.metadata_vault, module.metadata_vault_pe]
}

resource "azurerm_key_vault_secret" "synapse_sql_username" {
  name         = "${local.name}-product-synapse001-sql-username-${var.env}"
  value        = "sqladminuser"
  key_vault_id = module.metadata_vault["meta001"].key_vault_id
  depends_on   = [module.metadata_vault, module.metadata_vault_pe]
}

resource "azurerm_synapse_workspace" "this" {
  name                                 = "${local.name}-product-synapse001-${var.env}"
  resource_group_name                  = azurerm_resource_group.this[local.shared_product_resource_group].name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.this["workspace"].id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = random_password.synapse_sql_password.result
  sql_identity_control_enabled         = true
  data_exfiltration_protection_enabled = false
  managed_virtual_network_enabled      = true
  managed_resource_group_name          = "${local.name}-product-synapse001"
  purview_id                           = var.existing_purview_account == null ? null : var.existing_purview_account.resource_id

  identity {
    type = "SystemAssigned"
  }

  timeouts {
    create = "2h"
    delete = "2h"
  }

  tags = var.common_tags

  depends_on = [module.vnet_peer_hub]
}

resource "azurerm_synapse_workspace_aad_admin" "aad" {
  synapse_workspace_id = azurerm_synapse_workspace.this.id
  login                = local.admin_group
  object_id            = data.azuread_group.admin_group.object_id
  tenant_id            = data.azurerm_client_config.current.tenant_id
}
resource "azurerm_synapse_sql_pool" "this" {
  count                = var.enable_synapse_sql_pool ? 1 : 0
  name                 = "${local.name}-product-synapse001-sql001-${var.env}"
  synapse_workspace_id = azurerm_synapse_workspace.this.id
  sku_name             = "DW100c"
  create_mode          = "Default"
  storage_account_type = "GRS"

  tags = var.common_tags
}

resource "azurerm_synapse_spark_pool" "this" {
  count                = var.enable_synapse_spark_pool ? 1 : 0
  name                 = "${local.name}-product-synapse001-spark001-${var.env}"
  synapse_workspace_id = azurerm_synapse_workspace.this.id
  node_size_family     = "MemoryOptimized"
  node_size            = "Small"
  cache_size           = 100

  auto_scale {
    max_node_count = 10
    min_node_count = 3
  }

  auto_pause {
    delay_in_minutes = 15
  }

  spark_version = "3.2"
  tags          = var.common_tags
}

module "synapse_pe" {
  for_each = toset(["sql", "sqlOnDemand", "dev"])
  source   = "./modules/azure-private-endpoint"

  name             = "${local.name}-product-synapse001-${each.key}-pe-${var.env}"
  resource_group   = azurerm_resource_group.this[local.shared_product_resource_group].name
  location         = var.location
  subnet_id        = module.networking.subnet_ids["vnet-services"]
  common_tags      = var.common_tags
  resource_name    = azurerm_synapse_workspace.this.name
  resource_id      = azurerm_synapse_workspace.this.id
  subresource_name = each.value
}
