# Output values for configuring remote state in other demos
output "resource_group_name" {
  description = "The name of the resource group for state storage"
  value       = azurerm_resource_group.state.name
}

output "storage_account_name" {
  description = "The name of the storage account for state files"
  value       = azurerm_storage_account.tfstate.name
}

output "container_name" {
  description = "The name of the blob container for state files"
  value       = azurerm_storage_container.tfstate.name
}

output "backend_config" {
  description = "Backend configuration for use in other Terraform deployments"
  value       = <<-EOT
    
    ========================================
    BACKEND CONFIGURATION
    ========================================
    
    Add this to your Terraform configuration:
    
    terraform {
      backend "azurerm" {
        resource_group_name  = "${azurerm_resource_group.state.name}"
        storage_account_name = "${azurerm_storage_account.tfstate.name}"
        container_name       = "${azurerm_storage_container.tfstate.name}"
        key                  = "terraform.tfstate"
      }
    }
    
    Or use backend config file (backend.hcl):
    
    resource_group_name  = "${azurerm_resource_group.state.name}"
    storage_account_name = "${azurerm_storage_account.tfstate.name}"
    container_name       = "${azurerm_storage_container.tfstate.name}"
    key                  = "terraform.tfstate"
    
    Then initialize with: terraform init -backend-config=backend.hcl
    
    ========================================
  EOT
}

output "primary_access_key" {
  description = "Storage account primary access key (sensitive)"
  value       = azurerm_storage_account.tfstate.primary_access_key
  sensitive   = true
}
