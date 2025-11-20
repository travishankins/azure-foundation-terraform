# Demo 2B: Remote State Setup Using AzAPI Provider
# This demonstrates using the AzAPI provider for direct ARM API calls
# Compare this to Demo 2 which uses the AzureRM provider

# Random string for unique storage account name
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Resource group for state storage - Using AzureRM (standard approach)
resource "azurerm_resource_group" "state" {
  name     = "rg-terraform-state-azapi"
  location = "East US"

  tags = {
    Environment = "Shared"
    Purpose     = "Terraform Remote State"
    ManagedBy   = "Terraform"
    Demo        = "02B-Remote-State-AzAPI"
    Provider    = "AzureRM"
  }
}

# Storage account for Terraform state - Using AzAPI
resource "azapi_resource" "storage_account" {
  type      = "Microsoft.Storage/storageAccounts@2023-01-01"
  name      = "tfstate${random_string.suffix.result}"
  parent_id = azurerm_resource_group.state.id
  location  = azurerm_resource_group.state.location

  body = jsonencode({
    sku = {
      name = "Standard_LRS"
    }
    kind = "StorageV2"
    properties = {
      minimumTlsVersion        = "TLS1_2"
      allowBlobPublicAccess    = false
      allowSharedKeyAccess     = true
      publicNetworkAccess      = "Enabled"
      supportsHttpsTrafficOnly = true
      accessTier               = "Hot"
    }
  })

  tags = {
    Environment = "Shared"
    Purpose     = "Terraform Remote State"
    ManagedBy   = "Terraform"
    Demo        = "02B-Remote-State-AzAPI"
    Provider    = "AzAPI"
  }

  response_export_values = ["properties.primaryEndpoints"]
}

# Enable blob versioning using AzAPI update resource
resource "azapi_update_resource" "blob_properties" {
  type        = "Microsoft.Storage/storageAccounts/blobServices@2023-01-01"
  resource_id = "${azapi_resource.storage_account.id}/blobServices/default"

  body = jsonencode({
    properties = {
      isVersioningEnabled = true
      deleteRetentionPolicy = {
        enabled = true
        days    = 7
      }
    }
  })
}


# Container for state files - Using AzAPI
resource "azapi_resource" "container" {
  type      = "Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01"
  name      = "tfstate"
  parent_id = "${azapi_resource.storage_account.id}/blobServices/default"

  body = jsonencode({
    properties = {
      publicAccess = "None"
    }
  })

  depends_on = [
    azapi_resource.storage_account,
    azapi_update_resource.blob_properties
  ]
}

# Data source to get storage account keys
data "azurerm_storage_account" "tfstate" {
  name                = azapi_resource.storage_account.name
  resource_group_name = azurerm_resource_group.state.name

  depends_on = [azapi_resource.storage_account]
}
