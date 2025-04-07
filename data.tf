data "azurerm_client_config" "current" {}

# Retrieve  ingest00-meta002 kv
data "azurerm_key_vault" "ingest00-meta002" {
  name                = "ingest00-meta002-${var.env}"
  resource_group_name = var.resource_group_name
}