# Create the Azure Bastion subnet and resource
# Define the Azure Bastion subnet
resource "azurerm_subnet" "bastion_subnet" {
  count                = var.install_azure_bastion == true ? 1 : 0
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.hub_resource_group_name
  virtual_network_name = module.data_landing_zone.hub_vnet_name
  address_prefixes     = var.services_bastion_subnet_address_space
}

# Define the Azure Bastion resource
resource "azurerm_bastion_host" "example" {
  count               = var.install_azure_bastion == true ? 1 : 0
  name                = "${local.name}-bastion-${var.env}"
  location            = var.location
  resource_group_name = var.hub_resource_group_name

  dns_name = "${local.name}-bastion-${var.env}"
  sku      = "Basic"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.example.id
  }
  tags = var.common_tags
}

# Define the public IP for Azure Bastion
resource "azurerm_public_ip" "example" {
  count               = var.install_azure_bastion == true ? 1 : 0
  name                = "${local.name}-bastion-${var.env}-pip"
  location            = var.location
  resource_group_name = var.hub_resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.common_tags
}
