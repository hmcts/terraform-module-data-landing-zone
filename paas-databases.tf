# --- Credentials -----------------------------------------------------------
resource "random_string" "paas_db_username" {
  for_each = var.additional_paas_databases
  length   = 4
  special  = false
}

resource "random_password" "paas_db_password" {
  for_each         = var.additional_paas_databases
  length           = 16
  special          = true
  override_special = "#$%&@()_[]{}<>:?"
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
}

# --- PostgreSQL Flexible Servers -------------------------------------------
resource "azurerm_postgresql_flexible_server" "this" {
  for_each = local.paas_db_postgresql

  name                = "${local.name}-${each.key}-${var.env}"
  resource_group_name = azurerm_resource_group.this[local.metadata_resource_group].name
  location            = var.location

  sku_name   = each.value.sku_name
  version    = each.value.version
  storage_mb = each.value.storage_mb

  administrator_login    = "psqladmin${random_string.paas_db_username[each.key].result}"
  administrator_password = random_password.paas_db_password[each.key].result

  delegated_subnet_id           = module.networking.subnet_ids["vnet-services-paasdb-postgresql"]
  private_dns_zone_id           = data.azurerm_private_dns_zone.cftptl["privatelink.postgres.database.azure.com"].id
  public_network_access_enabled = false
  
  lifecycle {
    ignore_changes = [ zone ]
  }

  geo_redundant_backup_enabled = each.value.geo_redundant_backup_enabled

  tags = var.common_tags
}

# --- MySQL Flexible Servers ------------------------------------------------
resource "azurerm_mysql_flexible_server" "this" {
  for_each = local.paas_db_mysql

  name                = "${local.name}-${each.key}-${var.env}"
  resource_group_name = azurerm_resource_group.this[local.metadata_resource_group].name
  location            = var.location

  sku_name = each.value.sku_name
  version  = each.value.version

  administrator_login    = "mysqladmin${random_string.paas_db_username[each.key].result}"
  administrator_password = random_password.paas_db_password[each.key].result

  delegated_subnet_id = module.networking.subnet_ids["vnet-services-paasdb-mysql"]
  private_dns_zone_id = data.azurerm_private_dns_zone.cftptl["privatelink.mysql.database.azure.com"].id

  geo_redundant_backup_enabled = each.value.geo_redundant_backup_enabled

  storage {
    size_gb = each.value.storage_mb != null ? ceil(each.value.storage_mb / 1024) : 32
  }

  tags = var.common_tags
}

# --- Azure SQL (MSSQL) Servers and Databases --------------------------------
resource "azurerm_mssql_server" "paas" {
  for_each = local.paas_db_mssql

  name                         = "${local.name}-${each.key}-${var.env}"
  resource_group_name          = azurerm_resource_group.this[local.metadata_resource_group].name
  location                     = var.location
  version                      = each.value.version
  administrator_login          = "sqladmin${random_string.paas_db_username[each.key].result}"
  administrator_login_password = random_password.paas_db_password[each.key].result

  minimum_tls_version           = "1.2"
  public_network_access_enabled = false

  azuread_administrator {
    login_username = local.admin_group
    object_id      = data.azuread_group.admin_group.object_id
    tenant_id      = data.azurerm_client_config.current.tenant_id
  }

  tags = var.common_tags
}

resource "azurerm_mssql_database" "paas" {
  for_each = local.paas_db_mssql

  name      = each.key
  server_id = azurerm_mssql_server.paas[each.key].id
  sku_name  = each.value.sku_name
  collation = each.value.collation != null ? each.value.collation : "SQL_Latin1_General_CP1_CI_AS"

  max_size_gb    = each.value.max_size_gb
  zone_redundant = false

  geo_backup_enabled = each.value.geo_redundant_backup_enabled

  tags = var.common_tags
}

# Private endpoints for MSSQL (Azure SQL uses PE instead of VNet injection)
module "paas_mssql_pe" {
  for_each = local.paas_db_mssql
  source   = "./modules/azure-private-endpoint"

  depends_on = [module.vnet_peer_hub]

  name             = "${local.name}-${each.key}-pe-${var.env}"
  resource_group   = azurerm_resource_group.this[local.metadata_resource_group].name
  location         = var.location
  subnet_id        = module.networking.subnet_ids["vnet-services"]
  common_tags      = var.common_tags
  resource_name    = azurerm_mssql_server.paas[each.key].name
  resource_id      = azurerm_mssql_server.paas[each.key].id
  subresource_name = "sqlServer"
}

# --- Key Vault Secrets -----------------------------------------------------
resource "azurerm_key_vault_secret" "paas_db_username" {
  for_each = var.additional_paas_databases

  name = "${local.name}-${each.key}-username-${var.env}"
  value = (
    each.value.type == "postgresql" ? "psqladmin${random_string.paas_db_username[each.key].result}" :
    each.value.type == "mysql" ? "mysqladmin${random_string.paas_db_username[each.key].result}" :
    "sqladmin${random_string.paas_db_username[each.key].result}"
  )
  key_vault_id = module.metadata_vault["meta002"].key_vault_id
  depends_on   = [module.metadata_vault, module.metadata_vault_pe]
}

resource "azurerm_key_vault_secret" "paas_db_password" {
  for_each = var.additional_paas_databases

  name         = "${local.name}-${each.key}-password-${var.env}"
  value        = random_password.paas_db_password[each.key].result
  key_vault_id = module.metadata_vault["meta002"].key_vault_id
  depends_on   = [module.metadata_vault, module.metadata_vault_pe]
}
