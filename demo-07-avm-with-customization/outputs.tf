# Outputs for Demo 7: AVM with Customization

# Resource Group
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.main.id
}

# Virtual Network
output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "virtual_network_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value       = azurerm_subnet.subnets
}

# Key Vault
output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.key_vault.name
}

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = module.key_vault.resource_id
}

# output "key_vault_uri" {
#   description = "URI of the Key Vault"
#   value       = module.key_vault.resource.vault_uri
# }

# Storage Account
output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.storage_account.name
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = module.storage_account.resource_id
}

output "storage_account_primary_blob_endpoint" {
  description = "Primary blob endpoint of the storage account"
  value       = module.storage_account.resource.primary_blob_endpoint
  sensitive   = true
}

# Log Analytics
output "log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace"
  value       = module.log_analytics.resource.name
  sensitive   = true
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = module.log_analytics.resource_id
}

# Custom Naming Information
output "naming_convention" {
  description = "Details about the custom naming convention used"
  value = {
    prefix          = local.prefix
    environment     = local.environment
    suffix          = local.suffix
    resource_group  = local.resource_group_name
    virtual_network = local.virtual_network_name
    key_vault       = local.key_vault_name
    storage_account = local.storage_account_name
    naming_pattern  = "{prefix}-{resource-type}-{environment}-{suffix}"
  }
}

# Deployment Summary
output "deployment_summary" {
  description = "Summary of deployed resources"
  value = {
    organization = var.organization_prefix
    environment  = var.environment
    location     = var.location
    resources_deployed = [
      "Resource Group",
      "Virtual Network (3 subnets)",
      "Key Vault",
      "Storage Account (3 containers)",
      "Log Analytics Workspace"
    ]
    avm_modules_used = [
      "Azure/avm-res-network-virtualnetwork/azurerm",
      "Azure/avm-res-keyvault-vault/azurerm",
      "Azure/avm-res-storage-storageaccount/azurerm",
      "Azure/avm-res-operationalinsights-workspace/azurerm"
    ]
  }
}
