module "storage" {
  source = "github.com/hmcts/cnp-module-storage-account?ref=feat%2Finfra-encryption-4.x"

  depends_on = [module.vnet_peer_hub]

  for_each                          = local.storage_accounts
  env                               = var.env
  storage_account_name              = length(replace("${local.name}${each.key}${var.env}", "-", "")) > 24 ? lower(replace("${local.short_name}${each.key}${var.env}", "-", "")) : lower(replace("${local.name}${each.key}${var.env}", "-", ""))
  resource_group_name               = azurerm_resource_group.this[each.value.resource_group_key].name
  location                          = var.location
  account_kind                      = var.storage_account_kind
  account_tier                      = var.storage_account_tier
  account_replication_type          = var.storage_account_replication_type
  enable_hns                        = true
  enable_sftp                       = each.key == "sftp" ? true : false
  enable_nfs                        = false
  containers                        = each.value.containers
  enable_data_protection            = true
  enable_versioning                 = false
  pim_roles                         = {}
  infrastructure_encryption_enabled = true

  defender_enabled                  = true
  defender_malware_scanning_enabled = true

  public_network_access_enabled = each.key == "sftp" ? true : null
  default_action                = each.key == "sftp" ? "Allow" : "Deny"

  sa_subnets = [
    data.azurerm_subnet.ssptl-00.id,
    data.azurerm_subnet.ssptl-01.id
  ]
  team_contact = "#dtspo-orange"
  common_tags  = var.common_tags
}

resource "azurerm_storage_account_local_user" "this" {
  for_each             = { for key, value in local.storage_accounts : key => value if key == "sftp" }
  name                 = "sftpuser"
  storage_account_id   = module.storage["sftp"].storageaccount_id
  ssh_key_enabled      = true
  ssh_password_enabled = false
  home_directory       = "sftp"
  permission_scope {
    permissions {
      read   = true
      write  = true
      delete = true
      list   = true
      create = true
    }
    service       = "blob"
    resource_name = "sftp"
  }
  ssh_authorized_key {
    key         = tls_private_key.sftpkey[each.key].public_key_openssh
    description = "https://portal.azure.com/#@HMCTS.NET/asset/Microsoft_Azure_KeyVault/Secret/${azurerm_key_vault_secret.sftpkey[each.key].versionless_id}"
  }
}

resource "tls_private_key" "sftpkey" {
  for_each  = { for key, value in local.storage_accounts : key => value if key == "sftp" }
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "sftpkey" {
  for_each     = { for key, value in local.storage_accounts : key => value if key == "sftp" }
  name         = "${length(replace("${local.name}${each.key}${var.env}", "-", "")) > 24 ? lower(replace("${local.short_name}${each.key}${var.env}", "-", "")) : lower(replace("${local.name}${each.key}${var.env}", "-", ""))}-sftpkey"
  value        = tls_private_key.sftpkey[each.key].private_key_openssh
  key_vault_id = module.metadata_vault["meta002"].key_vault_id
  depends_on   = [module.metadata_vault, module.metadata_vault_pe]
}

module "storage_pe" {
  for_each = { for value in local.flattened_storage_accounts_private_endpoints : "${value.storage_account}-${value.private_endpoint}" => value }
  source   = "./modules/azure-private-endpoint"

  depends_on = [module.vnet_peer_hub]

  name             = "${local.name}-${each.key}-pe-${var.env}"
  resource_group   = azurerm_resource_group.this[each.value.resource_group_key].name
  location         = var.location
  subnet_id        = module.networking.subnet_ids["vnet-services"]
  common_tags      = var.common_tags
  resource_name    = module.storage[each.value.storage_account].storageaccount_name
  resource_id      = module.storage[each.value.storage_account].storageaccount_id
  subresource_name = each.value.private_endpoint
}

resource "azurerm_storage_management_policy" "this" {
  for_each           = local.storage_accounts
  storage_account_id = module.storage[each.key].storageaccount_id

  rule {
    name    = "default"
    enabled = true
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than = 90
      }
      snapshot {
        change_tier_to_cool_after_days_since_creation = 90
      }
      version {
        change_tier_to_cool_after_days_since_creation = 90
      }
    }
    filters {
      blob_types   = ["blockBlob"]
      prefix_match = []
    }
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  for_each           = local.storage_accounts
  name               = "${local.name}-${each.key}-${var.env}"
  storage_account_id = module.storage[each.key].storageaccount_id
}
