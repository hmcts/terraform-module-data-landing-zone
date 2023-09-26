resource "azurerm_resource_group" "this" {
  for_each = toset(local.resource_group_names)
  name     = "${local.name}-${each.key}-${var.env}"
  location = var.location
  tags     = var.common_tags
}
