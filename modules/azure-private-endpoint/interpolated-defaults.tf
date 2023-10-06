locals {
  dns_zone_id_prefix = "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/"
  subresource_name_dns_zone_map = {
    vault = "${local.dns_zone_id_prefix}privatelink.vaultcore.azure.net"
    blob  = "${local.dns_zone_id_prefix}privatelink.blob.core.windows.net"
    dfs   = "${local.dns_zone_id_prefix}privatelink.dfs.core.windows.net"
  }
}
