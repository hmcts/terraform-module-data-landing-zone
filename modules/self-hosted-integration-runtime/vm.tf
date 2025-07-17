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

module "shir_vm" {
  source = "github.com/hmcts/terraform-module-virtual-machine.git?ref=master"

  providers = {
    azurerm     = azurerm,
    azurerm.soc = azurerm.soc,
    azurerm.cnp = azurerm.cnp,
    azurerm.dcr = azurerm.dcr
  }

  vm_type           = "windows"
  vm_name           = "${var.name}-vm-${var.env}"
  vm_resource_group = var.resource_group
  vm_admin_password = random_password.shir_password.result
  vm_subnet_id      = var.subnet_id
  vm_publisher_name = "MicrosoftWindowsServer"
  vm_offer          = "WindowsServer"
  vm_sku            = "2025-Datacenter"
  vm_version        = "latest"
  vm_size           = var.size
  tags              = var.common_tags
}

resource "azurerm_virtual_machine_extension" "shir_install" {
  name                       = "${var.name}-shir-install"
  virtual_machine_id         = module.shir_vm.vm_id
  publisher                  = "Microsoft.CPlat.Core"
  type                       = "RunCommandWindows"
  type_handler_version       = "1.1"
  auto_upgrade_minor_version = true

  protected_settings = jsonencode({
    script = compact(tolist([templatefile("${path.module}/installSHIR.ps1", {
      gatewayKey = var.integration_runtime_auth_key
    })]))
  })

  tags = var.common_tags
}
