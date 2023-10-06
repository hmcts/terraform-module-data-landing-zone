resource "azurerm_databricks_workspace" "this" {
  name                              = var.name
  resource_group_name               = var.resource_group
  location                          = var.location
  sku                               = var.sku
  managed_resource_group_name       = local.managed_resource_group_name
  tags                              = var.common_tags
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  custom_parameters {
    virtual_network_id                                   = var.vnet_id
    public_subnet_name                                   = var.public_subnet_name
    public_subnet_network_security_group_association_id  = var.public_subnet_nsg_id
    private_subnet_name                                  = var.private_subnet_name
    private_subnet_network_security_group_association_id = var.private_subnet_nsg_id
    no_public_ip                                         = var.no_public_ip
  }
}
