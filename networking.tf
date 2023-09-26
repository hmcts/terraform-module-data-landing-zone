module "networking" {
  source = "github.com/hmcts/terraform-module-azure-virtual-networking?ref=main"

  env         = var.env
  product     = "data-landing"
  common_tags = var.common_tags
  component   = "networking"
  name        = local.name

  vnets = {
    data-landing = {
      address_space = var.vnet_address_space
      subnets = {
        services = {
          address_prefixes = var.services_subnet_address_space
        }
        data-bricks-public = {
          address_prefixes = var.data_bricks_public_subnet_address_space
          delegations = {
            data-bricks-delegation = {
              service_name = "Microsoft.Databricks/workspaces"
            }
          }
        }
        data-bricks-private = {
          address_prefixes = var.data_bricks_private_subnet_address_space
          delegations = {
            data-bricks-delegation = {
              service_name = "Microsoft.Databricks/workspaces"
            }
          }
        }
        data-bricks-product-public = {
          address_prefixes = var.data_bricks_product_public_subnet_address_space
          delegations = {
            data-bricks-delegation = {
              service_name = "Microsoft.Databricks/workspaces"
            }
          }
        }
        data-bricks-product-private = {
          address_prefixes = var.data_bricks_product_private_subnet_address_space
          delegations = {
            data-bricks-delegation = {
              service_name = "Microsoft.Databricks/workspaces"
            }
          }
        }
        data-integration-001 = {
          address_prefixes = var.data_integration_001_subnet_address_space
        }
        data-integration-002 = {
          address_prefixes = var.data_integration_002_subnet_address_space
        }
        data-product-001 = {
          address_prefixes = var.data_product_001_subnet_address_space
        }
        data-product-002 = {
          address_prefixes = var.data_product_002_subnet_address_space
        }
      }
    }
  }

  route_tables = {
    data-landing = {
      subnets = [
        "data-landing-services",
        "data-landing-data-bricks-public",
        "data-landing-data-bricks-private",
        "data-landing-data-bricks-product-public",
        "data-landing-data-bricks-product-private",
        "data-landing-data-integration-001",
        "data-landing-data-integration-002",
        "data-landing-data-product-001",
        "data-landing-data-product-002"
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
    data-landing = {
      subnets = [
        "data-landing-services",
        "data-landing-data-bricks-public",
        "data-landing-data-bricks-private",
        "data-landing-data-bricks-product-public",
        "data-landing-data-bricks-product-private",
        "data-landing-data-integration-001",
        "data-landing-data-integration-002",
        "data-landing-data-product-001",
        "data-landing-data-product-002"
      ]
      rules = {
        "Microsoft-Databricks-workspaces-UseOnly-databricks-worker-to-worker-inbound" = {
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "VirtualNetwork"
          description                = "Required for worker nodes communication within a cluster."
        }
        "Microsoft-Databricks-workspaces-UseOnly-databricks-worker-to-worker-outbound" = {
          priority                   = 101
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "VirtualNetwork"
          description                = "Required for worker nodes communication within a cluster."
        }
        "Microsoft-Databricks-workspaces-UseOnly-databricks-worker-to-sql" = {
          priority                   = 102
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "3306"
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "Sql"
          description                = "Required for workers communication with Azure SQL services."
        }
        "Microsoft-Databricks-workspaces-UseOnly-databricks-worker-to-storage" = {
          priority                   = 103
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "Storage"
          description                = "Required for workers communication with Azure Storage services."
        }
        "Microsoft-Databricks-workspaces-UseOnly-databricks-worker-to-eventhub" = {
          priority                   = 104
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "9093"
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "EventHub"
          description                = "Required for workers communication with Azure EventHub services."
        }
        "Microsoft-Databricks-workspaces-UseOnly-databricks-worker-to-webapp" = {
          priority                   = 100
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "AzureDatabricks"
          description                = "Required for workers communication with Databricks webapp."
        }
      }
    }
  }
}
