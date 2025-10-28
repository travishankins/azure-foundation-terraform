output "vm_id" {
  description = "ID of the Virtual Machine"
  value       = azurerm_windows_virtual_machine.main.id
}

output "vm_name" {
  description = "Name of the Virtual Machine"
  value       = azurerm_windows_virtual_machine.main.name
}

output "vm_hostname" {
  description = "Hostname of the Virtual Machine"
  value       = azurerm_windows_virtual_machine.main.computer_name
}

output "vm_public_ip_address" {
  description = "Public IP address of the Virtual Machine"
  value       = one(azurerm_public_ip.main[*].ip_address)
}

output "vm_public_ip_id" {
  description = "Public IP ID of the Virtual Machine"
  value       = one(azurerm_public_ip.main[*].id)
}

output "vm_public_domain_name_label" {
  description = "Public DNS of the Virtual machine"
  value       = one(azurerm_public_ip.main[*].domain_name_label)
}

output "vm_private_ip_address" {
  description = "Private IP address of the Virtual Machine"
  value       = azurerm_network_interface.main.private_ip_address
}

output "vm_nic_name" {
  description = "Name of the Network Interface Configuration attached to the Virtual Machine"
  value       = azurerm_network_interface.main.name
}

output "vm_nic_id" {
  description = "ID of the Network Interface Configuration attached to the Virtual Machine"
  value       = azurerm_network_interface.main.id
}

output "vm_nic_ip_configuration_name" {
  description = "Name of the IP Configuration for the Network Interface Configuration attached to the Virtual Machine"
  value       = local.ip_configuration_name
}

output "vm_identity" {
  description = "Identity block with principal ID"
  value       = azurerm_windows_virtual_machine.main.identity
}

output "vm_admin_username" {
  description = "Windows Virtual Machine administrator account username"
  value       = var.admin_username
  sensitive   = true
}

output "vm_admin_password" {
  description = "Windows Virtual Machine administrator account password"
  value       = var.admin_password
  sensitive   = true
}
