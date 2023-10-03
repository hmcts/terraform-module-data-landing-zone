# Creates shared data landing zone product resources

resource "azurerm_resource_group" "example" {
  name     = "${local.name}-product-databricks001-rg"
  location = var.location
}


resource "azurerm_databricks_workspace" "example" {
  name                              = "${local.name}-product-databricks001"
  resource_group_name               = azurerm_resource_group.example.name
  location                          = var.location
  sku                               = "premium"
  tags                              = var.common_tags
  infrastructure_encryption_enabled = false
  custom_parameters {
    virtual_network_id                                   = module.networking.vnet_ids["vnet"]
    public_subnet_name                                   = module.networking.subnet_names["vnet-data-bricks-public"]
    public_subnet_network_security_group_association_id  = module.networking.network_security_groups_ids["nsg"]
    private_subnet_name                                  = module.networking.subnet_names["vnet-data-bricks-private"]
    private_subnet_network_security_group_association_id = module.networking.network_security_groups_ids["nsg"]
    no_public_ip                                         = true

    # Add encryption (Think it wants KV details) 
  }
}


/* resource "azurerm_synapse_workspace" "example" {
  name                                 = "example"
  resource_group_name                  = azurerm_resource_group.example.name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = azurerm_databricks_workspace.example.workspace_id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "H@Sh1CoR3!"

  aad_admin {
    login     = "AzureAD Admin"
    object_id = "00000000-0000-0000-0000-000000000000"
    tenant_id = "00000000-0000-0000-0000-000000000000"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags
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
