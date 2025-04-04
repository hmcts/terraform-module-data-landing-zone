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

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}