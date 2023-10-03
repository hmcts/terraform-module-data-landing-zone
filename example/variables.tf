variable "env" {
  default = "test"
}

variable "common_tags" {
  default = {
    application  = "core"
    builtFrom    = "github.com/hmcts/terraform-module-common-tags"
    environment  = "testing"
    businessArea = "Cross-Cutting"
    expiresAfter = "2023-11-01"
  }
}

variable "default_route_next_hop_ip" {
  default = "10.10.200.36"
}
