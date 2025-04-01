variable "env" {
  default = "test"
}

variable "common_tags" {
  default = {
    application  = "core"
    builtFrom    = "https://github.com/hmcts/terraform-module-data-landing-zone"
    environment  = "testing"
    businessArea = "Cross-Cutting"
    expiresAfter = "2023-11-01"
  }
}

variable "default_route_next_hop_ip" {
  default = "10.10.200.36"
}


variable "tenant_id" {
  type        = string
  description = "The Azure Tenant ID"
}

variable "client_id" {
  type        = string
  description = "The Azure Client ID"
}

variable "subscription_id" {
  type        = string
  description = "The Azure Subscription ID"
}

variable "client_secret" {
  type        = string
  description = "The Azure Client Secret"
}