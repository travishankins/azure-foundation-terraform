# Basic outputs
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.main.id
}

output "location" {
  description = "The Azure region"
  value       = azurerm_resource_group.main.location
}

# Storage account outputs
output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "storage_account_primary_endpoint" {
  description = "The primary endpoint of the storage account"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}

# Network outputs
output "vnet_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_address_space" {
  description = "The address space of the virtual network"
  value       = azurerm_virtual_network.main.address_space
}

output "subnet_details" {
  description = "Details of all created subnets"
  value = {
    for name, subnet in azurerm_subnet.subnets : name => {
      id               = subnet.id
      name             = subnet.name
      address_prefixes = subnet.address_prefixes
    }
  }
}

# Computed outputs from locals
output "environment_config" {
  description = "Configuration settings for current environment"
  value       = local.current_config
}

output "resource_prefix" {
  description = "The resource naming prefix used"
  value       = local.resource_prefix
}

output "common_tags" {
  description = "Common tags applied to all resources"
  value       = local.common_tags
  sensitive   = false
}

# Conditional output
output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace (prod only)"
  value       = var.environment == "prod" ? azurerm_log_analytics_workspace.main[0].id : "Not deployed in ${var.environment}"
}

# Complex output with formatting
output "deployment_summary" {
  description = "Summary of the deployment"
  value       = <<-EOT
    ===================================
    DEPLOYMENT SUMMARY
    ===================================
    Project:           ${var.project_name}
    Environment:       ${var.environment}
    Location:          ${var.location}
    Resource Group:    ${azurerm_resource_group.main.name}
    VNet:              ${azurerm_virtual_network.main.name}
    Address Space:     ${var.vnet_address_space}
    Subnet Count:      ${length(azurerm_subnet.subnets)}
    Storage Account:   ${azurerm_storage_account.main.name}
    Replication:       ${azurerm_storage_account.main.account_replication_type}
    VM Size (Config):  ${local.current_config.vm_size}
    Backup Enabled:    ${local.current_config.enable_backup}
    ===================================
  EOT
}
