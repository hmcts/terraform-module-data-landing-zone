/* resource "azurerm_key_vault" "ingest00-meta002-sbox" {

#ingest00curatedsbox
  access_policy {
    certificate_permissions = ["Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "SetIssuers", "Update"]
    key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "GetRotationPolicy", "Import", "List", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"]
    object_id               = "59bab40b-0894-4faf-9f92-0f627108107a"
    secret_permissions      = ["Delete", "Get", "List", "Purge", "Recover", "Set"]
    tenant_id               = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
  }

#ingest001-functionapp-apl
  access_policy {
    certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
    key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "GetRotationPolicy", "Import", "List", "Purge", "Recover", "Release", "Restore", "Rotate", "SetRotationPolicy", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"]
    object_id               = "156acf15-1f7b-49b4-bd64-311fb674b079"
    secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
    tenant_id               = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
  }

#af-joh-dev-uks-dlrm-01
  access_policy {
    certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
    key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "GetRotationPolicy", "Import", "List", "Purge", "Recover", "Release", "Restore", "Rotate", "SetRotationPolicy", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"]
    object_id               = "17340817-ef66-42b1-8b9f-96e2880a5591"
    secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
    tenant_id               = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
  }

#af-td-dev-uks-dlrm-01
  access_policy {
    certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
    key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "GetRotationPolicy", "Import", "List", "Purge", "Recover", "Release", "Restore", "Rotate", "SetRotationPolicy", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"]
    object_id               = "2c08ad61-25ae-47f7-9fd4-d38576a5b316"
    secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
    tenant_id               = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
  }

#does not exist?
  access_policy {
    certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
    key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "GetRotationPolicy", "Import", "List", "Purge", "Recover", "Release", "Restore", "Rotate", "SetRotationPolicy", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"]
    object_id               = "6fb3a1c2-e09f-4c9e-9c03-de36d80cd600"
    secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
    tenant_id               = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
  }

#af-bails-dev-uks-dlrm-01
  access_policy {
    certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
    key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "GetRotationPolicy", "Import", "List", "Purge", "Recover", "Release", "Restore", "Rotate", "SetRotationPolicy", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"]
    object_id               = "ae2f0c2e-e19e-4c02-86b4-07c4f099ecc5"
    secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
    tenant_id               = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
  }

#does not exist?
  access_policy {
    certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
    key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "GetRotationPolicy", "Import", "List", "Purge", "Recover", "Release", "Restore", "Rotate", "SetRotationPolicy", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"]
    object_id               = "e17199f4-0619-4bf5-96ed-6bcfcefb06a4"
    secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
    tenant_id               = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
  }

#af-apl-dev-uks-dlrm-01
  access_policy {
    certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Recover", "Restore", "SetIssuers", "Update"]
    key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "GetRotationPolicy", "Import", "List", "Purge", "Recover", "Release", "Restore", "Rotate", "SetRotationPolicy", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"]
    object_id               = "3f4df222-d4c0-4929-9462-d7e55f344745"
    secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
    tenant_id               = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
  }

#does not exist?
  access_policy {
    certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Recover", "Restore", "SetIssuers", "Update"]
    key_permissions         = ["Backup", "Create", "Delete", "Get", "GetRotationPolicy", "Import", "List", "Recover", "Restore", "Rotate", "SetRotationPolicy", "Update"]
    object_id               = "a4ace63f-9e98-4089-babb-012b41eedc17"
    secret_permissions      = ["Backup", "Delete", "Get", "List", "Recover", "Restore", "Set"]
    tenant_id               = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
  }

#does not exist?
  access_policy {
    certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Recover", "Restore", "SetIssuers", "Update"]
    key_permissions         = ["Backup", "Create", "Delete", "Get", "GetRotationPolicy", "Import", "List", "Recover", "Restore", "Rotate", "SetRotationPolicy", "Update"]
    object_id               = "a52008e4-e532-42ec-99d6-befe1cceff53"
    secret_permissions      = ["Backup", "Delete", "Get", "List", "Recover", "Restore", "Set"]
    tenant_id               = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
  }

#does not exist?
  access_policy {
    certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Recover", "Restore", "SetIssuers", "Update"]
    key_permissions         = ["Backup", "Create", "Delete", "Get", "GetRotationPolicy", "Import", "List", "Recover", "Restore", "Rotate", "SetRotationPolicy", "Update"]
    object_id               = "b06ff259-afa1-403c-b92e-dd2614a0b68f"
    secret_permissions      = ["Backup", "Delete", "Get", "List", "Recover", "Restore", "Set"]
    tenant_id               = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
  }

#does not exist?
  access_policy {
    certificate_permissions = ["Get", "List"]
    key_permissions         = ["Get", "List"]
    object_id               = "145da22b-a3cb-4ba8-b735-22c94b5eea6c"
    secret_permissions      = ["Get", "List"]
    tenant_id               = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
  }

#as above
  access_policy {
    certificate_permissions = ["Get", "List"]
    key_permissions         = ["Get", "List"]
    object_id               = "b2a1773c-a5ae-48b5-b5fa-95b0e05eee05"
    secret_permissions      = ["Get", "List"]
    tenant_id               = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
  }

#does not exist
  access_policy {
    certificate_permissions = ["Create", "Delete", "DeleteIssuers", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Recover", "SetIssuers", "Update"]
    key_permissions         = ["Create", "Delete", "Import", "List", "Recover", "Update"]
    object_id               = "e7ea2042-4ced-45dd-8ae3-e051c6551789"
    secret_permissions      = ["Delete", "List", "Recover", "Set"]
    tenant_id               = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
  }

#Azure databricks
  access_policy {
    object_id          = "1a0e2ed8-f79f-4e21-8d69-80cca7711b96"
    secret_permissions = ["Get", "List"]
    tenant_id          = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
  }

#ingest00-integration-dataFactory001-sbox
  access_policy {
    object_id          = "ac00d40a-c005-4e99-8250-2eff2b9e1267"
    secret_permissions = ["Get", "List"]
    tenant_id          = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
  }

# Service Principal
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id 
    secret_permissions = ["Get", "List", "Set", "Delete", "Purge"]
    certificate_permissions = ["Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "SetIssuers", "Update"]
    key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "GetRotationPolicy", "Import", "List", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey","Recover"]

  }

  enable_rbac_authorization       = "false"
  enabled_for_deployment          = "true"
  enabled_for_disk_encryption     = "true"
  enabled_for_template_deployment = "true"
  location                        = "uksouth"
  name                            = "ingest00-meta002-sbox1"

  network_acls {
    bypass         = "AzureServices"
    default_action = "Allow"
  }

  public_network_access_enabled = "true"
  purge_protection_enabled      = "true"
  resource_group_name           = "TEST-ingest00-main-sbox"
  sku_name                      = "standard"
  soft_delete_retention_days    = "90"

  tags = {
    Data-Ingest-Project = "DLRM Ingestion Engine"
    application         = "dlrm-data-ingest"
    autoShutdown        = "true"
    builtFrom           = "hmcts/dlrm-data-ingest-infra"
    businessArea        = "cross-cutting"
    criticality         = "Low"
    environment         = "sandbox"
    expiresAfter        = "3000-01-01"
    startupMode         = "always"
  }

  tenant_id = data.azurerm_client_config.current.tenant_id
} */