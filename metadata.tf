module "metadata_vault" {
  for_each            = toset(local.metadata_vaults)
  source              = "github.com/hmcts/cnp-module-key-vault?ref=master"
  name                = length("${local.name}-${each.key}-${var.env}") > 24 ? "${local.short_name}-${each.key}-${var.env}" : "${local.name}-${each.key}-${var.env}"
  product             = "data-landing"
  env                 = var.env
  object_id           = data.azurerm_client_config.current.object_id
  location            = var.location
  resource_group_name = azurerm_resource_group.this["metadata"].name
  product_group_name  = local.admin_group
  common_tags         = var.common_tags
}

module "metadata_vault_pe" {
  for_each = toset(local.metadata_vaults)
  source   = "./modules/azure-private-endpoint"

  depends_on = [module.vnet_peer_hub]

  name             = "${local.name}-${each.key}-pe-${var.env}"
  resource_group   = azurerm_resource_group.this["metadata"].name
  location         = var.location
  subnet_id        = module.networking.subnet_ids["vnet-services"]
  common_tags      = var.common_tags
  resource_name    = module.metadata_vault[each.key].key_vault_name
  resource_id      = module.metadata_vault[each.key].key_vault_id
  subresource_name = "vault"
}

module "metadata_mssql" {
  source = "github.com/hmcts/terraform-module-mssql?ref=main"

  name                            = "${local.name}-metadata-mssql"
  env                             = var.env
  product                         = "data-landing"
  component                       = "metadata"
  enable_system_assigned_identity = true
  enable_private_endpoint         = true
  private_endpoint_subnet_id      = module.networking.subnet_ids["vnet-services"]
  common_tags                     = var.common_tags
  existing_resource_group_name    = azurerm_resource_group.this["metadata"].name

  mssql_databases = {
    "${local.metadata_mssql_db_name}" = {
      collation                   = "SQL_Latin1_General_CP1_CI_AS"
      license_type                = "LicenseIncluded"
      max_size_gb                 = 1
      sku_name                    = "Basic"
      zone_redundant              = false
      create_mode                 = "Default"
      min_capacity                = 0
      geo_backup_enabled          = true
      auto_pause_delay_in_minutes = 0
    }
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.data_landing_link, module.vnet_peer_hub]
}
module "vm_database" {
  providers = {
    azurerm     = azurerm
    azurerm.cnp = azurerm.cnp
    azurerm.soc = azurerm.soc
  }

  source               = "github.com/hmcts/terraform-module-virtual-machine.git"
  vm_type              = local.vm_type
  vm_name              = "${local.name}-metadata-sql-vm"
  vm_location          = var.location
  vm_size              = local.vm_size
  vm_admin_name        = "sql_${random_string.vm_username.result}"
  vm_admin_password    = random_password.vm_password.result
  vm_availabilty_zones = var.vm_availability_zones
  os_disk_size_gb      = 127
  vm_resource_group    = azurerm_resource_group.this["metadata"].name
  vm_subnet_id         = module.networking.subnet_ids["vnet-services"]


nic_name      = lower("SQL-VM-nic-${var.env}")
  ipconfig_name = local.ipconfig_name


  #storage_image_reference
  vm_publisher_name = local.marketplace_publisher
  vm_offer          = local.marketplace_product
  vm_sku            = local.marketplace_sku
  vm_version        = local.vm_version

  env  = var.env
  tags = var.common_tags
}



resource "azurerm_key_vault_secret" "mssql_username" {
  name         = "${local.name}-metadata-mssql-username-${var.env}"
  value        = module.metadata_mssql.mssql_admin_username
  key_vault_id = module.metadata_vault["meta002"].key_vault_id
  depends_on   = [module.metadata_vault, module.metadata_vault_pe]
}

resource "azurerm_key_vault_secret" "mssql_password" {
  name         = "${local.name}-metadata-mssql-password-${var.env}"
  value        = module.metadata_mssql.mssql_admin_password
  key_vault_id = module.metadata_vault["meta002"].key_vault_id
  depends_on   = [module.metadata_vault, module.metadata_vault_pe]
}

module "metadata_mysql" {
  source                       = "github.com/hmcts/terraform-module-mysql-flexible?ref=main"
  name                         = "${local.name}-metadata-mysql"
  env                          = var.env
  product                      = "data-landing"
  component                    = "metadata"
  common_tags                  = var.common_tags
  existing_resource_group_name = azurerm_resource_group.this["metadata"].name
  delegated_subnet_id          = module.networking.subnet_ids["vnet-services-mysql"]
  storage_size_gb              = 20

  mysql_version = "5.7"
  mysql_databases = {
    "${local.name}-HiveMetastoreDb-${var.env}" = {}
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.data_landing_link, module.vnet_peer_hub]
}

resource "azurerm_key_vault_secret" "mysql_username" {
  name         = "${local.name}-metadata-mysql-username-${var.env}"
  value        = module.metadata_mysql.username
  key_vault_id = module.metadata_vault["meta002"].key_vault_id
  depends_on   = [module.metadata_vault, module.metadata_vault_pe]
}

resource "azurerm_key_vault_secret" "mysql_password" {
  name         = "${local.name}-metadata-mysql-password-${var.env}"
  value        = module.metadata_mysql.password
  key_vault_id = module.metadata_vault["meta002"].key_vault_id
  depends_on   = [module.metadata_vault, module.metadata_vault_pe]
}

resource "azurerm_key_vault_secret" "mysql_connection_string" {
  name         = "${local.name}-metadata-mysql-connection-string-${var.env}"
  value        = "jdbc:mysql://${module.metadata_mysql.fqdn}/${local.name}-HiveMetastoreDb-${var.env}?useSSL=true&requireSSL=false&enabledSslProtocolSuites=TLSv1.2"
  key_vault_id = module.metadata_vault["meta002"].key_vault_id
  depends_on   = [module.metadata_vault, module.metadata_vault_pe]
}
