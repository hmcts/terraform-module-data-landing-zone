terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = ">= 3.116.0"
      configuration_aliases = [azurerm.hub, azurerm.ssptl, azurerm.cftptl, azurerm.soc, azurerm.cnp, azurerm.dcr]
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.43.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.1.0"
    }
  }
}
