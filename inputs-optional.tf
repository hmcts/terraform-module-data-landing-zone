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

variable "purview_id" {
  description = "The ID of Azure purview account"
  type        = string
  default     = "/subscriptions/a8140a9e-f1b0-481f-a4de-09e2ee23f7ab/resourceGroups/mi-sbox-rg/providers/Microsoft.Purview/accounts/mi-purview-sbox"
}

variable "purview_managed_storage_id" {
  description = "The ID of the managed storage account for Azure purview account."
  type        = string
  default     = null
}

variable "purview_managed_event_hub_id" {
  description = "The ID of the managed event hub id for Azure purview account."
  type        = string
  default     = null
}

variable "purview_self_hosted_integration_runtime_auth_key" {
  description = "The auth key for the purview self hosted integration runtime."
  type        = string
  default     = null
}
