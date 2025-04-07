# Return key-vault id
output "key_vault_id" {
  value = data.azurerm_key_vault.ingest00-meta002.id
}

# Return key-vault name
output "key-vault-name" {
  value = data.azurerm_key_vault.ingest00-meta002.name
}

# Return databricks secret (PAT) value
output "databricks_token_value" {
  value     = azurerm_key_vault_secret.databricks_token.value
  sensitive = true
}
