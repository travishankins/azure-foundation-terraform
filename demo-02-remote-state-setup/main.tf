# Demo 2: Storage Account for Remote State
# This creates the infrastructure needed for remote state management

terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}

  # Use Azure AD authentication instead of access keys
  # This is required when subscription policies block key-based authentication
  storage_use_azuread = true
}

# Random string for unique storage account name
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Resource group for state storage
resource "azurerm_resource_group" "state" {
  name     = "rg-terraform-state"
  location = "East US"

  tags = {
    Environment = "Shared"
    Purpose     = "Terraform Remote State"
    ManagedBy   = "Terraform"
    Demo        = "02-Remote-State-Setup"
  }
}

# Storage account for Terraform state
resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.state.name
  location                 = azurerm_resource_group.state.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Security settings
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true # Required for Terraform backend access

  # Allow both key-based and Azure AD authentication
  # Set to false if Azure Policy blocks key-based auth in your subscription
  # In that case, use Azure AD authentication with backend config

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 7
    }
  }

  tags = {
    Environment = "Shared"
    Purpose     = "Terraform Remote State"
    ManagedBy   = "Terraform"
    Demo        = "02-Remote-State-Setup"
  }
}

# Container for state files
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}
