variable "location" {
  description = "The Azure Region to deploy the private endpoint to."
  type        = string
  default     = "uksouth"
}

variable "sku" {
  description = "The SKU to deploy databricks with. Defaults to 'premium'."
  type        = string
  default     = "premium"
}

variable "managed_resource_group_name" {
  description = "The name of the databricks managed resource group. Defaults to null and will be based off of the name of the databricks workspace."
  type        = string
  default     = null
}

variable "no_public_ip" {
  description = "Whether or not the databricks workspace should have a public endpoint."
  type        = bool
  default     = false
}

variable "infrastructure_encryption_enabled" {
  description = "Whether or not to enable infrastructure encryption."
  type        = bool
  default     = false
}
