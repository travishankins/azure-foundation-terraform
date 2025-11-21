# Demo 8: Terraform Workspaces
# Demonstrates using Terraform workspaces for environment management
# Alternative to separate state files - all states in one backend with workspace isolation

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

  # Single backend configuration - workspaces handle environment separation
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstatepb4p68" # Replace with your storage account
    container_name       = "tfstate"
    key                  = "demo08-workspaces.tfstate" # Same key, different workspaces
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  storage_use_azuread = true
}

# Random suffix for unique naming per workspace
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Workspace-aware configuration using terraform.workspace
locals {
  # Current workspace name (default, dev, uat, prod)
  workspace = terraform.workspace

  # Workspace-specific configurations
  workspace_config = {
    default = {
      environment         = "dev"
      location            = "East US"
      vm_size             = "Standard_B2s"
      instance_count      = 1
      storage_replication = "LRS"
      enable_backups      = false
      address_space       = "10.10.0.0/16"
      enable_monitoring   = false
      sku_tier            = "Basic"
    }
    dev = {
      environment         = "dev"
      location            = "East US"
      vm_size             = "Standard_B2s"
      instance_count      = 1
      storage_replication = "LRS"
      enable_backups      = false
      address_space       = "10.10.0.0/16"
      enable_monitoring   = false
      sku_tier            = "Basic"
    }
    uat = {
      environment         = "uat"
      location            = "Central US"
      vm_size             = "Standard_D2s_v3"
      instance_count      = 2
      storage_replication = "GRS"
      enable_backups      = true
      address_space       = "10.20.0.0/16"
      enable_monitoring   = true
      sku_tier            = "Standard"
    }
    prod = {
      environment         = "prod"
      location            = "West US"
      vm_size             = "Standard_D4s_v3"
      instance_count      = 3
      storage_replication = "GRS"
      enable_backups      = true
      address_space       = "10.30.0.0/16"
      enable_monitoring   = true
      sku_tier            = "Premium"
    }
  }

  # Get current workspace configuration
  config = local.workspace_config[local.workspace]

  # Resource naming includes workspace
  prefix              = "demo08"
  resource_group_name = "${local.prefix}-rg-${local.workspace}-${random_string.suffix.result}"
  vnet_name           = "${local.prefix}-vnet-${local.workspace}-${random_string.suffix.result}"
  storage_name        = lower("${local.prefix}st${local.workspace}${random_string.suffix.result}")

  # Common tags
  common_tags = {
    Project          = "Demo-08-Workspaces"
    ManagedBy        = "Terraform"
    Workspace        = local.workspace
    Environment      = local.config.environment
    DeploymentMethod = "Workspace-Based"
  }
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = local.config.location

  tags = local.common_tags
}

# Virtual Network with workspace-specific address space
resource "azurerm_virtual_network" "main" {
  name                = local.vnet_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [local.config.address_space]

  tags = merge(
    local.common_tags,
    {
      AddressSpace = local.config.address_space
    }
  )
}

# Subnets - dynamically created based on workspace
resource "azurerm_subnet" "subnets" {
  for_each = {
    web  = cidrsubnet(local.config.address_space, 8, 1)
    app  = cidrsubnet(local.config.address_space, 8, 2)
    data = cidrsubnet(local.config.address_space, 8, 3)
  }

  name                 = "subnet-${each.key}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [each.value]
}

# Storage Account with workspace-specific configuration
resource "azurerm_storage_account" "main" {
  name                     = local.storage_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = local.config.storage_replication

  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = local.config.enable_backups ? 30 : 7
    }
  }

  tags = merge(
    local.common_tags,
    {
      Replication = local.config.storage_replication
      Backups     = local.config.enable_backups ? "Enabled" : "Disabled"
    }
  )
}

# Conditional resource - only in UAT and Prod workspaces
resource "azurerm_log_analytics_workspace" "main" {
  count = local.config.enable_monitoring ? 1 : 0

  name                = "${local.prefix}-law-${local.workspace}-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = local.workspace == "prod" ? 90 : 30

  tags = merge(
    local.common_tags,
    {
      RetentionDays = local.workspace == "prod" ? "90" : "30"
    }
  )
}

# Network Security Group
resource "azurerm_network_security_group" "web" {
  name                = "nsg-web-${local.workspace}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # More restrictive rules in production
  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # HTTP only allowed in dev/default
  dynamic "security_rule" {
    for_each = local.workspace == "prod" ? [] : [1]
    content {
      name                       = "Allow-HTTP"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  # SSH only in dev
  dynamic "security_rule" {
    for_each = local.workspace == "dev" || local.workspace == "default" ? [1] : []
    content {
      name                       = "Allow-SSH"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  tags = local.common_tags
}

# Associate NSG with web subnet
resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.subnets["web"].id
  network_security_group_id = azurerm_network_security_group.web.id
}
