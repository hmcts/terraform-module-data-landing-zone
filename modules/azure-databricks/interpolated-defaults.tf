locals {
  managed_resource_group_name = var.managed_resource_group_name == null ? "${var.name}-managed-rg" : var.managed_resource_group_name
}
