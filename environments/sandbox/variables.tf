variable "subscription_id" {
  description = "Target Azure subscription ID."
  type        = string
}

variable "location" {
  description = "Azure region for the sandbox environment."
  type        = string
}

variable "project_name" {
  description = "Short project name used in resource naming."
  type        = string
}

variable "environment_name" {
  description = "Environment name used for naming and tagging."
  type        = string
  default     = "sandbox"
}

variable "tags" {
  description = "Common tags for all resources."
  type        = map(string)
  default     = {}
}

variable "vnet_address_space" {
  description = "Address space for the virtual network."
  type        = list(string)
  default     = ["10.20.0.0/16"]
}

variable "vm_subnet_name" {
  description = "Name of the subnet used for the Windows VM and SQL private endpoint."
  type        = string
  default     = "snet-vm"
}

variable "vm_subnet_address_prefix" {
  description = "Address prefix for the VM subnet."
  type        = string
  default     = "10.20.1.0/24"
}

variable "app_subnet_name" {
  description = "Name of the second subnet."
  type        = string
  default     = "snet-app"
}

variable "app_subnet_address_prefix" {
  description = "Address prefix for the second subnet."
  type        = string
  default     = "10.20.2.0/24"
}

variable "allowed_rdp_cidr" {
  description = "CIDR allowed to RDP to the Windows VM (for example, your public IP /32)."
  type        = string
}

variable "vm_size" {
  description = "Azure VM size for the Windows VM."
  type        = string
  default     = "Standard_B2s"
}

variable "vm_admin_username" {
  description = "Administrator username for the Windows VM."
  type        = string
}

variable "vm_admin_password" {
  description = "Administrator password for the Windows VM."
  type        = string
  sensitive   = true
}

variable "storage_account_tier" {
  description = "Performance tier for the storage account."
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "Replication type for the storage account."
  type        = string
  default     = "LRS"
}
