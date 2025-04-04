provider "azurerm" {
  features {}
  subscription_id = "df72bb30-d6fb-47bd-82ee-5eb87473ddb3"
}

provider "azurerm" {
  features {}
  alias           = "hub"
  subscription_id = "ea3a8c1e-af9d-4108-bc86-a7e2d267f49c"
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  alias                           = "f5"
  subscription_id                 = "ed302caf-ec27-4c64-a05e-85731c3ce90e"
}

provider "azurerm" {
  alias                           = "ssptl"
  resource_provider_registrations = "none"
  features {}
  subscription_id = "64b1c6d6-1481-44ad-b620-d8fe26a2c768"
}

provider "azurerm" {
  alias                           = "cftptl"
  resource_provider_registrations = "none"
  features {}
  subscription_id = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
}

provider "azurerm" {
  alias                           = "soc"
  resource_provider_registrations = "none"
  features {}
  subscription_id = "8ae5b3b6-0b12-4888-b894-4cec33c92292"
}

provider "azurerm" {
  alias                           = "cnp"
  resource_provider_registrations = "none"
  features {}
  subscription_id = "1c4f0704-a29e-403d-b719-b90c34ef14c9"
}
provider "azurerm" {
  alias                           = "dcr"
  resource_provider_registrations = "none"
  features {}
  subscription_id = var.env == "prod" || var.env == "production" ? "8999dec3-0104-4a27-94ee-6588559729d1" : var.env == "sbox" || var.env == "sandbox" ? "bf308a5c-0624-4334-8ff8-8dca9fd43783" : "1c4f0704-a29e-403d-b719-b90c34ef14c9"
}
