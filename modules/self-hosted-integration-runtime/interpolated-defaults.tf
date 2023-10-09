locals {
  is_prod       = length(regexall(".*(prod).*", var.env)) > 0
  short_name    = var.short_name != null ? var.short_name : substr(var.name, 0, 15)
  frontend_name = "${var.name}-lb-frontend-${var.env}"
}
