module "logging_vault" {
  source              = "github.com/hmcts/cnp-module-key-vault?ref=master"
  name                = length("${local.name}-logging-${var.env}") > 24 ? "${local.short_name}-logging-${var.env}" : "${local.name}-logging-${var.env}"
  product             = "data-landing"
  env                 = var.env
  object_id           = data.azurerm_client_config.current.object_id
  location            = var.location
  resource_group_name = azurerm_resource_group.this["logging"].name
  product_group_name  = local.admin_group
  common_tags         = var.common_tags
}

module "logging_vault_pe" {
  source = "./modules/azure-private-endpoint"

  name             = "${local.name}-keyVault001-pe-${var.env}"
  resource_group   = azurerm_resource_group.this["logging"].name
  location         = var.location
  subnet_id        = module.networking.subnet_ids["vnet-services"]
  common_tags      = var.common_tags
  resource_name    = module.logging_vault.key_vault_name
  resource_id      = module.logging_vault.key_vault_id
  subresource_name = "vault"
}

resource "azurerm_log_analytics_workspace" "this" {
  name                       = "${local.name}-logAnalytics001-${var.env}"
  resource_group_name        = azurerm_resource_group.this["logging"].name
  location                   = var.location
  internet_ingestion_enabled = true
  internet_query_enabled     = true
  sku                        = var.log_analytics_sku
  tags                       = var.common_tags
}

resource "azurerm_key_vault_secret" "log_analytics_workspace_id" {
  name         = "${azurerm_log_analytics_workspace.this.name}-id"
  value        = azurerm_log_analytics_workspace.this.workspace_id
  key_vault_id = module.logging_vault.key_vault_id
}

resource "azurerm_key_vault_secret" "log_analytics_workspace_secret" {
  name         = "${azurerm_log_analytics_workspace.this.name}-key"
  value        = azurerm_log_analytics_workspace.this.primary_shared_key
  key_vault_id = module.logging_vault.key_vault_id
}
