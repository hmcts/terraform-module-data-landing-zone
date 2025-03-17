resource "azurerm_public_ip" "bastion" {
  count               = var.bastion_host_subnet_address_space == null ? 0 : 1
  name                = "${local.name}-bastion-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.this["network"].name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "this" {
  count               = var.bastion_host_subnet_address_space == null ? 0 : 1
  name                = "${local.name}-bastion"
  location            = var.location
  resource_group_name = azurerm_resource_group.this["network"].name
  ip_configuration {
    name                 = "${local.name}-bastion-ip-config"
    subnet_id            = module.networking.subnet_ids["vnet-bastion"]
    public_ip_address_id = azurerm_public_ip.bastion[0].id
  }
}
