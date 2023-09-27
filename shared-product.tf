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
    virtual_network_id                                   = module.networking.vnet_ids["data-landing"]
    public_subnet_name                                   = "data-landing-data-bricks-product-public"
    public_subnet_network_security_group_association_id  = module.networking.network_security_groups_ids["data-landing"]
    private_subnet_name                                  = "data-landing-data-bricks-product-private"
    private_subnet_network_security_group_association_id = module.networking.network_security_groups_ids["data-landing"]
    no_public_ip                                         = true

    # Add encryption (Think it wants KV details) 
  }
}
