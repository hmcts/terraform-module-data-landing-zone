module "logging_vault" {
  source              = "github.com/hmcts/cnp-module-key-vault?ref=master"
  name                = "${local.name}-logging-${var.env}"
  product             = "data-landing"
  env                 = var.env
  object_id           = data.azurerm_client_config.current.object_id
  location            = var.location
  resource_group_name = azurerm_resource_group.this["logging"].name
  product_group_name  = local.admin_group
  common_tags         = var.common_tags
}

resource "azurerm_private_endpoint" "logging_vault_pe" {
  name                = "${local.name}-keyVault001-pe-${var.env}"
  resource_group_name = azurerm_resource_group.this["logging"].name
  location            = var.location
  subnet_id           = module.networking.subnet_ids["vnet-services"]
  tags                = var.common_tags

  private_service_connection {
    name                           = module.logging_vault.key_vault_name
    is_manual_connection           = false
    private_connection_resource_id = module.logging_vault.key_vault_id
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "endpoint-dnszonegroup"
    private_dns_zone_ids = ["/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]
  }
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
