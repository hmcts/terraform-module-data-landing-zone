data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

resource "random_string" "vm_username" {
  length  = 4
  special = false
}

resource "random_password" "vm_password" {
  length           = 16
  special          = true
  override_special = "#$%&@()_[]{}<>:?"
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
}

locals {
  vm_type = "windows"

  vm_size              = "Standard_D4ds_v5"
  ipconfig_name        = "IP_CONFIGURATION"
  

  marketplace_product   = "SQL2008R2SP3-WS2008R2SP1"
  marketplace_publisher = "MicrosoftSQLServer"
  marketplace_sku       = "Enterprise"
  vm_version            = "latest"

  is_prod              = length(regexall(".*(prod).*", var.env)) > 0
  is_sbox              = length(regexall(".*(s?box).*", var.env)) > 0
  admin_group          = local.is_prod ? "DTS Platform Operations SC" : "DTS Platform Operations"
  name                 = var.name != null ? var.name : "datalanding"
  short_name           = substr(local.name, 0, 11)
  resource_group_names = ["network", "management", "logging", "runtimes", "storage", "external-storage", "metadata", "shared-integration", "shared-product", "di001", "di002", "dp001", "dp002"]

  databricks_service_name = "Microsoft.Databricks/workspaces"
  databricks_subnet_delegated_actions = [
    "Microsoft.Network/virtualNetworks/subnets/join/action",
    "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
    "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
  ]

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
    blob = data.azurerm_private_dns_zone.cftptl["privatelink.blob.core.windows.net"].id
    dfs  = data.azurerm_private_dns_zone.cftptl["privatelink.dfs.core.windows.net"].id
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

  metadata_vaults        = ["meta001", "meta002"]
  metadata_mssql_db_name = "${local.name}-metadata-db-${var.env}"

  ssptl_vnet_name                  = local.is_sbox ? "ss-ptlsbox-vnet" : "ss-ptl-vnet"
  ssptl_vnet_resource_group        = local.is_sbox ? "ss-ptlsbox-network-rg" : "ss-ptl-network-rg"
  cftptl_core_infra_resource_group = "core-infra-intsvc-rg"

  privatelink_dns_zone_names = [
    "privatelink.mysql.database.azure.com",
    "privatelink.blob.core.windows.net",
    "privatelink.dfs.core.windows.net",
    "privatelink.vaultcore.azure.net",
    "privatelink.vaultcore.azure.net",
    "privatelink.servicebus.windows.net",
    "privatelink.datafactory.azure.net",
    "privatelink.adf.azure.com",
    "privatelink.sql.azuresynapse.net",
    "privatelink.sql.azuresynapse.net",
    "privatelink.dev.azuresynapse.net",
  ]

  adf_managed_purview_endpoints = merge(
    var.existing_purview_account == null ? {} : {
      purview = {
        resource_id      = var.existing_purview_account.resource_id
        subresource_name = "account"
      }
    },
    var.existing_purview_account == null ? {} : var.existing_purview_account.managed_storage_account_id != null ? {
      purview-storage-blob = {
        resource_id         = var.existing_purview_account.managed_storage_account_id
        subresource_name    = "blob"
        is_managed_resource = true
      }
      purview-storage-queue = {
        resource_id         = var.existing_purview_account.managed_storage_account_id
        subresource_name    = "queue"
        is_managed_resource = true
      }
    } : {},
    var.existing_purview_account == null ? {} : var.existing_purview_account.managed_event_hub_namespace_id != null ? {
      purview-eventhub = {
        resource_id         = var.existing_purview_account.managed_event_hub_namespace_id
        subresource_name    = "namespace"
        is_managed_resource = true
      }
    } : {}
  )

  default_subnets = {
    services = {
      address_prefixes = var.services_subnet_address_space
    }
    services-mysql = {
      address_prefixes = var.services_mysql_subnet_address_space
      delegations = {
        mysql-flexible-delegation = {
          service_name = "Microsoft.DBforMySQL/flexibleServers"
          actions = [
            "Microsoft.Network/virtualNetworks/subnets/join/action"
          ]
        }
      }
    }
    data-bricks-public = {
      address_prefixes = var.data_bricks_public_subnet_address_space
      delegations = {
        data-bricks-delegation = {
          service_name = local.databricks_service_name
          actions      = local.databricks_subnet_delegated_actions
        }
      }
    }
    data-bricks-private = {
      address_prefixes = var.data_bricks_private_subnet_address_space
      delegations = {
        data-bricks-delegation = {
          service_name = local.databricks_service_name
          actions      = local.databricks_subnet_delegated_actions
        }
      }
    }
    data-bricks-product-public = {
      address_prefixes = var.data_bricks_product_public_subnet_address_space
      delegations = {
        data-bricks-delegation = {
          service_name = local.databricks_service_name
          actions      = local.databricks_subnet_delegated_actions
        }
      }
    }
    data-bricks-product-private = {
      address_prefixes = var.data_bricks_product_private_subnet_address_space
      delegations = {
        data-bricks-delegation = {
          service_name = local.databricks_service_name
          actions      = local.databricks_subnet_delegated_actions
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

data "azurerm_private_dns_zone" "cftptl" {
  for_each            = toset(local.privatelink_dns_zone_names)
  provider            = azurerm.cftptl
  name                = each.key
  resource_group_name = local.cftptl_core_infra_resource_group
}

