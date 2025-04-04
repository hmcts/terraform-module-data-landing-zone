# Return key-vault id
output "key_vault_id" {
  value = azurerm_key_vault.ingest00-meta002-sbox.id
}

# Return key-vault name
output "key-vault-name" {
  value = azurerm_key_vault.ingest00-meta002-sbox.name
}

# Return databricks secret (PAT) value
output "databricks_token_value" {
  value     = azurerm_key_vault_secret.databricks_token.value
  sensitive = true
}
