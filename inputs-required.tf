variable "env" {
  description = "Environment value"
  type        = string
}

variable "common_tags" {
  description = "Common tag to be applied to resources"
  type        = map(string)
}

variable "vnet_address_space" {
  type        = list(string)
  description = "The Address space covered by the data landing zone virtual network"
}

variable "services_subnet_address_space" {
  type        = list(string)
  description = "The address space covered by the services subnet, must be included in vnet_address_space."
}

variable "services_bastion_subnet_address_space" {
  type        = list(string)
  description = "The address space covered by the Bastion services subnet, must be included in vnet_address_space."
}

variable "services_mysql_subnet_address_space" {
  type        = list(string)
  description = "The address space covered by the services-mysql subnet, must be included in vnet_address_space. This is delegated to MySQL Flexible Server."
}

variable "data_bricks_public_subnet_address_space" {
  type        = list(string)
  description = "The address space covered by the data bricks public subnet, must be included in vnet_address_space."
}

variable "data_bricks_private_subnet_address_space" {
  type        = list(string)
  description = "The address space covered by the data bricks private subnet, must be included in vnet_address_space."
}

variable "data_bricks_product_public_subnet_address_space" {
  type        = list(string)
  description = "The address space covered by the data bricks product public subnet, must be included in vnet_address_space."
}

variable "data_bricks_product_private_subnet_address_space" {
  type        = list(string)
  description = "The address space covered by the data bricks product private subnet, must be included in vnet_address_space."
}

variable "data_integration_001_subnet_address_space" {
  type        = list(string)
  description = "The address space covered by the data integration 001 subnet, must be included in vnet_address_space."
}

variable "data_integration_002_subnet_address_space" {
  type        = list(string)
  description = "The address space covered by the data integration 002 subnet, must be included in vnet_address_space."
}

variable "data_product_001_subnet_address_space" {
  type        = list(string)
  description = "The address space covered by the data product 001 subnet, must be included in vnet_address_space."
}

variable "data_product_002_subnet_address_space" {
  type        = list(string)
  description = "The address space covered by the data product 002 subnet, must be included in vnet_address_space."
}

variable "default_route_next_hop_ip" {
  type        = string
  description = "The IP address of the private ip configuration of the Hub Palo load balancer."
}

variable "hub_vnet_name" {
  description = "The name of the HUB virtual network."
  type        = string
}

variable "hub_resource_group_name" {
  description = "The name of the resource group containing the HUB virtual network."
  type        = string
}
