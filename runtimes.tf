module "runtimes_datafactory" {
  source = "github.com/hmcts/terraform-module-azure-datafactory?ref=main"

  env                              = var.env
  product                          = "data-landing"
  component                        = "runtimes"
  name                             = "${local.name}-runtimes-dataFactory001"
  public_network_enabled           = false
  managed_virtual_network_enabled  = true
  purview_id                       = var.purview_id
  system_assigned_identity_enabled = true
  private_endpoint_enabled         = true
  private_endpoint_subnet_id       = module.networking.subnet_ids["vnet-services"]
  common_tags                      = var.common_tags
  existing_resource_group_name     = azurerm_resource_group.this["runtimes"].name
  managed_private_endpoints        = local.adf_managed_purview_endpoints
}

resource "azurerm_data_factory_integration_runtime_self_hosted" "this" {
  name            = "${local.name}-runtimes-dataFactory001-shir001"
  description     = "Data Landing Zone - Self Hosted Integration Runtime running on ${local.shir_name}"
  data_factory_id = module.runtimes_datafactory.id
}

resource "azurerm_lb" "shir_lb" {
  name                = "${local.shir_name}-lb-${var.env}"
  resource_group_name = azurerm_resource_group.this["runtimes"].name
  location            = var.location

  sku      = "Basic"
  sku_tier = "Regional"

  frontend_ip_configuration {
    name                          = local.shir_frontend_ip_config_name
    subnet_id                     = module.networking.subnet_ids["vnet-services"]
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.common_tags
}

resource "azurerm_lb_nat_pool" "shir" {
  resource_group_name            = azurerm_resource_group.this["runtimes"].name
  loadbalancer_id                = azurerm_lb.shir_lb.id
  name                           = "${local.name}-natpool-${var.env}"
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50099
  backend_port                   = 3389
  frontend_ip_configuration_name = local.shir_frontend_ip_config_name
}

resource "azurerm_lb_backend_address_pool" "shir" {
  loadbalancer_id = azurerm_lb.shir_lb.id
  name            = local.shir_name
}

resource "azurerm_lb_probe" "shir" {
  loadbalancer_id     = azurerm_lb.shir_lb.id
  name                = "${local.name}-probe-${var.env}"
  protocol            = "Http"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
  request_path        = "/"
}

resource "azurerm_lb_rule" "shir" {
  loadbalancer_id                = azurerm_lb.shir_lb.id
  name                           = "${local.name}-rule-${var.env}"
  protocol                       = "Tcp"
  frontend_port                  = "80"
  backend_port                   = "80"
  frontend_ip_configuration_name = local.shir_frontend_ip_config_name
  enable_floating_ip             = false
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.shir.id]
  probe_id                       = azurerm_lb_probe.shir.id
  load_distribution              = "Default"
  idle_timeout_in_minutes        = 5
}

resource "random_password" "shir_password" {
  length           = 32
  special          = true
  override_special = "#$%&@()_[]{}<>:?"
  min_upper        = 4
  min_lower        = 4
  min_numeric      = 4
}

resource "azurerm_key_vault_secret" "shir_password" {
  name         = "${local.shir_name}-password-${var.env}"
  value        = random_password.shir_password.result
  key_vault_id = module.metadata_vault["meta001"].key_vault_id
}

module "shir_vmss" {
  source = "github.com/hmcts/terraform-module-virtual-machine-scale-set?ref=feat%2Fadd-ip-config-options"

  providers = {
    azurerm     = azurerm,
    azurerm.soc = azurerm.soc,
    azurerm.cnp = azurerm.cnp
  }

  env                     = var.env
  vm_type                 = "windows-scale-set"
  vm_name                 = "${local.shir_name}-vmss"
  computer_name_prefix    = local.shir_name_short
  vm_resource_group       = azurerm_resource_group.this["runtimes"].name
  vm_sku                  = "Standard_D4ds_v5"
  vm_admin_password       = random_password.shir_password.result
  vm_availabilty_zones    = ["1"]
  vm_publisher_name       = "MicrosoftWindowsServer"
  vm_offer                = "WindowsServer"
  vm_image_sku            = "2022-datacenter-azure-edition"
  vm_version              = "latest"
  vm_instances            = 1
  systemassigned_identity = true
  network_interfaces = {
    nic0 = {
      name                                   = "${local.shir_name}-nic",
      primary                                = true,
      ip_config_name                         = "${local.shir_name}-ipconfig",
      subnet_id                              = module.networking.subnet_ids["vnet-services"]
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.shir.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.shir.id]
    }
  }
  tags = var.common_tags
}
