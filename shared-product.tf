module "shared_product_databricks" {
  source = "github.com/hmcts/terraform-module-databricks?ref=main"

  env                          = var.env
  product                      = "data-landing"
  component                    = "shared-integration"
  name                         = "${local.name}-product-databricks001"
  existing_resource_group_name = azurerm_resource_group.this["shared-product"].name
  location                     = var.location
  common_tags                  = var.common_tags
  vnet_id                      = module.networking.vnet_ids["vnet"]
  public_subnet_name           = module.networking.subnet_names["vnet-data-bricks-public"]
  public_subnet_nsg_id         = module.networking.network_security_groups_ids["nsg"]
  private_subnet_name          = module.networking.subnet_names["vnet-data-bricks-private"]
  private_subnet_nsg_id        = module.networking.network_security_groups_ids["nsg"]
}

resource "azurerm_synapse_workspace" "example" {
  name                                 = "${var.prefix}-product-synapse001"
  resource_group_name                  = azurerm_resource_group.this["shared-product"].name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.this["workspace"].id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "H@Sh1CoR3!"
  data_exfiltration_protection_enabled = true
  managed_virtual_network_enabled      = true
  managed_resource_group_name          = "${var.prefix}-product-synapse001"
  purview_id                           = var.purview_id
  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags
}


/* resource "azurerm_synapse_sql_pool" "default" {
  name                 = "sqlPool001"
  synapse_workspace_id = azurerm_databricks_workspace.example.id
  sku_name             = "DW100c"
  create_mode          = "Default"
  
} */

// Resources
/* resource synapse 'Microsoft.Synapse/workspaces@2021-03-01' = {
  name: synapseName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultDataLakeStorage: {
      accountUrl: 'https://${synapseDefaultStorageAccountName}.dfs.${environment().suffixes.storage}' 
      filesystem: synapseDefaultStorageAccountFileSystemName
    }
    managedResourceGroupName: synapseName
    managedVirtualNetwork: 'default'
    managedVirtualNetworkSettings: {
      allowedAadTenantIdsForLinking: []
      linkedAccessCheckOnTargetResource: true
      preventDataExfiltration: true
    }
    publicNetworkAccess: 'Disabled'
    purviewConfiguration: {
      purviewResourceId: purviewId
    }
    sqlAdministratorLogin: administratorUsername
    sqlAdministratorLoginPassword: administratorPassword
    virtualNetworkProfile: {
      computeSubnetId: synapseComputeSubnetId
    }
  }
} */
