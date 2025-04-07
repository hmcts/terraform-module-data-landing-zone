# Row 1-55 are Databricks secrets
#Store Service Principal credentials in Key Vault (Client ID)

resource "azurerm_key_vault_secret" "client_id" {
  name         = "databricks-sp-client-id"
  value        = data.azurerm_client_config.current.client_id
  key_vault_id = "ingest00-meta002-${var.env}"
}

# Store Service Principal credentials in Key Vault (Client Secret)

resource "azurerm_key_vault_secret" "client_secret" {
  name         = "databricks-sp-client-secret"
  value        = var.client_secret
  key_vault_id = "ingest00-meta002-${var.env}"
}

# Store Service Principal credentials in Key Vault (Tenant ID)

resource "azurerm_key_vault_secret" "tenant_id" {
  name         = "databricks-sp-tenant-id"
  value        = data.azurerm_client_config.current.tenant_id
  key_vault_id = "ingest00-meta002-${var.env}"
}

# Store secrets in Databricks
resource "databricks_secret_scope" "key-vault-secrets" {
  name       = "key-vault-secrets"
  depends_on = [var.databricks_workspace_id]
}

# Store Client ID in Databricks
resource "databricks_secret" "client_id" {
  key          = "client-id"
  string_value = data.azurerm_client_config.current.client_id
  scope        = databricks_secret_scope.key-vault-secrets.name
}

# Store Client secret in Databricks
resource "databricks_secret" "client_secret" {
  key          = "client-secret"
  string_value = var.client_secret
  scope        = databricks_secret_scope.key-vault-secrets.name
}

# Store Tenant ID in Databricks
resource "databricks_secret" "tenant_id" {
  key          = "tenant-id"
  string_value = data.azurerm_client_config.current.tenant_id
  scope        = databricks_secret_scope.key-vault-secrets.name
}

# Create Databricks token
resource "azurerm_key_vault_secret" "databricks_token" {
  name         = "databricks-token"
  value        = var.databricks_token
  key_vault_id = azurerm_key_vault.ingest00-meta002.id
}