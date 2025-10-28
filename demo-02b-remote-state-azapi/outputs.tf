# Outputs for Remote State Configuration

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.state.name
}

output "storage_account_name" {
  description = "Name of the storage account (use this in backend configs)"
  value       = azapi_resource.storage_account.name
}

output "storage_account_id" {
  description = "Resource ID of the storage account"
  value       = azapi_resource.storage_account.id
}

output "container_name" {
  description = "Name of the state container"
  value       = "tfstate"
}

output "primary_access_key" {
  description = "Primary access key for the storage account"
  value       = data.azurerm_storage_account.tfstate.primary_access_key
  sensitive   = true
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint"
  value       = data.azurerm_storage_account.tfstate.primary_blob_endpoint
}

output "storage_account_properties" {
  description = "Storage account properties from AzAPI"
  value       = jsondecode(azapi_resource.storage_account.output).properties
  sensitive   = true
}

output "backend_config" {
  description = "Backend configuration for other demos"
  value       = <<-EOT
    
========================================
BACKEND CONFIGURATION (AzAPI Demo)
========================================
    
Add this to your Terraform configuration:
    
terraform {
  backend "azurerm" {
    resource_group_name  = "${azurerm_resource_group.state.name}"
    storage_account_name = "${azapi_resource.storage_account.name}"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
  }
}
    
Or use backend config file (backend.hcl):
    
resource_group_name  = "${azurerm_resource_group.state.name}"
storage_account_name = "${azapi_resource.storage_account.name}"
container_name       = "tfstate"
key                  = "terraform.tfstate"
use_azuread_auth     = true
    
Then initialize with: terraform init -backend-config=backend.hcl
    
========================================

EOT
}
