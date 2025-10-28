# Terraform and Provider Versions
# Following best practice of separating version requirements

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

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstateXXXXXX" # Replace with your storage account
    container_name       = "tfstate"
    key                  = "demo04.tfstate"
  }
}

provider "azurerm" {
  features {}

  # Use Azure AD for storage backend authentication
  storage_use_azuread = true
}
