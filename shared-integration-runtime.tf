module "shared_integration_databricks" {
  source                = "./modules/azure-databricks"
  name                  = "${local.name}-integration-databricks001"
  resource_group        = azurerm_resource_group.this["shared-integration"].name
  location              = var.location
  common_tags           = var.common_tags
  vnet_id               = module.networking.vnet_ids["vnet"]
  public_subnet_name    = module.networking.subnet_names["vnet-data-bricks-public"]
  public_subnet_nsg_id  = module.networking.network_security_groups_ids["nsg"]
  private_subnet_name   = module.networking.subnet_names["vnet-data-bricks-private"]
  private_subnet_nsg_id = module.networking.network_security_groups_ids["nsg"]
}
