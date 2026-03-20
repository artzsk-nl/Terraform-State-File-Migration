resource "azurerm_virtual_machine_extension" "res-0" {
  auto_upgrade_minor_version = true
  name                       = "MDE.Windows"
  publisher                  = "Microsoft.Azure.AzureDefenderForServers"
  settings = jsonencode({
    autoUpdate        = true
    azureResourceId   = "/subscriptions/d3ee0257-dea0-49db-8e34-03cdcf1d0ab5/resourceGroups/RG-LZLAB-SANDBOX/providers/Microsoft.Compute/virtualMachines/vm-lzlab-sandbox"
    forceReOnboarding = false
    vNextEnabled      = true
  })
  type                 = "MDE.Windows"
  type_handler_version = "1.0"
  virtual_machine_id   = "/subscriptions/d3ee0257-dea0-49db-8e34-03cdcf1d0ab5/resourceGroups/RG-LZLAB-SANDBOX/providers/Microsoft.Compute/virtualMachines/vm-lzlab-sandbox"
  depends_on = [
    azurerm_windows_virtual_machine.res-2,
  ]
}
resource "azurerm_resource_group" "res-1" {
  location = "swedencentral"
  name     = "rg-lzlab-sandbox"
  tags = {
    application = "landing-zone-simple-lab"
    costCenter  = "it-shared"
    environment = "sandbox"
    managedBy   = "terraform"
    owner       = "platform-team"
    workload    = "lzlab"
  }
}
resource "azurerm_windows_virtual_machine" "res-2" {
  admin_password        = "ignored-as-imported"
  admin_username        = "azureadmin"
  location              = "swedencentral"
  name                  = "vm-lzlab-sandbox"
  network_interface_ids = [azurerm_network_interface.res-4.id]
  os_managed_disk_id    = "/subscriptions/d3ee0257-dea0-49db-8e34-03cdcf1d0ab5/resourceGroups/rg-lzlab-sandbox/providers/Microsoft.Compute/disks/vm-lzlab-sandbox_OsDisk_1_a9c96747333b4440b54fbaa5435b1a0e"
  resource_group_name   = azurerm_resource_group.res-1.name
  size                  = "Standard_B2s"
  tags = {
    application = "landing-zone-simple-lab"
    costCenter  = "it-shared"
    environment = "sandbox"
    managedBy   = "terraform"
    owner       = "platform-team"
    workload    = "lzlab"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}
resource "azurerm_key_vault" "res-3" {
  location            = "swedencentral"
  name                = "kv-newresourceportal"
  resource_group_name = azurerm_resource_group.res-1.name
  sku_name            = "standard"
  tenant_id           = "79449e39-ff82-4e11-9220-ff7ccb89dd80"
}
resource "azurerm_network_interface" "res-4" {
  location            = "swedencentral"
  name                = "nic-lzlab-sandbox-vm"
  resource_group_name = azurerm_resource_group.res-1.name
  tags = {
    application = "landing-zone-simple-lab"
    costCenter  = "it-shared"
    environment = "sandbox"
    managedBy   = "terraform"
    owner       = "platform-team"
    workload    = "lzlab"
  }
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.res-10.id
    subnet_id                     = "/subscriptions/d3ee0257-dea0-49db-8e34-03cdcf1d0ab5/resourceGroups/rg-lzlab-sandbox/providers/Microsoft.Network/virtualNetworks/vnet-lzlab-sandbox/subnets/snet-vm"
  }
}
resource "azurerm_network_interface_security_group_association" "res-5" {
  network_interface_id      = azurerm_network_interface.res-4.id
  network_security_group_id = azurerm_network_security_group.res-6.id
}
resource "azurerm_network_security_group" "res-6" {
  location            = "swedencentral"
  name                = "nsg-lzlab-sandbox-vm"
  resource_group_name = azurerm_resource_group.res-1.name
  tags = {
    application = "landing-zone-simple-lab"
    costCenter  = "it-shared"
    environment = "sandbox"
    managedBy   = "terraform"
    owner       = "platform-team"
    workload    = "lzlab"
  }
}
resource "azurerm_private_dns_zone" "res-7" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.res-1.name
}
resource "azurerm_private_dns_zone_virtual_network_link" "res-8" {
  name                  = "rdm5jg65rcq3o"
  private_dns_zone_name = "privatelink.blob.core.windows.net"
  resource_group_name   = azurerm_resource_group.res-1.name
  virtual_network_id    = azurerm_virtual_network.res-11.id
  depends_on = [
    azurerm_private_dns_zone.res-7,
  ]
}
resource "azurerm_private_endpoint" "res-9" {
  custom_network_interface_name = "pe-stlzlabsandboxhkvmsw-nic"
  location                      = "swedencentral"
  name                          = "pe-stlzlabsandboxhkvmsw"
  resource_group_name           = azurerm_resource_group.res-1.name
  subnet_id                     = "/subscriptions/d3ee0257-dea0-49db-8e34-03cdcf1d0ab5/resourceGroups/rg-lzlab-sandbox/providers/Microsoft.Network/virtualNetworks/vnet-lzlab-sandbox/subnets/snet-app"
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.res-7.id]
  }
  private_service_connection {
    is_manual_connection           = false
    name                           = "pe-stlzlabsandboxhkvmsw"
    private_connection_resource_id = "/subscriptions/d3ee0257-dea0-49db-8e34-03cdcf1d0ab5/resourceGroups/rg-lzlab-sandbox/providers/Microsoft.Storage/storageAccounts/stlzlabsandboxhkvmsw"
    subresource_names              = ["blob"]
  }
}
resource "azurerm_public_ip" "res-10" {
  allocation_method   = "Static"
  location            = "swedencentral"
  name                = "pip-lzlab-sandbox-vm"
  resource_group_name = azurerm_resource_group.res-1.name
  tags = {
    application = "landing-zone-simple-lab"
    costCenter  = "it-shared"
    environment = "sandbox"
    managedBy   = "terraform"
    owner       = "platform-team"
    workload    = "lzlab"
  }
}
resource "azurerm_virtual_network" "res-11" {
  address_space       = ["10.20.0.0/16"]
  location            = "swedencentral"
  name                = "vnet-lzlab-sandbox"
  resource_group_name = azurerm_resource_group.res-1.name
  tags = {
    application = "landing-zone-simple-lab"
    costCenter  = "it-shared"
    environment = "sandbox"
    managedBy   = "terraform"
    owner       = "platform-team"
    workload    = "lzlab"
  }
}
resource "azurerm_storage_account" "res-12" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = "swedencentral"
  name                     = "stlzlabsandboxhkvmsw"
  resource_group_name      = azurerm_resource_group.res-1.name
  tags = {
    application = "landing-zone-simple-lab"
    costCenter  = "it-shared"
    environment = "sandbox"
    managedBy   = "terraform"
    owner       = "platform-team"
    workload    = "lzlab"
  }
}
