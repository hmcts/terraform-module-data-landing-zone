module "databricks_cluster" {
  source                   = "./modules/databricks/Cluster"
  depends_on               = [module.shared_integration_databricks]
  databricks_workspace_url = module.shared_integration_databricks.workspace_url
  client_secret = var.client_secret
  client_id     = var.client_id
  tenant_id     = var.tenant_id
}

