output "resource_group_id" {
  description = "Resource ID of the seed resource group."
  value       = azurerm_resource_group.landing_zone.id
}

output "resource_group_name" {
  description = "Name of the seed resource group."
  value       = azurerm_resource_group.landing_zone.name
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.platform.id
}
