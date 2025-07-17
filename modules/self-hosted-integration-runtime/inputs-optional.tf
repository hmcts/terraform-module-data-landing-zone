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
  default     = "Standard_D4ds_v5"
}

variable "availability_zones" {
  description = "List of availability zones VMSS instances should be deployed over."
  type        = list(string)
  default     = ["1"]
}

variable "instances" {
  description = "The number of instances the VMSS should deploy."
  type        = number
  default     = 1
}
