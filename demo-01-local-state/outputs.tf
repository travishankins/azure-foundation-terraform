# Output values to display after deployment
output "resource_group_name" {
  description = "The name of the created resource group"
  value       = azurerm_resource_group.demo.name
}

output "resource_group_id" {
  description = "The ID of the created resource group"
  value       = azurerm_resource_group.demo.id
}

output "location" {
  description = "The Azure region where the resource group is deployed"
  value       = azurerm_resource_group.demo.location
}
