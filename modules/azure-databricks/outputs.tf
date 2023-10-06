output "workspace_id" {
  value = azurerm_databricks_workspace.this.id
}

output "workspace_name" {
  value = azurerm_databricks_workspace.this.name
}

output "workspace_url" {
  value = azurerm_databricks_workspace.this.workspace_url
}
