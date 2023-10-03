variable "existing_resource_group_name" {
  description = "Name of existing resource group to deploy resources into"
  type        = string
  default     = null
}

variable "location" {
  description = "Target Azure location to deploy the resource"
  type        = string
  default     = "UK South"
}

variable "name" {
  description = "The default name will be data-landing+env, you can override the data-landing part by setting this"
  type        = string
  default     = null
}

variable "log_analytics_sku" {
  description = "The sku of the log analytics workspace, will default to PerGB2018."
  type        = string
  default     = "PerGB2018"
}

variable "storage_account_kind" {
  description = "The storage account kind, will default to StorageV2."
  type        = string
  default     = "StorageV2"
}

variable "storage_account_tier" {
  description = "The storage account tier, will default to Standard."
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "The replication type of the storage account, will default to LRS."
  type        = string
  default     = "LRS"
}

variable "prefix" {
  description = "Specifies the prefix for all resources created in this deployment"
  type        = string
  default     = "prefix"
}
