resource "databricks_cluster" "interactive" {
  cluster_name            = "interactive"
  spark_version           = "14.3.x-scala2.12"
  node_type_id            = "Standard_D4ds_v5"
  autotermination_minutes = 30
  num_workers             = 2

  spark_conf = {
"spark.conf.set('fs.azure.account.auth.type.ingest02rawsbox.dfs.core.windows.net', 'OAuth')" = "true"
"spark.conf.set('fs.azure.account.oauth.provider.type.ingest02rawsbox.dfs.core.windows.net', 'org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider')" = "true"
"spark.conf.set('fs.azure.account.oauth2.client.id.ingest02rawsbox.dfs.core.windows.net', '{{secrets/key-vault-secrets/client-id}}')" = "true"
"spark.conf.set('fs.azure.account.oauth2.client.secret.ingest02rawsbox.dfs.core.windows.net', '{{secrets/key-vault-secrets/client-secret}}')" = "true"
"spark.conf.set('fs.azure.account.oauth2.client.endpoint.ingest02rawsbox.dfs.core.windows.net', 'https://login.microsoftonline.com/{{secrets/key-vault-secrets/tenant-id}}/oauth2/token')" = "true"

"spark.conf.set('fs.azure.account.auth.type.ingest02landingsbox.dfs.core.windows.net', 'OAuth')" = "true"
"spark.conf.set('fs.azure.account.oauth.provider.type.ingest02landingsbox.dfs.core.windows.net', 'org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider')" = "true"
"spark.conf.set('fs.azure.account.oauth2.client.id.ingest02landingsbox.dfs.core.windows.net', '{{secrets/key-vault-secrets/client-id}}')" = "true"
"spark.conf.set('fs.azure.account.oauth2.client.secret.ingest02landingsbox.dfs.core.windows.net', '{{secrets/key-vault-secrets/client-secret}}')" = "true"
"spark.conf.set('fs.azure.account.oauth2.client.endpoint.ingest02landingsbox.dfs.core.windows.net', 'https://login.microsoftonline.com/{{secrets/key-vault-secrets/tenant-id}}/oauth2/token')" = "true"

"spark.conf.set('fs.azure.account.auth.type.ingest02curatedsbox.dfs.core.windows.net', 'OAuth')" = "true"
"spark.conf.set('fs.azure.account.oauth.provider.type.ingest02curatedsbox.dfs.core.windows.net', 'org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider')" = "true"
"spark.conf.set('fs.azure.account.oauth2.client.id.ingest02curatedsbox.dfs.core.windows.net', '{{secrets/key-vault-secrets/client-id}}')" = "true"
"spark.conf.set('fs.azure.account.oauth2.client.secret.ingest02curatedsbox.dfs.core.windows.net', '{{secrets/key-vault-secrets/client-secret}}')" = "true"
"spark.conf.set('fs.azure.account.oauth2.client.endpoint.ingest02curatedsbox.dfs.core.windows.net', 'https://login.microsoftonline.com/{{secrets/key-vault-secrets/tenant-id}}/oauth2/token')" = "true"

"spark.conf.set('fs.azure.account.auth.type.ingest02externalsbox.dfs.core.windows.net', 'OAuth')" = "true"
"spark.conf.set('fs.azure.account.oauth.provider.type.ingest02externalsbox.dfs.core.windows.net', 'org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider')" = "true"
"spark.conf.set('fs.azure.account.oauth2.client.id.ingest02externalsbox.dfs.core.windows.net', '{{secrets/key-vault-secrets/client-id}}')" = "true"
"spark.conf.set('fs.azure.account.oauth2.client.secret.ingest02externalsbox.dfs.core.windows.net', '{{secrets/key-vault-secrets/client-secret}}')" = "true"
"spark.conf.set('fs.azure.account.oauth2.client.endpoint.ingest02externalsbox.dfs.core.windows.net', 'https://login.microsoftonline.com/{{secrets/key-vault-secrets/tenant-id}}/oauth2/token')" = "true"

  }
  depends_on = [
    var.client_id,
    var.client_secret,
    var.tenant_id
  ]
}

# Create Serverless SQL Warehouse with OAuth Authentication
resource "databricks_sql_endpoint" "serverless_warehouse" {
  name             = "serverless_warehouse"
  warehouse_type   = "CLASSIC"
  cluster_size     = "Small"
  enable_serverless_compute = true
  max_num_clusters = 1

  depends_on = [
    var.client_id,
    var.client_secret,
    var.tenant_id
  ]
  tags {
    custom_tags {
      key   = "ResourceClass"
      value = "Serverless"
    }
  }
}

resource "databricks_sql_global_config" "this" {
  security_policy = "DATA_ACCESS_CONTROL"
  data_access_config = {
    #raw
    "spark.hadoop.fs.azure.account.auth.type.ingest02rawsbox.dfs.core.windows.net" : "OAuth",
    "spark.hadoop.fs.azure.account.oauth.provider.type.ingest02rawsbox.dfs.core.windows.net" : "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
    "spark.hadoop.fs.azure.account.oauth2.client.id.ingest02rawsbox.dfs.core.windows.net" : "{{secrets/key-vault-secrets/client-id}}",
    "spark.hadoop.fs.azure.account.oauth2.client.secret.ingest02rawsbox.dfs.core.windows.net" : "{{secrets/key-vault-secrets/client-secret}}",
    "spark.hadoop.fs.azure.account.oauth2.client.endpoint.ingest02rawsbox.dfs.core.windows.net" : "https://login.microsoftonline.com/{{secrets/key-vault-secrets/tenant-id}}/oauth2/token"

    #Landing
    "spark.hadoop.fs.azure.account.auth.type.ingest02landingsbox.dfs.core.windows.net" : "OAuth",
    "spark.hadoop.fs.azure.account.oauth.provider.type.ingest02landingsbox.dfs.core.windows.net" : "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
    "spark.hadoop.fs.azure.account.oauth2.client.id.ingest02landingsbox.dfs.core.windows.net" : "{{secrets/key-vault-secrets/client-id}}",
    "spark.hadoop.fs.azure.account.oauth2.client.secret.ingest02landingsbox.dfs.core.windows.net" : "{{secrets/key-vault-secrets/client-secret}}",
    "spark.hadoop.fs.azure.account.oauth2.client.endpoint.ingest02landingsbox.dfs.core.windows.net" : "https://login.microsoftonline.com/{{secrets/key-vault-secrets/tenant-id}}/oauth2/token"

    #Curated
    "spark.hadoop.fs.azure.account.auth.type.ingest02curatedsbox.dfs.core.windows.net" : "OAuth",
    "spark.hadoop.fs.azure.account.oauth.provider.type.ingest02curatedsbox.dfs.core.windows.net" : "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
    "spark.hadoop.fs.azure.account.oauth2.client.id.ingest02curatedsbox.dfs.core.windows.net" : "{{secrets/key-vault-secrets/client-id}}",
    "spark.hadoop.fs.azure.account.oauth2.client.secret.ingest02curatedsbox.dfs.core.windows.net" : "{{secrets/key-vault-secrets/client-secret}}",
    "spark.hadoop.fs.azure.account.oauth2.client.endpoint.ingest02curatedsbox.dfs.core.windows.net" : "https://login.microsoftonline.com/{{secrets/key-vault-secrets/tenant-id}}/oauth2/token"

    #Ingest
    "spark.hadoop.fs.azure.account.auth.type.ingest02externalsbox.dfs.core.windows.net" : "OAuth",
    "spark.hadoop.fs.azure.account.oauth.provider.type.ingest02externalsbox.dfs.core.windows.net" : "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
    "spark.hadoop.fs.azure.account.oauth2.client.id.ingest02externalsbox.dfs.core.windows.net" : "{{secrets/key-vault-secrets/client-id}}",
    "spark.hadoop.fs.azure.account.oauth2.client.secret.ingest02externalsbox.dfs.core.windows.net" : "{{secrets/key-vault-secrets/client-secret}}",
    "spark.hadoop.fs.azure.account.oauth2.client.endpoint.ingest02externalsbox.dfs.core.windows.net" : "https://login.microsoftonline.com/{{secrets/key-vault-secrets/tenant-id}}/oauth2/token"

  }
  sql_config_params = {
    "ANSI_MODE" : "true"
  }
}