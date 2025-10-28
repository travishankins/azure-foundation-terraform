# Outputs for the VNet deployment
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.vnet.name
}

output "vnet_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_address_space" {
  description = "The address space of the virtual network"
  value       = azurerm_virtual_network.main.address_space
}

output "subnet_ids" {
  description = "The IDs of all subnets"
  value = {
    web  = azurerm_subnet.subnet1.id
    app  = azurerm_subnet.subnet2.id
    data = azurerm_subnet.subnet3.id
  }
}

output "subnet_address_prefixes" {
  description = "The address prefixes of all subnets"
  value = {
    web  = azurerm_subnet.subnet1.address_prefixes
    app  = azurerm_subnet.subnet2.address_prefixes
    data = azurerm_subnet.subnet3.address_prefixes
  }
}

output "nsg_id" {
  description = "The ID of the network security group"
  value       = azurerm_network_security_group.web.id
}
