provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  alias           = "hub"
  subscription_id = "fb084706-583f-4c9a-bdab-949aac66ba5c"
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

provider "azurerm" {
  alias                      = "soc"
  skip_provider_registration = true
  features {}
  subscription_id = "8ae5b3b6-0b12-4888-b894-4cec33c92292"
}

provider "azurerm" {
  alias                      = "cnp"
  skip_provider_registration = true
  features {}
  subscription_id = "1c4f0704-a29e-403d-b719-b90c34ef14c9"
}
provider "azurerm" {
  alias                      = "dcr"
  skip_provider_registration = "true"
  features {}
  subscription_id = var.env == "prod" || var.env == "production" ? "8999dec3-0104-4a27-94ee-6588559729d1" : var.env == "sbox" || var.env == "sandbox" ? "bf308a5c-0624-4334-8ff8-8dca9fd43783" : "1c4f0704-a29e-403d-b719-b90c34ef14c9"
}
