resource "random_password" "shir_password" {
  length           = 32
  special          = true
  override_special = "#$%&@()_[]{}<>:?"
  min_upper        = 4
  min_lower        = 4
  min_numeric      = 4
}

resource "azurerm_key_vault_secret" "shir_password" {
  name         = "${var.name}-password-${var.env}"
  value        = random_password.shir_password.result
  key_vault_id = var.key_vault_id
}

module "shir_vmss" {
  source = "github.com/hmcts/terraform-module-virtual-machine-scale-set?ref=main"

  providers = {
    azurerm     = azurerm,
    azurerm.soc = azurerm.soc,
    azurerm.cnp = azurerm.cnp,
    azurerm.dcr = azurerm.dcr
  }

  env                     = var.env
  vm_type                 = "windows-scale-set"
  vm_name                 = "${var.name}-vmss-${var.env}"
  computer_name_prefix    = local.short_name
  vm_resource_group       = var.resource_group
  vm_sku                  = var.sku
  vm_admin_password       = random_password.shir_password.result
  vm_availabilty_zones    = var.availability_zones
  vm_publisher_name       = "MicrosoftWindowsServer"
  vm_offer                = "WindowsServer"
  vm_image_sku            = "2022-datacenter-azure-edition"
  vm_version              = "latest"
  vm_instances            = var.instances
  upgrade_mode            = "Automatic"
  systemassigned_identity = true
  network_interfaces = {
    nic0 = {
      name                                   = "${var.name}-nic",
      primary                                = true,
      ip_config_name                         = "${var.name}-ipconfig",
      subnet_id                              = var.subnet_id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.shir.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.shir.id]
    }
  }
  tags = var.common_tags
}

resource "azurerm_virtual_machine_scale_set_extension" "shir_install" {
  name                         = "${var.name}-shir-install"
  virtual_machine_scale_set_id = module.shir_vmss.vm_id
  publisher                    = "Microsoft.CPlat.Core"
  type                         = "RunCommandWindows"
  type_handler_version         = "1.1"
  auto_upgrade_minor_version   = true
  settings = jsonencode({
    script = compact(tolist([templatefile("${path.module}/installSHIR.ps1", {
      gatewayKey = var.integration_runtime_auth_key
    })]))
  })
}
