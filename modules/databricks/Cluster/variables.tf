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

variable "env" {
  description = "Environment name"
  type        = string
}