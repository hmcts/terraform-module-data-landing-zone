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

  managed_private_endpoints = {
    purview = {
      resource_id      = var.purview_id
      subresource_name = "account"
    }
  }
}
