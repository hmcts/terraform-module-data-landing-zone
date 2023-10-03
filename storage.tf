module "storage" {
  source = "github.com/hmcts/cnp-module-storage-account?ref=master"

  for_each                 = local.storage_accounts
  env                      = var.env
  storage_account_name     = lower(replace("${local.name}${each.key}${var.env}", "-", ""))
  resource_group_name      = azurerm_resource_group.this["storage"].name
  location                 = var.location
  account_kind             = var.storage_account_kind
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  enable_hns               = true
  enable_sftp              = false
  enable_nfs               = false
  containers               = each.value.containers
  enable_data_protection   = true

  sa_subnets = [
    data.azurerm_subnet.ssptl-00.id,
    data.azurerm_subnet.ssptl-01.id
  ]

  team_name    = "Platform Operations"
  team_contact = "#dtspo-orange"
  common_tags  = var.common_tags
}

resource "azurerm_private_endpoint" "storage_pe" {
  for_each            = { for value in local.flattened_storage_accounts_private_endpoints : "${value.storage_account}-${value.private_endpoint}" => value }
  name                = "${local.name}-${each.key}-pe-${var.env}"
  resource_group_name = azurerm_resource_group.this["storage"].name
  location            = var.location
  subnet_id           = module.networking.subnet_ids["vnet-services"]
  tags                = var.common_tags

  private_service_connection {
    name                           = module.storage[each.value.storage_account].storageaccount_name
    is_manual_connection           = false
    private_connection_resource_id = module.storage[each.value.storage_account].storageaccount_id
    subresource_names              = [each.value.private_endpoint]
  }

  private_dns_zone_group {
    name                 = "endpoint-dnszonegroup"
    private_dns_zone_ids = [each.value.dns_zone_id]
  }
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
