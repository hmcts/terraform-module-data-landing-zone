resource "azurerm_lb" "shir_lb" {
  name                = "${var.name}-lb-${var.env}"
  resource_group_name = var.resource_group
  location            = var.location

  sku      = "Standard"
  sku_tier = "Regional"

  frontend_ip_configuration {
    name                          = local.frontend_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.common_tags
}

resource "azurerm_lb_nat_pool" "shir" {
  resource_group_name            = var.resource_group
  loadbalancer_id                = azurerm_lb.shir_lb.id
  name                           = "${var.name}-natpool-${var.env}"
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50099
  backend_port                   = 3389
  frontend_ip_configuration_name = local.frontend_name
}

resource "azurerm_lb_backend_address_pool" "shir" {
  loadbalancer_id = azurerm_lb.shir_lb.id
  name            = var.name
}

resource "azurerm_lb_probe" "shir" {
  loadbalancer_id     = azurerm_lb.shir_lb.id
  name                = "${var.name}-probe-${var.env}"
  protocol            = "Http"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
  request_path        = "/"
}

resource "azurerm_lb_rule" "shir" {
  loadbalancer_id                = azurerm_lb.shir_lb.id
  name                           = "${var.name}-rule-${var.env}"
  protocol                       = "Tcp"
  frontend_port                  = "80"
  backend_port                   = "80"
  frontend_ip_configuration_name = local.frontend_name
  enable_floating_ip             = false
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.shir.id]
  probe_id                       = azurerm_lb_probe.shir.id
  load_distribution              = "Default"
  idle_timeout_in_minutes        = 5
}
