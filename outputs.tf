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

output "ingest00-meta002-sbox_kv_id" {
  value = data.azurerm_key_vault.ingest00-meta002-sbox.id
}
