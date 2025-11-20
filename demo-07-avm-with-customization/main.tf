# Demo 7: Azure Verified Modules with Customization
# Demonstrates using real AVM modules from the Terraform Registry
# with custom naming conventions, tagging, and configuration

terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.37.0, < 5.0.0"
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
    key                  = "demo07-avm-custom.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  use_cli             = true
  storage_use_azuread = true
  subscription_id     = "25a273f5-bd71-4542-a5d8-495b25fd38d5"
}

# Data source for current Azure configuration
data "azurerm_client_config" "current" {}

# Random suffix for unique naming
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Create Resource Group (not using AVM for base resource)
resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = local.location
  tags     = local.common_tags
}

# AVM Module 1: Virtual Network
# Using standard resource instead of AVM due to API complexity
resource "azurerm_virtual_network" "main" {
  name                = local.virtual_network_name
  location            = local.location
  resource_group_name = azurerm_resource_group.main.name

  # Network configuration
  address_space = local.vnet_address_space

  # Custom tags
  tags = merge(
    local.common_tags,
    {
      ResourceType = "VirtualNetwork"
      Subnet_Count = length(local.subnets)
    }
  )

  depends_on = [azurerm_resource_group.main]
}

# Subnets created separately for better control
resource "azurerm_subnet" "subnets" {
  for_each = local.subnets

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = each.value.address_prefixes
}

# AVM Module 2: Key Vault
# Source: https://registry.terraform.io/modules/Azure/avm-res-keyvault-vault/azurerm/latest
module "key_vault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "~> 0.9"

  # Custom naming
  name                = local.key_vault_name
  resource_group_name = azurerm_resource_group.main.name
  location            = local.location

  # Tenant configuration
  tenant_id = data.azurerm_client_config.current.tenant_id

  # Key Vault settings
  sku_name                        = var.key_vault_sku
  soft_delete_retention_days      = 7
  purge_protection_enabled        = false # Set to true in production
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true

  # Use RBAC via role assignments (added separately if needed)
  public_network_access_enabled = var.environment == "prod" ? false : true

  # Network rules - customize based on environment
  network_acls = var.environment == "prod" ? {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = var.key_vault_allowed_ips
    virtual_network_subnet_ids = []
    } : {
    bypass                     = "AzureServices"
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  # Custom tags
  tags = merge(
    local.common_tags,
    {
      ResourceType = "KeyVault"
      Security     = "Enabled"
    }
  )

  depends_on = [azurerm_resource_group.main]
}

# AVM Module 3: Storage Account
# Source: https://registry.terraform.io/modules/Azure/avm-res-storage-storageaccount/azurerm/latest
module "storage_account" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "~> 0.2"

  # Custom naming
  name                = local.storage_account_name
  resource_group_name = azurerm_resource_group.main.name
  location            = local.location

  # Storage account settings with environment-based customization
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = var.environment == "prod" ? "GRS" : "LRS"
  access_tier              = "Hot"

  # Security settings
  shared_access_key_enabled     = var.storage_shared_key_enabled
  public_network_access_enabled = var.environment == "prod" ? false : true
  min_tls_version               = "TLS1_2"
  https_traffic_only_enabled    = true

  # Blob properties
  blob_properties = {
    versioning_enabled  = true
    change_feed_enabled = var.environment == "prod" ? true : false

    delete_retention_policy = {
      days = var.environment == "prod" ? 30 : 7
    }

    container_delete_retention_policy = {
      days = var.environment == "prod" ? 30 : 7
    }
  }

  # Network rules - more restrictive in production
  network_rules = var.environment == "prod" ? {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    ip_rules                   = var.storage_allowed_ips
    virtual_network_subnet_ids = []
  } : null

  # Containers with custom naming
  containers = {
    data = {
      name                  = "data-${local.environment}"
      container_access_type = "private"
    }
    logs = {
      name                  = "logs-${local.environment}"
      container_access_type = "private"
    }
    backups = {
      name                  = "backups-${local.environment}"
      container_access_type = "private"
    }
  }

  # Custom tags
  tags = merge(
    local.common_tags,
    {
      ResourceType       = "StorageAccount"
      DataClassification = "Internal"
      Replication        = var.environment == "prod" ? "GRS" : "LRS"
    }
  )

  depends_on = [azurerm_resource_group.main]
}

# AVM Module 4: Log Analytics Workspace
# Source: https://registry.terraform.io/modules/Azure/avm-res-operationalinsights-workspace/azurerm/latest
module "log_analytics" {
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "~> 0.3"

  # Custom naming
  name                = "${local.prefix}-law-${local.environment}-${local.suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = local.location

  # Workspace settings based on environment
  log_analytics_workspace_retention_in_days          = var.environment == "prod" ? 90 : 30
  log_analytics_workspace_daily_quota_gb             = var.environment == "prod" ? 10 : 1
  log_analytics_workspace_internet_ingestion_enabled = true
  log_analytics_workspace_internet_query_enabled     = true
  log_analytics_workspace_sku                        = "PerGB2018"

  # Custom tags
  tags = merge(
    local.common_tags,
    {
      ResourceType   = "LogAnalytics"
      RetentionDays  = var.environment == "prod" ? "90" : "30"
      MonitoringTier = var.environment == "prod" ? "Premium" : "Standard"
    }
  )

  depends_on = [azurerm_resource_group.main]
}

# Optional: Create diagnostic settings for Key Vault
resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  name                       = "diag-${local.key_vault_name}"
  target_resource_id         = module.key_vault.resource_id
  log_analytics_workspace_id = module.log_analytics.resource_id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  depends_on = [
    module.key_vault,
    module.log_analytics
  ]
}

# Optional: Create diagnostic settings for Storage Account
resource "azurerm_monitor_diagnostic_setting" "storage_account" {
  name                       = "diag-${local.storage_account_name}"
  target_resource_id         = module.storage_account.resource_id
  log_analytics_workspace_id = module.log_analytics.resource_id

  enabled_metric {
    category = "Transaction"
  }

  depends_on = [
    module.storage_account,
    module.log_analytics
  ]
}
