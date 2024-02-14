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

variable "builtFrom" {
  type        = string
  description = "The name of the repository these resources are builtFrom."
}

variable "product" {
  type        = string
  description = "The name of the prodcut this infrastructure supports."
}