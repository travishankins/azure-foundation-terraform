# Terraform and Provider Versions

terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # Remote state backend - configure with backend.hcl when ready
  # Uncomment and use: terraform init -backend-config=backend.hcl
  # backend "azurerm" {
  #   resource_group_name  = "rg-terraform-state"
  #   storage_account_name = "tfstateXXXXXX"
  #   container_name       = "tfstate"
  #   key                  = "demo03b-vnet-tfvars.tfstate"
  # }
}

provider "azurerm" {
  features {}
  
  # Use Azure AD for storage backend authentication
  storage_use_azuread = true
}
