module "runtimes_datafactory" {
  source = "github.com/hmcts/terraform-module-azure-datafactory?ref=main"

  depends_on = [module.vnet_peer_hub]

  env                              = var.env
  product                          = "data-landing"
  component                        = "runtimes"
  name                             = "${local.name}-runtimes-dataFactory001"
  public_network_enabled           = false
  managed_virtual_network_enabled  = true
  purview_id                       = var.existing_purview_account != null ? var.existing_purview_account.resource_id : null
  system_assigned_identity_enabled = true
  private_endpoint_enabled         = true
  private_endpoint_subnet_id       = module.networking.subnet_ids["vnet-services"]
  common_tags                      = var.common_tags
  existing_resource_group_name     = azurerm_resource_group.this[local.runtimes_resource_group].name
  managed_private_endpoints        = local.adf_managed_purview_endpoints
}

resource "azurerm_data_factory_integration_runtime_self_hosted" "this" {
  name            = "${local.name}-runtimes-dataFactory001-shir001"
  description     = "Data Landing Zone - Self Hosted Integration Runtime running on ${local.name}-shir001"
  data_factory_id = module.runtimes_datafactory.id
}

module "shir001" {
  source = "./modules/self-hosted-integration-runtime"

  depends_on = [module.vnet_peer_hub, module.metadata_vault, module.metadata_vault_pe]

  providers = {
    azurerm     = azurerm
    azurerm.soc = azurerm.soc
    azurerm.cnp = azurerm.cnp
  }

  env                          = var.env
  name                         = "${local.name}-shir001"
  short_name                   = "shir001"
  resource_group               = azurerm_resource_group.this[local.runtimes_resource_group].name
  subnet_id                    = module.networking.subnet_ids["vnet-services"]
  key_vault_id                 = module.metadata_vault["meta001"].key_vault_id
  integration_runtime_auth_key = azurerm_data_factory_integration_runtime_self_hosted.this.primary_authorization_key
  common_tags                  = var.common_tags
}

module "shir002" {
  count  = var.existing_purview_account == null ? 0 : var.existing_purview_account.self_hosted_integration_runtime_auth_key != null ? 1 : 0
  source = "./modules/self-hosted-integration-runtime"

  depends_on = [module.vnet_peer_hub, module.metadata_vault, module.metadata_vault_pe]

  providers = {
    azurerm     = azurerm
    azurerm.soc = azurerm.soc
    azurerm.cnp = azurerm.cnp
  }

  env                          = var.env
  name                         = "${local.name}-shir002"
  short_name                   = "shir002"
  resource_group               = azurerm_resource_group.this[local.runtimes_resource_group].name
  subnet_id                    = module.networking.subnet_ids["vnet-services"]
  key_vault_id                 = module.metadata_vault["meta001"].key_vault_id
  integration_runtime_auth_key = var.existing_purview_account.self_hosted_integration_runtime_auth_key
  common_tags                  = var.common_tags
}
