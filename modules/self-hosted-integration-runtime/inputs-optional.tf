variable "location" {
  description = "The Azure Region to deploy the private endpoint to."
  type        = string
  default     = "uksouth"
}

variable "short_name" {
  description = "The short name of the shared integration runtime. Maximum of 15 characters."
  type        = string
  default     = null
}

variable "size" {
  description = "The SKU of the VMSS instance."
  type        = string
  default     = "D16ds_v5"
}

variable "availability_zone" {
  description = "The availability zones the VM should be deployed into."
  type        = string
  default     = "1"
}
