# Demo 5: Using Custom Modules
# Demonstrates how to use your own reusable Terraform modules

terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstateXXXXXX" # Replace with your storage account
    container_name       = "tfstate"
    key                  = "demo05-modules.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  
  # Use Azure AD for storage backend authentication
  storage_use_azuread = true
}

# Using the Resource Group module
module "resource_group" {
  source = "../modules/foundation/resource-group"

  name     = "rg-demo-05-modules"
  location = var.location

  tags = {
    Environment = "Demo"
    ManagedBy   = "Terraform"
    Demo        = "05-Custom-Modules"
    CreatedBy   = "Module"
  }
}

# Using the Virtual Network module
module "virtual_network" {
  source = "../modules/networking/virtual-network"

  resource_group_name     = module.resource_group.name
  resource_instance_count = "01"
  environment             = "demo"
  location                = var.location
  solution_name           = "demo05"

  # VNet configuration
  address_space = ["10.50.0.0/16"]
  dns_servers   = ["168.63.129.16"] # Azure DNS

  # Subnets
  subnets = [
    {
      name             = "subnet-web"
      address_prefixes = ["10.50.1.0/24"]
    },
    {
      name             = "subnet-app"
      address_prefixes = ["10.50.2.0/24"]
    },
    {
      name             = "subnet-data"
      address_prefixes = ["10.50.3.0/24"]
    }
  ]

  # Network Security Groups
  network_security_groups = [
    {
      name = "nsg-web"
      security_rules = [
        {
          name                       = "Allow-HTTP"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "80"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        {
          name                       = "Allow-HTTPS"
          priority                   = 110
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      ]
    }
  ]

  # Subnet-NSG associations
  subnet_nsg_association = [
    {
      association_name = "web-nsg-association"
      subnet_name      = "subnet-web"
      nsg_name         = "nsg-web"
    }
  ]

  tags = {
    Environment = "Demo"
    ManagedBy   = "Terraform"
    Demo        = "05-Custom-Modules"
  }

  depends_on = [module.resource_group]
}

# Using the Key Vault module
module "key_vault" {
  source = "../modules/security/key-vault"

  resource_group_name     = module.resource_group.name
  resource_instance_count = "01"
  environment             = "demo"
  location                = var.location
  solution_name           = "demo05"

  sku_name                        = "standard"
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  enable_rbac_authorization       = false
  soft_delete_retention_days      = 7

  tags = {
    Environment = "Demo"
    ManagedBy   = "Terraform"
    Demo        = "05-Custom-Modules"
  }

  depends_on = [module.resource_group]
}

# Using the Storage Account module
module "storage_account" {
  source = "../modules/storage/storage-account"

  resource_group_name     = module.resource_group.name
  resource_instance_count = "01"
  environment             = "demo"
  location                = var.location
  solution_name           = "demo05"
  resource_type_abbrv     = "st"

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"

  enable_https_traffic_only       = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = true
  shared_access_key_enabled       = true
  is_hns_enabled                  = true

  # Retention policies - values must be in allowed range
  blob_delete_retention_days             = 7
  container_delete_retention_policy_days = 7

  # Network rules
  network_rules_bypass = ["AzureServices"]

  tags = {
    Environment = "Demo"
    ManagedBy   = "Terraform"
    Demo        = "05-Custom-Modules"
  }

  depends_on = [module.resource_group]
}

# Using the Private DNS Zone module
module "private_dns_zone" {
  source = "../modules/networking/private-dns-zone"

  resource_group_name   = module.resource_group.name
  private_dns_zone_name = "privatelink.blob.core.windows.net"

  link_to_vnet = true
  vnet_id      = module.virtual_network.id
  vnet_name    = module.virtual_network.vnet_name

  tags = {
    Environment = "Demo"
    ManagedBy   = "Terraform"
    Demo        = "05-Custom-Modules"
  }

  depends_on = [module.virtual_network]
}
