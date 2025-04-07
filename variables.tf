variable "databricks_token" {
  description = "Databricks authentication token"
  type        = string
  sensitive   = true
  default     = ""
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