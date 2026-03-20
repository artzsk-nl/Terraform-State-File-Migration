provider "azurerm" {
  features {
  }
  resource_provider_registrations = "none"
  subscription_id                 = "d3ee0257-dea0-49db-8e34-03cdcf1d0ab5"
  storage_use_azuread             = true
  environment                     = "public"
  use_msi                         = false
  use_cli                         = true
  use_oidc                        = false
}
