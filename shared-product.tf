# Creates shared data landing zone product resources

resource "azurerm_resource_group" "example" {
  name     = "${local.name}-product-databricks001-rg"
  location = var.location
  tags     = var.common_tags
}


resource "azurerm_databricks_workspace" "example" {
  name                              = "${local.name}-product-databricks001"
  resource_group_name               = azurerm_resource_group.example.name
  location                          = var.location
  sku                               = "premium"
  managed_resource_group_name       = "${var.prefix}-product-databricks001"
  tags                              = var.common_tags
  infrastructure_encryption_enabled = false
  custom_parameters {
    virtual_network_id                                   = module.networking.vnet_ids["data-landing"]
    public_subnet_name                                   = module.networking.subnet_names["vnet-data-bricks-public"]
    public_subnet_network_security_group_association_id  = module.networking.network_security_groups_ids["data-landing"]
    private_subnet_name                                  = module.networking.subnet_names["vnet-data-bricks-private"]
    private_subnet_network_security_group_association_id = module.networking.network_security_groups_ids["data-landing"]
    no_public_ip                                         = true

    # Add encryption (Think it wants KV details) 
  }
}

resource "azurerm_synapse_workspace" "example" {
  name                                 = "example"
  resource_group_name                  = azurerm_resource_group.example.name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = module.storage.storage_account_id["workspace"]
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "H@Sh1CoR3!"


  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags
}




/* resource "azurerm_synapse_workspace" "example" {
  name                             = "example"
  sql_administrator_login          = "sqladminuser"
  sql_administrator_login_password = "H@Sh1CoR3!"
  managed_virtual_network_enable   = true
  tags                             = var.common_tags
} */

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
