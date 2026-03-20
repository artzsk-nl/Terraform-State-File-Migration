resource "azurerm_resource_group" "landing_zone" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_log_analytics_workspace" "platform" {
  name                = "${var.resource_group_name}-law"
  location            = var.location
  resource_group_name = azurerm_resource_group.landing_zone.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}
