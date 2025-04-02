provider "databricks" {
  host = "https://adb-1879076228317698.18.azuredatabricks.net"
  #host  = module.shared_product_databricks.workspace_url["ingest02-product-databricks001-sbox"]
  token = var.databricks_token
}

