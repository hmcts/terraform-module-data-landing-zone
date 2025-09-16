module "metadata_vault" {
  for_each            = toset(local.metadata_vaults)
  source              = "github.com/hmcts/cnp-module-key-vault?ref=master"
  name                = length("${local.name}-${each.key}-${var.env}") > 24 ? "${local.short_name}-${each.key}-${var.env}" : "${local.name}-${each.key}-${var.env}"
  product             = "data-landing"
  env                 = var.env
  object_id           = data.azurerm_client_config.current.object_id
  location            = var.location
  resource_group_name = azurerm_resource_group.this[local.metadata_resource_group].name
  product_group_name  = local.admin_group
  common_tags         = var.common_tags
}

resource "azurerm_key_vault_access_policy" "metadata_vault_reders" {
  for_each     = { for product in setproduct(toset(var.key_vault_readers), toset(local.metadata_vaults)) : "${product[0]}-${product[1]}" => product }
  key_vault_id = module.metadata_vault[each.value[1]].key_vault_id

  object_id = each.value[0]
  tenant_id = data.azurerm_client_config.current.tenant_id

  secret_permissions = [
    "Get",
    "List"
  ]

  certificate_permissions = [
    "Get",
    "List"
  ]

  key_permissions = [
    "Get",
    "List"
  ]
}


resource "azurerm_key_vault_access_policy" "arm_secret_access" {
  for_each     = toset(local.metadata_vaults)
  key_vault_id = module.metadata_vault[each.key].key_vault_id

  object_id = var.arm_object_id
  tenant_id = data.azurerm_client_config.current.tenant_id

  secret_permissions = [
    "Get",
    "List",
    "Set"
  ]
}

module "metadata_vault_pe" {
  for_each = toset(local.metadata_vaults)
  source   = "./modules/azure-private-endpoint"

  depends_on = [module.vnet_peer_hub]

  name             = "${local.name}-${each.key}-pe-${var.env}"
  resource_group   = azurerm_resource_group.this[local.metadata_resource_group].name
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
  existing_resource_group_name    = azurerm_resource_group.this[local.metadata_resource_group].name
  admin_group                     = "DTS DLRM Data Ingestion Admin (env:${local.long_environment_name[var.env]})"

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
      auto_pause_delay_in_minutes = -1
    }
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.data_landing_link, module.vnet_peer_hub]
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
  existing_resource_group_name = azurerm_resource_group.this[local.metadata_resource_group].name
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

resource "random_string" "legacy_database_username" {
  for_each = var.legacy_databases
  length   = 4
  special  = false
}

resource "random_password" "legacy_database_password" {
  for_each         = var.legacy_databases
  length           = 16
  special          = true
  override_special = "#$%&@()_[]{}<>:?"
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
}

resource "azurerm_public_ip" "legacy_pip" {
  for_each            = { for k, v in var.legacy_databases : k => v if v.public_ip == true }
  name                = "${local.name}-${each.key}-pip-${var.env}"
  resource_group_name = azurerm_resource_group.this[local.metadata_resource_group].name
  location            = var.location
  allocation_method   = "Static"
  zones               = ["1"]
  sku                 = "Standard"
  tags                = var.common_tags
}

module "legacy_database" {
  for_each = var.legacy_databases

  providers = {
    azurerm     = azurerm
    azurerm.cnp = azurerm.cnp
    azurerm.soc = azurerm.soc
    azurerm.dcr = azurerm.dcr
  }

  source               = "github.com/hmcts/terraform-module-virtual-machine.git?ref=feat%2Fcustom-image"
  vm_type              = each.value.type
  vm_name              = "${local.name}-${each.key}-${var.env}"
  computer_name        = each.value.computer_name == null ? "${each.key}-${var.env}" : each.value.computer_name
  vm_location          = var.location
  vm_size              = each.value.size
  vm_admin_name        = "admin_${random_string.legacy_database_username[each.key].result}"
  vm_admin_password    = random_password.legacy_database_password[each.key].result
  vm_availabilty_zones = "1"
  os_disk_size_gb      = each.value.os_disk_size_gb
  vm_resource_group    = azurerm_resource_group.this[local.metadata_resource_group].name
  vm_subnet_id         = module.networking.subnet_ids["vnet-services"]
  nic_name             = "${local.name}-${each.key}-nic-${var.env}"
  ipconfig_name        = "${local.name}-${each.key}-ipconfig-${var.env}"
  privateip_allocation = "Dynamic"
  vm_public_ip_address = each.value.public_ip ? azurerm_public_ip.legacy_pip[each.key].id : null

  nessus_install             = false
  install_splunk_uf          = false
  install_dynatrace_oneagent = false
  install_azure_monitor      = var.install_azure_monitor

  systemassigned_identity = var.systemassigned_identity

  vm_publisher_name = each.value.publisher_name
  vm_offer          = each.value.offer
  vm_sku            = each.value.sku
  vm_version        = each.value.version
  source_image_id   = each.value.source_image_id

  secure_boot_enabled = each.value.secure_boot_enabled

  vm_patch_assessment_mode = null
  vm_patch_mode            = null
  aum_schedule_enable      = false

  env  = var.env
  tags = var.common_tags
}

resource "azurerm_virtual_machine_extension" "custom_script" {
  for_each                   = { for k, v in var.legacy_databases : k => v if v.bootstrap_script != null }
  name                       = "${local.name}-${each.key}-${var.env}-bootstrap"
  virtual_machine_id         = module.legacy_database[each.key].vm_id
  publisher                  = lower(each.value.type) == "linux" ? "Microsoft.Azure.Extensions" : lower(each.value.type) == "windows" ? "Microsoft.Compute" : null
  type                       = lower(each.value.type) == "linux" ? "CustomScript" : lower(each.value.type) == "windows" ? "CustomScriptExtension" : null
  type_handler_version       = lower(each.value.type) == "linux" ? "2.1" : "1.10"
  auto_upgrade_minor_version = false
  protected_settings         = <<PROTECTED_SETTINGS
    {
      %{if lower(each.value.type) == "linux"}
      "script": "${each.value.bootstrap_script}"
      %{else}
      "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${each.value.bootstrap_script}')) | Out-File -filepath bootstrap_vm.ps1\" && powershell -ExecutionPolicy Unrestricted -File bootstrap_vm.ps1",
      %{endif}
    }
    PROTECTED_SETTINGS

  tags = var.common_tags
}

resource "azurerm_key_vault_secret" "legacy_database_username" {
  for_each     = var.legacy_databases
  name         = "${local.name}-${each.key}-username-${var.env}"
  value        = "admin_${random_string.legacy_database_username[each.key].result}"
  key_vault_id = module.metadata_vault["meta002"].key_vault_id
  depends_on   = [module.metadata_vault, module.metadata_vault_pe]
}

resource "azurerm_key_vault_secret" "legacy_database_password" {
  for_each     = var.legacy_databases
  name         = "${local.name}-${each.key}-password-${var.env}"
  value        = random_password.legacy_database_password[each.key].result
  key_vault_id = module.metadata_vault["meta002"].key_vault_id
  depends_on   = [module.metadata_vault, module.metadata_vault_pe]
}
