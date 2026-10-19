output "resource_groups" {
  value = [for rg in azurerm_resource_group.this : {
    name     = rg.name
    location = rg.location
    id       = rg.id
  }]
}

output "subnet_ids" {
  value = module.networking.subnet_ids
}

output "metadata_mssql" {
  value = {
    server_name  = module.metadata_mssql.mssql_server_name
    fqdn         = module.metadata_mssql.fqdn
    id           = module.metadata_mssql.mssql_server_id
    database_ids = module.metadata_mssql.mssql_database_ids
  }
}

output "additional_paas_databases" {
  description = "Details of the additional PaaS databases created."
  value = merge(
    { for k, v in azurerm_postgresql_flexible_server.this : k => {
      type = "postgresql"
      id   = v.id
      fqdn = v.fqdn
      name = v.name
    } },
    { for k, v in azurerm_mysql_flexible_server.this : k => {
      type = "mysql"
      id   = v.id
      fqdn = v.fqdn
      name = v.name
    } },
    { for k, v in azurerm_mssql_server.paas : k => {
      type        = "mssql"
      id          = v.id
      fqdn        = v.fully_qualified_domain_name
      name        = v.name
      database_id = azurerm_mssql_database.paas[k].id
    } }
  )
}

output "log_analytics_workspace" {
  description = "Details of the Log Analytics workspace used by the data landing zone."
  value = {
    id                  = azurerm_log_analytics_workspace.this.id
    name                = azurerm_log_analytics_workspace.this.name
    resource_group_name = azurerm_log_analytics_workspace.this.resource_group_name
    location            = azurerm_log_analytics_workspace.this.location
    workspace_id        = azurerm_log_analytics_workspace.this.workspace_id
  }
}
