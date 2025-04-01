data "azurerm_client_config" "current" {}

# Retrieve  ingest00-meta002-sbox kv
data "azurerm_key_vault" "ingest00-meta002-sbox" {
  name                = "ingest00-meta002-sbox"
  resource_group_name = var.resource_group_name
}