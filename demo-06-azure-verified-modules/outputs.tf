# Resource Group outputs
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.demo.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.demo.id
}

# Virtual Network outputs
output "vnet_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.demo.name
}

output "vnet_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.demo.id
}

output "vnet_address_space" {
  description = "The address space of the virtual network"
  value       = azurerm_virtual_network.demo.address_space
}

output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value = {
    web  = azurerm_subnet.web.id
    app  = azurerm_subnet.app.id
    data = azurerm_subnet.data.id
  }
}

# Storage Account outputs
output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.demo.name
}

output "storage_account_id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.demo.id
}

output "storage_primary_endpoints" {
  description = "Primary endpoints for the storage account"
  value = {
    blob  = azurerm_storage_account.demo.primary_blob_endpoint
    file  = azurerm_storage_account.demo.primary_file_endpoint
    queue = azurerm_storage_account.demo.primary_queue_endpoint
    table = azurerm_storage_account.demo.primary_table_endpoint
  }
}

# Deployment summary
output "deployment_summary" {
  description = "Summary of deployment showing how to use Azure Verified Modules"
  value       = <<-EOT
    ================================================
    AZURE VERIFIED MODULES DEMONSTRATION
    ================================================
    
    Resource Group:     ${azurerm_resource_group.demo.name}
    Location:           ${azurerm_resource_group.demo.location}
    
    === Virtual Network ===
    Name:               ${azurerm_virtual_network.demo.name}
    Address Space:      ${join(", ", azurerm_virtual_network.demo.address_space)}
    Subnets:            3 (web, app, data)
    
    === Storage Account ===
    Name:               ${azurerm_storage_account.demo.name}
    Tier:               Standard
    Replication:        LRS
    Versioning:         Enabled
    
    === About Azure Verified Modules (AVM) ===
    This demo shows standard Terraform resources.
    In production, you would use AVM modules from:
    - https://registry.terraform.io/namespaces/Azure
    
    Popular AVM modules:
    - Azure/avm-res-network-virtualnetwork/azurerm
    - Azure/avm-res-storage-storageaccount/azurerm
    - Azure/avm-res-keyvault-vault/azurerm
    - Azure/avm-res-compute-virtualmachine/azurerm
    
    Benefits of AVM:
    - Microsoft endorsed
    - Production ready
    - Regularly updated
    - Comprehensive testing
    - Best practices built-in
    
    ================================================
  EOT
}
