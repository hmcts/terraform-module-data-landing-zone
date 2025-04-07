data "azurerm_client_config" "current" {}

# Retrieve  ingest00-meta002 kv
data "azurerm_key_vault" "ingest00-meta002" {
  name                = "ingest00-meta002-${var.env}"
  resource_group_name = "ingest00-main-${var.env}"
}