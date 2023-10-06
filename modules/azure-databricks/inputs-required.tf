variable "name" {
  description = "The name of the private endpoint"
  type        = string
}

variable "resource_group" {
  description = "The name of the resource group"
  type        = string
}

variable "vnet_id" {
  description = "The ID of the virtual network."
  type        = string
}

variable "public_subnet_name" {
  description = "The the name of the public subnet."
  type        = string
}

variable "public_subnet_nsg_id" {
  description = "The the ID of the NSG associated with the public subnet."
  type        = string
}

variable "private_subnet_name" {
  description = "The the name of the public subnet."
  type        = string
}

variable "private_subnet_nsg_id" {
  description = "The the ID of the NSG associated with the public subnet."
  type        = string
}

variable "common_tags" {
  description = "Common tags to be applied to resources."
  type        = map(string)
}
