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

}

provider "azurerm" {
  features {}

  # Use Azure AD for storage backend authentication
  storage_use_azuread = true
}
