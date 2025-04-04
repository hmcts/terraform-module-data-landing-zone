variable "resource_group_name" {
  description = "ARIA Sandbox resource group name"
  type        = string
  default     = "ingest00-main-sbox"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "UK South"
}


variable "databricks_token" {
  description = "Databricks authentication token"
  type        = string
  sensitive   = true
  default     = ""
}

variable "client_secret" {
  type        = string
  sensitive   = true
  description = "The client secret for the service principal."
}

variable "databricks_workspace_id" {
  type        = string
  description = "The ID of the Databricks workspace."
}

variable "ingest00-meta002-sbox_kv_id" {
  type        = string
  description = "Ingest00-meta-02-sbox key vault ID"
}
