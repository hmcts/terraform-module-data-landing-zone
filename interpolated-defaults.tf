data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

locals {
  is_prod              = length(regexall(".*(prod).*", var.env)) > 0
  is_sbox              = length(regexall(".*(s?box).*", var.env)) > 0
  admin_group          = local.is_prod ? "DTS Platform Operations SC" : "DTS Platform Operations"
  name                 = var.name != null ? var.name : "dlrm-ingest"
  resource_group_names = ["network", "management", "logging", "storage", "external-storage", "metadata", "shared-integration", "shared-product", "di001", "di002", "dp001", "dp002"]

  storage_accounts = {
    raw = {
      resource_group_key = "storage"
      containers         = local.domain_file_system_names
      private_endpoints  = local.default_storage_private_endpoints
    }
    curated = {
      resource_group_key = "storage"
      containers         = local.domain_file_system_names
      private_endpoints  = local.default_storage_private_endpoints
    }
    workspace = {
      resource_group_key = "storage"
      containers         = local.data_product_file_system_names
      private_endpoints  = local.default_storage_private_endpoints
    }
    external = {
      resource_group_key = "external-storage"
      containers         = [{ name = "data", access_type = "private" }]
      private_endpoints  = local.default_storage_private_endpoints
    }
  }
  default_storage_private_endpoints = {
    blob = "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
    dfs  = "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.dfs.core.windows.net"
  }
  domain_file_system_names = [
    { name = "data", access_type = "private" },
    { name = "di001", access_type = "private" },
    { name = "di002", access_type = "private" }
  ]
  data_product_file_system_names = [
    { name = "data", access_type = "private" },
    { name = "dp001", access_type = "private" },
    { name = "dp002", access_type = "private" }
  ]
  flattened_storage_accounts_private_endpoints = flatten([
    for key, value in local.storage_accounts : [
      for private_endpoint, dns_zone_id in value.private_endpoints : {
        private_endpoint   = private_endpoint
        dns_zone_id        = dns_zone_id
        storage_account    = key
        resource_group_key = value.resource_group_key
      }
    ]
  ])

  metadata_vaults = ["meta001", "meta002"]

  ssptl_vnet_name           = "ss-ptl-vnet"
  ssptl_vnet_resource_group = "ss-ptl-network-rg"
}

data "azuread_group" "admin_group" {
  display_name     = local.admin_group
  security_enabled = true
}

data "azurerm_subnet" "ssptl-00" {
  provider             = azurerm.ssptl
  name                 = "aks-00"
  virtual_network_name = local.ssptl_vnet_name
  resource_group_name  = local.ssptl_vnet_resource_group
}

data "azurerm_subnet" "ssptl-01" {
  provider             = azurerm.ssptl
  name                 = "aks-01"
  virtual_network_name = local.ssptl_vnet_name
  resource_group_name  = local.ssptl_vnet_resource_group
}
