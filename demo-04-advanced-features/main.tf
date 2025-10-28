# Demo 4: Advanced Terraform Features
# Demonstrates locals, outputs, tfvars, and workspace management
# NOTE: 
#   - Terraform/provider versions defined in versions.tf
#   - Local values defined in locals.tf
#   - Variables defined in variables.tf
#   - This follows Terraform best practices for file organization

# Random suffix for unique naming
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${local.resource_prefix}-rg"
  location = var.location
  tags     = local.common_tags
}

# Storage Account with computed name
resource "azurerm_storage_account" "main" {
  name                     = lower("${var.project_name}${var.environment}sa${random_string.suffix.result}")
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = var.storage_account_tier
  account_replication_type = local.storage_replication # From locals.tf - GRS for prod, LRS for non-prod

  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = local.common_tags
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${local.resource_prefix}-vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.vnet_address_space]

  tags = local.common_tags
}

# Dynamic subnet creation using locals
resource "azurerm_subnet" "subnets" {
  for_each = local.subnets

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [each.value.address_prefix]
}

# Conditional resource - only in production
resource "azurerm_log_analytics_workspace" "main" {
  count = var.environment == "prod" ? 1 : 0

  name                = "${local.resource_prefix}-law"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = local.log_retention_days # From locals.tf

  tags = local.common_tags
}
