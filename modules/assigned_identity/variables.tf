variable "location" {
  description = "Azure region"
  type        = string
  default     = "UK South"
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "env" {
  description = "Environment name"
  type        = string
}