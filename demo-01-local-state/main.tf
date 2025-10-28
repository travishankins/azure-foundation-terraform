# Demo 1: Resource Group with Local State
# This demonstrates the most basic Terraform deployment using local state file

terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Simple resource group creation
resource "azurerm_resource_group" "demo" {
  name     = "rg-demo-01-local-state"
  location = "East US"

  tags = {
    Environment = "Demo"
    ManagedBy   = "Terraform"
    Demo        = "01-Local-State"
  }
}
