locals {
  namespace = "${var.solution_name}-${var.resource_type_abbrv}-${random_string.random.result}-${var.environment}-${var.resource_instance_count}"
}

# Use this data source to access the configuration of the azurerm provider
data "azurerm_client_config" "current" {}


# random string generator for key vault name
resource "random_string" "random" {
  length    = 3
  special   = false
  min_lower = 3
}

resource "azurerm_key_vault" "main" {
  # Required Attributes
  name                = local.namespace
  resource_group_name = var.resource_group_name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.sku_name

  # Optional Attributes
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization
  purge_protection_enabled        = strcontains(var.environment, "prod") ? true : var.purge_protection_enabled
  public_network_access_enabled   = var.public_network_access_enabled
  soft_delete_retention_days      = strcontains(var.environment, "prod") ? 90 : var.soft_delete_retention_days

  # Blocks
  dynamic "network_acls" {
    for_each = var.network_acls == null ? [] : ["enabled"]

    content {
      bypass                     = var.network_acls.bypass
      default_action             = var.network_acls.default_action
      ip_rules                   = var.network_acls.ip_rules
      virtual_network_subnet_ids = var.network_acls.subnet_ids
    }
  }

  tags = var.tags
}