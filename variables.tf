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