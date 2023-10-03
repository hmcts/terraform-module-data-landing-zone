module "logging_vault" {
  source                     = "github.com/hmcts/cnp-module-key-vault?ref=master"
  name                       = "${local.name}-keyVault001-${var.env}"
  product                    = "data-landing"
  env                        = var.env
  object_id                  = data.azurerm_client_config.current.object_id
  location                   = var.location
  resource_group_name        = azurerm_resource_group.this["logging"].name
  private_endpoint_subnet_id = module.networking.subnet_ids["services"]
  product_group_name         = local.is_prod ? "DTS Platform Operations" : "DTS Platform Operations SC" # TODO: update this to a data landing zone product group
  common_tags                = var.common_tags
}

resource "azurerm_log_analytics_workspace" "this" {
  name                       = "${local.name}-logAnalytics001-${var.env}"
  resource_group_name        = azurerm_resource_group.this["logging"].name
  location                   = var.location
  internet_ingestion_enabled = true
  internet_query_enabled     = true
  sku                        = local.log_analytics_sku
  tags                       = var.common_tags
}

resource "azurerm_key_vault_secret" "log_analytics_workspace_id" {
  name         = "${azurerm_log_analytics_workspace.this.name}-id}"
  value        = azurerm_log_analytics_workspace.this.workspace_id
  key_vault_id = module.logging_vault.key_vault_id
}

resource "azurerm_key_vault_secret" "log_analytics_workspace_secret" {
  name         = "${azurerm_log_analytics_workspace.this.name}-key}"
  value        = azurerm_log_analytics_workspace.this.primary_shared_key
  key_vault_id = module.logging_vault.key_vault_id
}
