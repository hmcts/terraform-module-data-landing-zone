module "databricks_cluster" {
  providers = {
    databricks = databricks
  }
  source                   = "./modules/databricks/Cluster"
  depends_on               = [module.shared_integration_databricks]
  databricks_workspace_url = module.shared_integration_databricks.workspace_url
}

