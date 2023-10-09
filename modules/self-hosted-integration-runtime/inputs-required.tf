variable "name" {
  description = "The name of the shared integration runtime."
  type        = string
}

variable "resource_group" {
  description = "The name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to attach the private endpoint to."
  type        = string
}

variable "common_tags" {
  description = "Common tags to be applied to resources."
  type        = map(string)
}

variable "env" {
  description = "Environment value"
  type        = string
}

variable "key_vault_id" {
  description = "The ID of the KeyVault to store the integration runtime credentials in."
  type        = string
}
