terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = ">= 3.7.0"
      configuration_aliases = [azurerm.ssptl, azurerm.cftptl, azurerm.soc, azurerm.cnp]
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.43.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
  }
}
