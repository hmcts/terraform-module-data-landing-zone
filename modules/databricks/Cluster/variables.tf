variable "databricks_workspace_url" {
  description = "The URL of the Databricks workspace"
  type        = string
}

# Establish the workspace exists
variable "initialization_complete" {
  description = "Reference to ensure workspace initialization is complete"
  type        = string
  default     = null
}

variable "tenant_id" {
  type        = string
  description = "The Azure tenant ID"
}

variable "client_id" {
  type        = string
  description = "The Azure client ID (service principal ID)"
}

variable "client_secret" {
  type        = string
  description = "The Azure client secret (service principal secret)"
  sensitive   = true  
}