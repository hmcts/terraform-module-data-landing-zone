output "interactive_cluster_id" {
  value = databricks_cluster.interactive.id
}

output "serverless_warehouse_id" {
  value = databricks_sql_endpoint.serverless_warehouse.id
}


output "abfss_path" {
  value = "abfss://ingest00-raw-sbox@ingest00rawsbox.dfs.core.windows.net/test_data"
}