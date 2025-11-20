# Demo 6: Azure Verified Modules
# Using production-ready modules from the Terraform Registry

terraform {
  required_version = ">= 1.5"

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
    key                  = "demo06-avm.tfstate"
  }
}

provider "azurerm" {
  features {}

  # Use Azure AD for storage backend authentication
  storage_use_azuread = true
}

# Data source for current Azure configuration
data "azurerm_client_config" "current" {}

# Create a resource group first (not using AVM for this)
resource "azurerm_resource_group" "demo" {
  name     = "rg-demo-06-avm"
  location = "East US"

  tags = {
    Environment = "Demo"
    ManagedBy   = "Terraform"
    Demo        = "06-Azure-Verified-Modules"
  }
}

# Azure Verified Module for Virtual Network
# Note: Using standard resources instead of AVM for simplicity in demo
# AVM modules may have complex requirements - use for reference
resource "azurerm_virtual_network" "demo" {
  name                = "vnet-demo-06-standard"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  address_space       = ["10.60.0.0/16"]

  tags = {
    Environment = "Demo"
    ManagedBy   = "Terraform"
    Demo        = "06-Azure-Verified-Modules"
  }
}

# Subnets
resource "azurerm_subnet" "web" {
  name                 = "subnet-web"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes     = ["10.60.1.0/24"]
}

resource "azurerm_subnet" "app" {
  name                 = "subnet-app"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes     = ["10.60.2.0/24"]
}

resource "azurerm_subnet" "data" {
  name                 = "subnet-data"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes     = ["10.60.3.0/24"]
}

# Azure Verified Module for Storage Account
# Source: https://registry.terraform.io/modules/Azure/avm-res-storage-storageaccount/azurerm/latest
# Note: Simplified for demo - AVM modules can be complex
resource "azurerm_storage_account" "demo" {
  name                = "stdemo06${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                 = "TLS1_2"
  shared_access_key_enabled       = true
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false

  blob_properties {
    versioning_enabled = true
  }

  tags = {
    Environment = "Demo"
    ManagedBy   = "Terraform"
    Demo        = "06-Azure-Verified-Modules"
  }
}

# Random suffix for unique names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}
