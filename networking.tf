module "networking" {
  source = "github.com/hmcts/terraform-module-azure-virtual-networking?ref=main"

  env                          = var.env
  product                      = "data-landing"
  common_tags                  = var.common_tags
  component                    = "networking"
  name                         = local.name
  location                     = var.location
  existing_resource_group_name = azurerm_resource_group.this["network"].name

  vnets = {
    vnet = {
      address_space = var.vnet_address_space
      subnets       = merge(local.default_subnets, var.additional_subnets)
    }
  }

  route_tables = {
    rt = {
      subnets = [
        "vnet-services",
        "vnet-services-mysql",
        "vnet-data-bricks-public",
        "vnet-data-bricks-private",
        "vnet-data-bricks-product-public",
        "vnet-data-bricks-product-private",
        "vnet-data-integration-001",
        "vnet-data-integration-002",
        "vnet-data-product-001",
        "vnet-data-product-002"
      ]
      routes = {
        default = {
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = var.default_route_next_hop_ip
        }
      }
    }
  }

  network_security_groups = {
    nsg = {
      subnets = [
        "vnet-services",
        "vnet-services-mysql",
        "vnet-data-bricks-public",
        "vnet-data-bricks-private",
        "vnet-data-bricks-product-public",
        "vnet-data-bricks-product-private",
        "vnet-data-integration-001",
        "vnet-data-integration-002",
        "vnet-data-product-001",
        "vnet-data-product-002"
      ]
      rules = {
        "Dbricks-workspaces-UseOnly-databricks-worker-to-worker-inbound" = {
          priority                   = 200
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "VirtualNetwork"
          description                = "Required for worker nodes communication within a cluster."
        }
        "Dbricks-workspaces-UseOnly-databricks-worker-to-worker-outbound" = {
          priority                   = 201
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "VirtualNetwork"
          description                = "Required for worker nodes communication within a cluster."
        }
        "Dbricks-workspaces-UseOnly-databricks-worker-to-sql" = {
          priority                   = 202
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "3306"
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "Sql"
          description                = "Required for workers communication with Azure SQL services."
        }
        "Dbricks-workspaces-UseOnly-databricks-worker-to-storage" = {
          priority                   = 203
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "Storage"
          description                = "Required for workers communication with Azure Storage services."
        }
        "Dbricks-workspaces-UseOnly-databricks-worker-to-eventhub" = {
          priority                   = 204
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "9093"
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "EventHub"
          description                = "Required for workers communication with Azure EventHub services."
        }
        "Dbricks-workspaces-UseOnly-databricks-worker-to-webapp" = {
          priority                   = 200
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "AzureDatabricks"
          description                = "Required for workers communication with Databricks webapp."
        }
        "Allow_SDS_PTL_ADO_Agents" = {
          priority                     = 4000
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "*"
          source_port_range            = "*"
          destination_port_range       = "*"
          source_address_prefixes      = concat(data.azurerm_subnet.ssptl-00.address_prefixes, data.azurerm_subnet.ssptl-01.address_prefixes)
          destination_address_prefixes = var.vnet_address_space
          description                  = "Allow ADO agents to communicate with DLRM data ingest landing zone resources."
        }
      }
    }
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "data_landing_link" {
  for_each              = toset(local.privatelink_dns_zone_names)
  provider              = azurerm.cftptl
  name                  = "${local.name}-${split(".", each.key)[1]}-data-landing-link-${var.env}"
  private_dns_zone_name = data.azurerm_private_dns_zone.cftptl[each.key].name
  virtual_network_id    = module.networking.vnet_ids["vnet"]
  resource_group_name   = data.azurerm_private_dns_zone.cftptl[each.key].resource_group_name
  tags                  = var.common_tags
}

module "vnet_peer_hub" {
  source = "github.com/hmcts/terraform-module-vnet-peering?ref=feat%2Ftweak-to-enable-planning-in-a-clean-env"
  peerings = {
    source = {
      name           = "${local.name}-vnet-${var.env}-to-hub"
      vnet_id        = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${module.networking.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${module.networking.vnet_names["vnet"]}"
      vnet           = module.networking.vnet_names["vnet"]
      resource_group = module.networking.resource_group_name
    }
    target = {
      name           = "hub-to-${local.name}-vnet-${var.env}"
      vnet           = var.hub_vnet_name
      resource_group = var.hub_resource_group_name
    }
  }

  providers = {
    azurerm.initiator = azurerm
    azurerm.target    = azurerm.hub
  }
}
