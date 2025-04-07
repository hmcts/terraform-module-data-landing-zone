resource "azurerm_user_assigned_identity" "databricks_identity" {
  name                = "databricks-sql-identity"
  resource_group_name = "ingest00-main-${var.env}"
  location            = var.location
}

resource "azurerm_role_assignment" "blob_storage_access" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/ingest00-main-${var.env}/providers/Microsoft.Storage/storageAccounts/${var.curated_storage_account_name}"
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.databricks_identity.principal_id
}
