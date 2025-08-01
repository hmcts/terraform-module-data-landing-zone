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

variable "legacy_databases" {
  description = "Map of legacy databases to create as IaaS VMs."
  type = map(object({
    size                = optional(string, "Standard_D4ds_v5")
    type                = optional(string, "windows")
    public_ip           = optional(bool, false)
    computer_name       = optional(string)
    publisher_name      = optional(string)
    offer               = optional(string)
    sku                 = optional(string)
    version             = optional(string)
    source_image_id     = optional(string)
    os_disk_size_gb     = optional(number, 127)
    secure_boot_enabled = optional(bool, true)
  }))
  default = {}
  validation {
    condition = alltrue(
      [for k, v in var.legacy_databases : (
        (v.publisher_name != null && v.offer != null && v.sku != null && v.version != null) || v.source_image_id != null
      )]
    )
    error_message = "All legacy databases must either provide a image publisher name, offer sku and version or a source image id."
  }
}

variable "use_microsoft_ip_kit_structure" {
  description = "Whether to use the Microsoft IP Kit structure for the network. Defaults to false."
  type        = bool
  default     = false
}

variable "additional_nsg_rules" {
  description = "Map of additional NSG rules to create, keyed by the rule name."
  type = map(object({
    name_override                              = optional(string)
    priority                                   = number
    direction                                  = string
    access                                     = string
    protocol                                   = string
    source_port_range                          = optional(string)
    source_port_ranges                         = optional(list(string))
    destination_port_range                     = optional(string)
    destination_port_ranges                    = optional(list(string))
    source_address_prefix                      = optional(string)
    source_address_prefixes                    = optional(list(string))
    source_application_security_group_ids      = optional(list(string))
    destination_address_prefix                 = optional(string)
    destination_address_prefixes               = optional(list(string))
    destination_application_security_group_ids = optional(list(string))
    description                                = optional(string)
  }))
  default = {}
}

variable "key_vault_readers" {
  description = "List of strings representing the object ids of the users or groups that should have read access to the key vault."
  type        = list(string)
  default     = []
}

variable "adf_deploy_purview_private_endpoints" {
  description = "Whether to deploy a private endpoint for the ADF to Purview connection. Defaults to false."
  type        = bool
  default     = true
}

variable "systemassigned_identity" {
  description = "Assign System identity"
  type        = bool
  default     = false
}

# Azure Monitor
variable "install_azure_monitor" {
  description = "Install Azure Monitor Agent."
  type        = bool
  default     = false
}

variable "github_configuration" {
  description = "Optional GitHub configuration settings for the Azure Data Factory."
  type = map(object({
    branch_name        = string
    git_url            = string
    repository_name    = string
    root_folder        = string
    publishing_enabled = bool
  }))

  default = {}
}

variable "bastion_host_subnet_address_space" {
  type        = list(string)
  description = "The address space covered by the bastion host subnet, must be included in vnet_address_space. Minimum of /26"
  default     = null
}

variable "bastion_host_source_ip_allowlist" {
  type        = list(string)
  description = "The list of IP addresses that are allowed to connect to the bastion host."
  default     = []
}

variable "deploy_sftp_storage" {
  description = "Whether to deploy an SFTP storage account. Defaults to false."
  type        = bool
  default     = false
}

variable "f5_vpn_vnet_id" {
  description = "The ID of the F5 VPN VNet."
  type        = string
  default     = "/subscriptions/ed302caf-ec27-4c64-a05e-85731c3ce90e/resourceGroups/mgmt-vpn-2-mgmt/providers/Microsoft.Network/virtualNetworks/mgmt-vpn-2-vnet"
}

variable "deploy_shir" {
  description = "Whether to deploy a self-hosted integration runtime. Defaults to false."
  type        = bool
  default     = false
}
