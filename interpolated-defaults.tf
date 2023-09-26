data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

locals {
  is_prod              = length(regexall(".*(prod).*", var.env)) > 0
  is_sbox              = length(regexall(".*(s?box).*", var.env)) > 0
  name                 = var.name != null ? var.name : "data-landing"
  resource_group_names = ["network", "management", "logging", "storage", "external-storage", "metadata", "shared-integration", "shared-product", "di001", "di002", "dp001", "dp002"]
}
