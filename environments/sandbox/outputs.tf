output "resource_group_name" {
  description = "Resource group name."
  value       = azurerm_resource_group.main.name
}

output "vnet_name" {
  description = "Virtual network name."
  value       = azurerm_virtual_network.main.name
}

output "vm_public_ip" {
  description = "Public IP of the Windows VM."
  value       = azurerm_public_ip.vm.ip_address
}

output "storage_account_name" {
  description = "Storage account name."
  value       = azurerm_storage_account.main.name
}
