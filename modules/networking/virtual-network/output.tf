output "id" {
  description = "The virtual NetworkConfiguration ID."
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = " The name of the virtual network."
  value       = azurerm_virtual_network.main.name
}

output "vnet_resource_group" {
  description = " The name of the virtual network."
  value       = azurerm_virtual_network.main.resource_group_name
}

output "address_space" {
  description = "The list of address spaces used by the virtual network."
  value       = azurerm_virtual_network.main.address_space
}

output "guid" {
  description = "The GUID of the virtual network."
  value       = azurerm_virtual_network.main.guid
}

output "peering_id" {
  description = "The ID of the Virtual Network Peering"
  value       = local.peering_ids
}

output "subnets" {
  description = "object list of all subnets"
  value       = azurerm_subnet.main
}

output "subnet_outputs" {
  description = "map of subnets IDs and Address prefixes."
  value       = local.subnet_outputs
}