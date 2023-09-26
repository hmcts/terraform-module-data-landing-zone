variable "env" {
  description = "Environment value"
  type        = string
}

variable "common_tags" {
  description = "Common tag to be applied to resources"
  type        = map(string)
}
