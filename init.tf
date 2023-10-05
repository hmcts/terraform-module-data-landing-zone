terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.43.0"
    }
  }
}

provider "azurerm" {
  alias                      = "ssptl"
  skip_provider_registration = true
  features {}
  subscription_id = "6c4d2513-a873-41b4-afdd-b05a33206631"
}

provider "azurerm" {
  alias                      = "cftptl"
  skip_provider_registration = true
  features {}
  subscription_id = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"

}
