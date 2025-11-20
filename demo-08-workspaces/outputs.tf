# Outputs for Demo 8: Terraform Workspaces

output "current_workspace" {
  description = "The current Terraform workspace"
  value       = terraform.workspace
}

output "workspace_configuration" {
  description = "Configuration for the current workspace"
  value = {
    workspace           = terraform.workspace
    environment         = local.config.environment
    location            = local.config.location
    vm_size             = local.config.vm_size
    instance_count      = local.config.instance_count
    storage_replication = local.config.storage_replication
    enable_backups      = local.config.enable_backups
    enable_monitoring   = local.config.enable_monitoring
    address_space       = local.config.address_space
    sku_tier            = local.config.sku_tier
  }
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "virtual_network_address_space" {
  description = "Address space of the virtual network"
  value       = azurerm_virtual_network.main.address_space
}

output "subnet_details" {
  description = "Details of all subnets"
  value = {
    for key, subnet in azurerm_subnet.subnets : key => {
      name             = subnet.name
      address_prefixes = subnet.address_prefixes
    }
  }
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "storage_account_replication" {
  description = "Storage account replication type"
  value       = azurerm_storage_account.main.account_replication_type
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace (if enabled)"
  value       = local.config.enable_monitoring ? azurerm_log_analytics_workspace.main[0].id : "Not deployed in this workspace"
}

output "nsg_rules_count" {
  description = "Number of NSG rules (varies by workspace)"
  value       = length(azurerm_network_security_group.web.security_rule)
}

output "deployment_summary" {
  description = "Summary of the deployment configuration"
  value       = <<-EOT
    ==============================================
    WORKSPACE DEPLOYMENT SUMMARY
    ==============================================
    
    Workspace Information:
    - Current Workspace: ${terraform.workspace}
    - Environment: ${local.config.environment}
    - Location: ${local.config.location}
    
    Resource Configuration:
    - Resource Group: ${azurerm_resource_group.main.name}
    - VNet Name: ${azurerm_virtual_network.main.name}
    - Address Space: ${local.config.address_space}
    - Storage Name: ${azurerm_storage_account.main.name}
    - Storage Replication: ${local.config.storage_replication}
    
    Workspace-Specific Settings:
    - VM Size: ${local.config.vm_size}
    - Instance Count: ${local.config.instance_count}
    - Backups Enabled: ${local.config.enable_backups}
    - Monitoring Enabled: ${local.config.enable_monitoring}
    - SKU Tier: ${local.config.sku_tier}
    
    Security:
    - NSG Rules: ${length(azurerm_network_security_group.web.security_rule)}
    - HTTPS: Allowed
    - HTTP: ${local.workspace == "prod" ? "Denied" : "Allowed"}
    - SSH: ${local.workspace == "dev" || local.workspace == "default" ? "Allowed" : "Denied"}
    
    State Management:
    - Backend: Azure Storage (azurerm)
    - State File: env:/${terraform.workspace}/demo08-workspaces.tfstate
    - Isolation: Complete (workspace-level)
    
    ==============================================
  EOT
}

output "workspace_comparison" {
  description = "Comparison of all workspace configurations"
  value = {
    for ws_name, ws_config in local.workspace_config : ws_name => {
      environment         = ws_config.environment
      location            = ws_config.location
      vm_size             = ws_config.vm_size
      storage_replication = ws_config.storage_replication
      enable_monitoring   = ws_config.enable_monitoring
      address_space       = ws_config.address_space
    }
  }
}
