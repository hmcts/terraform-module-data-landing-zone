module "metadata_vault" {
  for_each            = toset(local.metadata_vaults)
  source              = "github.com/hmcts/cnp-module-key-vault?ref=master"
  name                = "${local.name}-${each.key}-${var.env}"
  product             = "data-landing"
  env                 = var.env
  object_id           = data.azurerm_client_config.current.object_id
  location            = var.location
  resource_group_name = azurerm_resource_group.this["metadata"].name
  product_group_name  = local.admin_group
  common_tags         = var.common_tags
}

resource "azurerm_private_endpoint" "metadata_vault_pe" {
  for_each            = toset(local.metadata_vaults)
  name                = "${local.name}-${each.key}-pe-${var.env}"
  resource_group_name = azurerm_resource_group.this["metadata"].name
  location            = var.location
  subnet_id           = module.networking.subnet_ids["vnet-services"]
  tags                = var.common_tags

  private_service_connection {
    name                           = module.metadata_vault[each.key].key_vault_name
    is_manual_connection           = false
    private_connection_resource_id = module.metadata_vault[each.key].key_vault_id
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "endpoint-dnszonegroup"
    private_dns_zone_ids = ["/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]
  }
}

module "metadata_mssql" {
  source                          = "github.com/hmcts/terraform-module-mssql?ref=main"
  name                            = "${local.name}-metadata-mssql"
  env                             = var.env
  product                         = "data-landing"
  component                       = "metadata"
  enable_system_assigned_identity = true
  enable_private_endpoint         = true
  private_endpoint_subnet_id      = module.networking.subnet_ids["vnet-services"]
  common_tags                     = var.common_tags

  mssql_databases = {
    "${local.name}-metadata-db-${var.env}" = {
      collation                   = "SQL_Latin1_General_CP1_CI_AS"
      license_type                = "LicenseIncluded"
      max_size_gb                 = 1
      sku_name                    = "Basic"
      zone_redundant              = false
      create_mode                 = "Default"
      min_capacity                = 1
      geo_backup_enabled          = true
      auto_pause_delay_in_minutes = -1
    }
  }
}

resource "azurerm_key_vault_secret" "mssql_username" {
  name         = "${local.name}-metadata-mssql-username-${var.env}"
  value        = module.metadata_mssql.mssql_admin_username
  key_vault_id = module.metadata_vault["meta002"].key_vault_id
}

resource "azurerm_key_vault_secret" "mssql_password" {
  name         = "${local.name}-metadata-mssql-password-${var.env}"
  value        = module.metadata_mssql.mssql_admin_password
  key_vault_id = module.metadata_vault["meta002"].key_vault_id
}

resource "random_string" "mysql_username" {
  length  = 4
  special = false
}

resource "random_password" "mysql_password" {
  length           = 32
  special          = true
  override_special = "#$%&@()_[]{}<>:?"
  min_upper        = 4
  min_lower        = 4
  min_numeric      = 4
}

resource "azurerm_key_vault_secret" "mysql_username" {
  name         = "${local.name}-metadata-mysql-username-${var.env}"
  value        = "mysqladmin_${random_string.mysql_username.result}"
  key_vault_id = module.metadata_vault["meta002"].key_vault_id
}

resource "azurerm_key_vault_secret" "mysql_password" {
  name         = "${local.name}-metadata-mysql-password-${var.env}"
  value        = random_password.mysql_password.result
  key_vault_id = module.metadata_vault["meta002"].key_vault_id
}

resource "azurerm_key_vault_secret" "mysql_connection_string" {
  name         = "${local.name}-metadata-mysql-connection-string-${var.env}"
  value        = "jdbc:mysql://${azurerm_mysql_server.this.name}.mysql.database.azure.com:3306/${azurerm_mysql_database.this.name}?useSSL=true&requireSSL=false&enabledSslProtocolSuites=TLSv1.2"
  key_vault_id = module.metadata_vault["meta002"].key_vault_id
}

resource "azurerm_mysql_server" "this" {
  name                = "${local.name}-metadata-mysql-server-${var.env}"
  location            = var.location
  resource_group_name = azurerm_resource_group.this["metadata"].name

  administrator_login          = "mysqladmin_${random_string.mysql_username.result}"
  administrator_login_password = random_password.mysql_password.result

  sku_name   = "GP_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"

  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags
}

resource "azurerm_mysql_configuration" "this" {
  name                = "lower_case_table_names"
  resource_group_name = azurerm_resource_group.this["metadata"].name
  server_name         = azurerm_mysql_server.this.name
  value               = "2"
}

resource "azurerm_mysql_database" "this" {
  name                = "${local.name}-HiveMetastoreDb-${var.env}"
  resource_group_name = azurerm_resource_group.this["metadata"].name
  server_name         = azurerm_mysql_server.this.name
  charset             = "latin1" # TODO - check this with MS???
  collation           = "latin1_swedish_ci"
}

resource "azurerm_mysql_active_directory_administrator" "this" {
  server_name         = azurerm_mysql_server.this.name
  resource_group_name = azurerm_resource_group.this["metadata"].name
  login               = local.admin_group
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azuread_group.admin_group.object_id
}

resource "azurerm_private_endpoint" "metadata_mysql_pe" {
  name                = "${local.name}-metadata-mysql-pe-${var.env}"
  resource_group_name = azurerm_resource_group.this["metadata"].name
  location            = var.location
  subnet_id           = module.networking.subnet_ids["vnet-services"]
  tags                = var.common_tags

  private_service_connection {
    name                           = azurerm_mysql_server.this.name
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mysql_server.this.id
    subresource_names              = ["mysqlServer"]
  }

  private_dns_zone_group {
    name                 = "endpoint-dnszonegroup"
    private_dns_zone_ids = ["/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.mysql.database.windows.net"]
  }
}
