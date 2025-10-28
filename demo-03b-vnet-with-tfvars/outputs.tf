# Outputs for VNet Deployment

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.vnet.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.vnet.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_address_space" {
  description = "Address space of the virtual network"
  value       = azurerm_virtual_network.main.address_space
}

output "subnet_ids" {
  description = "Map of subnet IDs"
  value = {
    for k, subnet in azurerm_subnet.subnets : k => subnet.id
  }
}

output "subnet_details" {
  description = "Detailed information about subnets"
  value = {
    for k, subnet in azurerm_subnet.subnets : k => {
      id               = subnet.id
      name             = subnet.name
      address_prefixes = subnet.address_prefixes
    }
  }
}

output "nsg_id" {
  description = "ID of the network security group"
  value       = azurerm_network_security_group.main.id
}

output "nsg_name" {
  description = "Name of the network security group"
  value       = azurerm_network_security_group.main.name
}

output "deployment_summary" {
  description = "Summary of the deployment"
  value       = <<-EOT
    
    ========================================
    VNet Deployment Summary (Using tfvars)
    ========================================
    
    Environment:       ${var.environment}
    Resource Group:    ${azurerm_resource_group.vnet.name}
    Location:          ${azurerm_resource_group.vnet.location}
    
    Virtual Network:   ${azurerm_virtual_network.main.name}
    Address Space:     ${join(", ", azurerm_virtual_network.main.address_space)}
    
    Subnets Created:   ${length(azurerm_subnet.subnets)}
    ${join("\n    ", [for k, subnet in azurerm_subnet.subnets : "- ${subnet.name}: ${join(", ", subnet.address_prefixes)}"])}
    
    NSG:               ${azurerm_network_security_group.main.name}
    NSG Rules:         ${length(var.nsg_rules)}
    
    ========================================
  EOT
}
