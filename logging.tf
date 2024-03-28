module "logging_vault" {
  source              = "github.com/hmcts/cnp-module-key-vault?ref=master"
  name                = length("${local.name}-logging-${var.env}") > 24 ? "${local.short_name}-logging-${var.env}" : "${local.name}-logging-${var.env}"
  product             = "data-landing"
  env                 = var.env
  object_id           = data.azurerm_client_config.current.object_id
  location            = var.location
  resource_group_name = azurerm_resource_group.this[local.logging_resource_group].name
  product_group_name  = local.admin_group
  common_tags         = var.common_tags
}

resource "azurerm_key_vault_access_policy" "logging_vault_reders" {
  for_each     = toset(var.key_vault_readers)
  key_vault_id = module.logging_vault.key_vault_id

  object_id = each.value
  tenant_id = data.azurerm_client_config.current.tenant_id

  secret_permissions = [
    "Get",
    "List"
  ]

  certificate_permissions = [
    "Get",
    "List"
  ]

  key_permissions = [
    "Get",
    "List"
  ]
}

module "logging_vault_pe" {
  source = "./modules/azure-private-endpoint"

  depends_on = [module.vnet_peer_hub]

  name             = "${local.name}-keyVault001-pe-${var.env}"
  resource_group   = azurerm_resource_group.this[local.logging_resource_group].name
  location         = var.location
  subnet_id        = module.networking.subnet_ids["vnet-services"]
  common_tags      = var.common_tags
  resource_name    = module.logging_vault.key_vault_name
  resource_id      = module.logging_vault.key_vault_id
  subresource_name = "vault"
}

resource "azurerm_log_analytics_workspace" "this" {
  name                       = "${local.name}-logAnalytics001-${var.env}"
  resource_group_name        = azurerm_resource_group.this[local.logging_resource_group].name
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
  depends_on   = [module.logging_vault, module.logging_vault_pe]
}

resource "azurerm_key_vault_secret" "log_analytics_workspace_secret" {
  name         = "${azurerm_log_analytics_workspace.this.name}-key"
  value        = azurerm_log_analytics_workspace.this.primary_shared_key
  key_vault_id = module.logging_vault.key_vault_id
  depends_on   = [module.logging_vault, module.logging_vault_pe]
}
