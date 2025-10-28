# Resource Group outputs
output "resource_group_name" {
  description = "The name of the resource group"
  value       = module.resource_group.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = module.resource_group.id
}

# Virtual Network outputs
output "vnet_name" {
  description = "The name of the virtual network"
  value       = module.virtual_network.vnet_name
}

output "vnet_id" {
  description = "The ID of the virtual network"
  value       = module.virtual_network.id
}

output "vnet_address_space" {
  description = "The address space of the virtual network"
  value       = module.virtual_network.address_space
}

output "subnet_outputs" {
  description = "Map of created subnets with IDs and address prefixes"
  value       = module.virtual_network.subnet_outputs
}

# Key Vault outputs
output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = module.key_vault.id
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.key_vault.vault_uri
}

# Storage Account outputs
output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.storage_account.name
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = module.storage_account.id
}

output "storage_primary_blob_endpoint" {
  description = "The primary blob endpoint"
  value       = module.storage_account.primary_blob_endpoint
}

# Private DNS Zone outputs
output "private_dns_zone_name" {
  description = "Name of the Private DNS Zone"
  value       = "privatelink.blob.core.windows.net"
}

# Summary output
output "deployment_summary" {
  description = "Summary of all deployed modules"
  value       = <<-EOT
    ========================================
    CUSTOM MODULES DEPLOYMENT SUMMARY
    ========================================
    
    Resource Group:    ${module.resource_group.name}
    Location:          ${var.location}
    
    Virtual Network:   ${module.virtual_network.vnet_name}
    Address Space:     ${join(", ", module.virtual_network.address_space)}
    Subnet Count:      ${length(module.virtual_network.subnet_outputs)}
    Key Vault URI:     ${module.key_vault.vault_uri}
    
    Storage Account:   ${module.storage_account.name}
    Storage Endpoint:  ${module.storage_account.primary_blob_endpoint}
    
    Private DNS Zone:  privatelink.blob.core.windows.net
    
    ========================================
  EOT
}
