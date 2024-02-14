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

variable "existing_purview_account" {
  description = "Details of an existing purview account to use, if not specified a new one will be created."
  type = object({
    resource_id                              = string
    managed_storage_account_id               = optional(string)
    managed_event_hub_namespace_id           = optional(string)
    self_hosted_integration_runtime_auth_key = optional(string)
    identity = object({
      principal_id = string
      tenant_id    = string
    })
  })
  default = null
}

variable "enable_synapse_sql_pool" {
  description = "Whether to deploy a Synapse SQL pool. Defaults to false."
  type        = bool
  default     = false
}

variable "enable_synapse_spark_pool" {
  description = "Whether to deploy a Synapse Spark pool. Defaults to false."
  type        = bool
  default     = false
}

variable "vm_availabilty_zones" {
  description = "Availability zones for the VMs"
  default     = []
}

variable "additional_subnets" {
  description = "Map of additional subnets to create, keyed by the subnet name."
  type = map(object({
    name_override     = optional(string)
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
    delegations = optional(map(object({
      service_name = string,
      actions      = optional(list(string), [])
    })))
  }))
  default = {}
}
