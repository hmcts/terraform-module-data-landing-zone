variable "resource_group_name" {
  description = "ARIA Sandbox resource group name"
  type        = string
  default     = "ingest00-main-sbox"
}

variable "databricks_token" {
  description = "Databricks authentication token"
  type        = string
  sensitive   = true
  default     = ""
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant ID"
}

variable "client_id" {
  type        = string
  description = "Azure client ID"
}

variable "client_secret" {
  type        = string
  description = "Azure client secret"
  sensitive   = true
}

variable "databricks_workspaces" {
  type = map(object({
    resource_group_name = string
    location            = string
  }))
  default = {
    "ingest00-integration-databricks001-sbox" = {
      resource_group_name = "ingest02-main-sbox"
      location            = "UK South"
    },
    "ingest00-product-databricks001-sbox" = {
      resource_group_name = "ingest02-main-sbox"
      location            = "UK South"
    },
    "ingest02-integration-databricks001-sbox" = {
      resource_group_name = "ingest02-main-sbox"
      location            = "UK South"
    },
    "ingest02-product-databricks001-sbox" = {
      resource_group_name = "ingest02-main-sbox"
      location            = "UK South"
    }
  }
}

variable "databricks_target_workspace" {
  type    = string
  default = "ingest02-product-databricks001-sbox"
}

/* variable "notebook_paths" {
  description = "List of notebook paths and their languages"
  type = list(object({
    path     = string
    language = string
  }))
default = [
    { path = "/Users/andrew.mcdevitt@hmcts.net/Test", language = "PYTHON" },

    #Ara
    { path = "/Users/ara.islam1@hmcts.net/raw_to_bronze/mount_ADLS", language = "PYTHON" },
    { path = "/Users/ara.islam1@hmcts.net/raw_to_bronze/(Clone) _defunct_Bronze_ARIA_Generic", language = "PYTHON" },
    { path = "/Users/ara.islam1@hmcts.net/bronze_to_silver/ARIA_JOH_bronze", language = "PYTHON" },
    { path = "/Users/ara.islam1@hmcts.net/bronze_to_silver/ARIA_JOH_Silver", language = "PYTHON" },
    { path = "/Users/ara.islam1@hmcts.net/bronze_to_silver/ARIA_JOH_Gold", language = "PYTHON" },
    { path = "/Users/ara.islam1@hmcts.net/Publish_to_EventHubs/ADLS_to_EventHubs", language = "PYTHON" },
    { path = "/Users/ara.islam1@hmcts.net/(clone) BAILS/(Dev fix) Dynamic-ARIA-Bails v2", language = "PYTHON" },
    { path = "/Users/ara.islam1@hmcts.net/(clone) BAILS/(original) Dynamic-ARIA-Bails v2", language = "PYTHON" },
    { path = "/Users/ara.islam1@hmcts.net/(clone) BAILS/ARIA-Bails v2", language = "PYTHON" },
    { path = "/Users/ara.islam1@hmcts.net/(clone) BAILS/bails_ack_autoloader", language = "PYTHON" },
    { path = "/Users/ara.islam1@hmcts.net/(clone) BAILS/bails_resp_autoloader", language = "PYTHON" },
    { path = "/Users/ara.islam1@hmcts.net/(clone) BAILS/bails_to_eventhubs", language = "PYTHON" },
    { path = "/Users/ara.islam1@hmcts.net/(clone) BAILS/bails_to_eventhubs_A360", language = "PYTHON" },
    { path = "/Users/ara.islam1@hmcts.net/(clone) BAILS/Dynamic-ARIA-Bails v2", language = "PYTHON" },

    #Naveen
    { path = "/Users/naveen.sriram@hmcts.net/Archive/MountPoints", language = "PYTHON" },
    { path = "/Users/naveen.sriram@hmcts.net/Archive/Test-NSA", language = "PYTHON" },
    { path = "/Users/naveen.sriram@hmcts.net/Archive/Import from Azure Data Lake Store - 2024-08-27", language = "PYTHON" },
    { path = "/Users/naveen.sriram@hmcts.net/ARIADM/ARM/_defunct_BRONZE_ARIADM_ARM_JOH", language = "PYTHON" },
    { path = "/Users/naveen.sriram@hmcts.net/ARIADM/ARM/_dufunct_GOLD_ARIADM_ARM_JOH", language = "PYTHON" },
    { path = "/Users/naveen.sriram@hmcts.net/ARIADM/ARM/_dufunct_SILVER_ARIADM_ARM_JOH", language = "PYTHON" },
    { path = "/Users/naveen.sriram@hmcts.net/ARIADM/ARM/ARIADM_ARM_JOH", language = "PYTHON" },
    { path = "/Users/naveen.sriram@hmcts.net/dbfs:/mnt/ingest00curatedsboxsilver/judicial_officer_1660.json", language = "PYTHON" },
    { path = "/Users/naveen.sriram@hmcts.net/Bronze/_defunct_Bronze_ARIA_Generic", language = "PYTHON" },
    { path = "/Users/naveen.sriram@hmcts.net/Bronze/_defunct_Bronze_ARIA_Transaction", language = "PYTHON" },
    { path = "/Users/naveen.sriram@hmcts.net/Bronze/_defunct_Sample", language = "PYTHON" },
    { path = "/Users/naveen.sriram@hmcts.net/Bronze/_defunct_Sample_240901", language = "PYTHON" },
    { path = "/Users/naveen.sriram@hmcts.net/Bronze/Anlysis", language = "PYTHON" },
    { path = "/Users/naveen.sriram@hmcts.net/Bronze/ARIADM_ARM_JOH", language = "PYTHON" },
    { path = "/Users/naveen.sriram@hmcts.net/Bronze/Bronze_ARIA_Generic", language = "PYTHON" },
    { path = "/Users/naveen.sriram@hmcts.net/Bronze/Silver_ARIA_Generic", language = "PYTHON" }
  ]
}
 */