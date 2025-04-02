module "databricks_cluster" {
  source                   = "./Modules/databricks/Cluster"
  depends_on               = [module.shared_integration_databricks]
  databricks_workspace_url = module.shared_integration_databricks.workspace_url
  #initialization_complete  = module.databricks_workspace.databricks_workspace_init
  client_secret = var.client_secret
  client_id     = var.client_id
  tenant_id     = var.tenant_id
}

