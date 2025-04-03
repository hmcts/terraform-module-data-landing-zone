# Row 1-55 are Databricks secrets
# Row 56-370 are secrets from ingest00-meta002-sbox
#Store Service Principal credentials in Key Vault (Client ID)

resource "azurerm_key_vault_secret" "client_id" {
  name         = "databricks-sp-client-id"
  value        = data.azurerm_client_config.current.client_id
  key_vault_id = var.ingest00-meta002-sbox_kv_id
}

# Store Service Principal credentials in Key Vault (Client Secret)

resource "azurerm_key_vault_secret" "client_secret" {
  name         = "databricks-sp-client-secret"
  value        = var.client_secret
  key_vault_id = var.ingest00-meta002-sbox_kv_id
}

# Store Service Principal credentials in Key Vault (Tenant ID)

resource "azurerm_key_vault_secret" "tenant_id" {
  name         = "databricks-sp-tenant-id"
  value        = data.azurerm_client_config.current.tenant_id
  key_vault_id = var.ingest00-meta002-sbox_kv_id
}

# Store secrets in Databricks
resource "databricks_secret_scope" "key-vault-secrets" {
  name       = "key-vault-secrets"
  depends_on = [var.databricks_workspace_id]
}

# Store Client ID in Databricks
resource "databricks_secret" "client_id" {
  key          = "client-id"
  string_value = data.azurerm_client_config.current.client_id
  scope        = databricks_secret_scope.key-vault-secrets.name
}

# Store Client secret in Databricks
resource "databricks_secret" "client_secret" {
  key          = "client-secret"
  string_value = var.client_secret
  scope        = databricks_secret_scope.key-vault-secrets.name
}

# Store Tenant ID in Databricks
resource "databricks_secret" "tenant_id" {
  key          = "tenant-id"
  string_value = data.azurerm_client_config.current.tenant_id
  scope        = databricks_secret_scope.key-vault-secrets.name
}

# Create Databricks token
resource "azurerm_key_vault_secret" "databricks_token" {
  name         = "databricks-token"
  value        = var.databricks_token
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

# Use outputs of the relevant endpoints as the secret value for each resource below


/* #APL-DeadLetterEventHubConnectionString secret
resource "random_password" "APL-DeadLetterEventHubConnectionString" {
    length = 16
    special = true
}

resource "azurerm_key_vault_secret" "APL-DeadLetterEventHubConnectionString" {
    name = "APL-DeadLetterEventHubConnectionString-Secret"
    value = random_password.APL-DeadLetterEventHubConnectionString.result
    key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

#ARIAB-SAS-TOKEN
resource "random_password" "ariab_sas_token" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "ariab_sas_token" {
  name         = "ARIAB-SAS-TOKEN"
  value        = random_password.ariab_sas_token.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

#ARIAFTA-SAS-TOKEN
resource "random_password" "ariafta_sas_token" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "ariafta_sas_token" {
  name         = "ARIAFTA-SAS-TOKEN"
  value        = random_password.ariafta_sas_token.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

#ARIAJR-SAS-TOKEN
resource "random_password" "ariajr_sas_token" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "ariajr_sas_token" {
  name         = "ARIAJR-SAS-TOKEN"
  value        = random_password.ariajr_sas_token.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

#ARIASB-SAS-TOKEN
resource "random_password" "ariasb_sas_token" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "ariasb_sas_token" {
  name         = "ARIASB-SAS-TOKEN"
  value        = random_password.ariasb_sas_token.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

#ARIATD-SAS-TOKEN
resource "random_password" "ariatd_sas_token" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "ariatd_sas_token" {
  name         = "ARIATD-SAS-TOKEN"
  value        = random_password.ariatd_sas_token.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

#ARIAUTA-SAS-TOKEN
resource "random_password" "ariauta_sas_token" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "ariauta_sas_token" {
  name         = "ARIAUTA-SAS-TOKEN"
  value        = random_password.ariauta_sas_token.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

#BRONZE-SAS-TOKEN
resource "random_password" "bronze_sas_token" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "bronze_sas_token" {
  name         = "BRONZE-SAS-TOKEN"
  value        = random_password.bronze_sas_token.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

#curated-connection-string-sbox
resource "random_password" "curated_connection_string_sbox" {
  length  = 32
  special = true
}

resource "azurerm_key_vault_secret" "curated_connection_string_sbox" {
  name         = "curated-connection-string-sbox"
  value        = random_password.curated_connection_string_sbox.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

#CURATED-SAS-TOKEN
resource "random_password" "curated_sas_token" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "curated_sas_token" {
  name         = "CURATED-SAS-TOKEN"
  value        = random_password.curated_sas_token.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

#EventHubNamespace-ConnStr
resource "random_password" "eventhub_namespace_connstr" {
  length  = 32
  special = true
}

resource "azurerm_key_vault_secret" "eventhub_namespace_connstr" {
  name         = "EventHubNamespace-ConnStr"
  value        = random_password.eventhub_namespace_connstr.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

#evh_apl_ack_dev_uks_dlrm_01_key
resource "random_password" "evh_apl_ack_dev_uks_dlrm_01_key" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "evh_apl_ack_dev_uks_dlrm_01_key" {
  name         = "evh-apl-ack-dev-uks-dlrm-01-key"
  value        = random_password.evh_apl_ack_dev_uks_dlrm_01_key.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

#evh_apl_ack_uks_dlrm_01
resource "random_password" "evh_apl_ack_uks_dlrm_01" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "evh_apl_ack_uks_dlrm_01" {
  name         = "evh-apl-ack-uks-dlrm-01"
  value        = random_password.evh_apl_ack_uks_dlrm_01.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

#evh_apl_dl_uks_dlrm_01
resource "random_password" "evh_apl_dl_uks_dlrm_01" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "evh_apl_dl_uks_dlrm_01" {
  name         = "evh-apl-dl-uks-dlrm-01"
  value        = random_password.evh_apl_dl_uks_dlrm_01.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

resource "random_password" "evh_apl_pub_uks_dlrm_01" {
  length  = 16
  special = true
}

#evh_apl_pub_uks_dlrm_01
resource "azurerm_key_vault_secret" "evh_apl_pub_uks_dlrm_01" {
  name         = "evh-apl-pub-uks-dlrm-01"
  value        = random_password.evh_apl_pub_uks_dlrm_01.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

resource "random_password" "evh_bl_ack_dev_uks_dlrm_01_key" {
  length  = 16
  special = true
}

#evh_bl_ack_dev_uks_dlrm_01_key
resource "azurerm_key_vault_secret" "evh_bl_ack_dev_uks_dlrm_01_key" {
  name         = "evh-bl-ack-dev-uks-dlrm-01-key"
  value        = random_password.evh_bl_ack_dev_uks_dlrm_01_key.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}


resource "random_password" "evh_bl_dl_dev_uks_dlrm_01_key" {
  length  = 16
  special = true
}

#evh_bl_dl_dev_uks_dlrm_01_key
resource "azurerm_key_vault_secret" "evh_bl_dl_dev_uks_dlrm_01_key" {
  name         = "evh-bl-dl-dev-uks-dlrm-01-key"
  value        = random_password.evh_bl_dl_dev_uks_dlrm_01_key.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

resource "random_password" "evh_bl_pub_dev_uks_dlrm_01_key" {
  length  = 16
  special = true
}

#evh_bl_pub_dev_uks_dlrm_01_key
resource "azurerm_key_vault_secret" "evh_bl_pub_dev_uks_dlrm_01_key" {
  name         = "evh-bl-pub-dev-uks-dlrm-01-key"
  value        = random_password.evh_bl_pub_dev_uks_dlrm_01_key.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

resource "random_password" "evh_joh_ack_dev_uks_dlrm_01_key" {
  length  = 16
  special = true
}

#evh_joh_ack_dev_uks_dlrm_01_key
resource "azurerm_key_vault_secret" "evh_joh_ack_dev_uks_dlrm_01_key" {
  name         = "evh-joh-ack-dev-uks-dlrm-01-key"
  value        = random_password.evh_joh_ack_dev_uks_dlrm_01_key.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

resource "random_password" "evh_joh_dl_dev_uks_dlrm_01_key" {
  length  = 16
  special = true
}

#evh_joh_dl_dev_uks_dlrm_01_key
resource "azurerm_key_vault_secret" "evh_joh_dl_dev_uks_dlrm_01_key" {
  name         = "evh-joh-dl-dev-uks-dlrm-01-key"
  value        = random_password.evh_joh_dl_dev_uks_dlrm_01_key.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

resource "random_password" "evh_td_ack_uks_dlrm_01" {
  length  = 16
  special = true
}

#evh_td_ack_uks_dlrm_01
resource "azurerm_key_vault_secret" "evh_td_ack_uks_dlrm_01" {
  name         = "evh-td-ack-uks-dlrm-01"
  value        = random_password.evh_td_ack_uks_dlrm_01.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

resource "random_password" "evh_td_dl_uks_dlrm_01" {
  length  = 16
  special = true
}

#evh_td_dl_uks_dlrm_01
resource "azurerm_key_vault_secret" "evh_td_dl_uks_dlrm_01" {
  name         = "evh-td-dl-uks-dlrm-01"
  value        = random_password.evh_td_dl_uks_dlrm_01.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

#Gold SAS Token
resource "random_password" "gold_sas_token" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "gold_sas_token" {
  name         = "GOLD-SAS-TOKEN"
  value        = random_password.gold_sas_token.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

#Landing SAS Token
resource "random_password" "landing_sas_token" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "landing_sas_token" {
  name         = "LANDING-SAS-TOKEN"
  value        = random_password.landing_sas_token.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

#Raw SAS Token
resource "random_password" "raw_sas_token" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "raw_sas_token" {
  name         = "RAW-SAS-TOKEN"
  value        = random_password.raw_sas_token.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
}

#Silver SAS Token
resource "random_password" "silver_sas_token" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "silver_sas_token" {
  name         = "SILVER-SAS-TOKEN"
  value        = random_password.silver_sas_token.result
  key_vault_id = azurerm_key_vault.ingest00-meta002-sbox.id
} */