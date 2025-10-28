locals {
  namespace = "${var.solution_name}-${var.resource_type_abbrv}-${var.environment}-${var.resource_instance_count}"
}

# Use this data source to access the configuration of the azurerm provider
data "azurerm_client_config" "current" {}

resource "azurerm_log_analytics_workspace" "main" {
  # Required Attributes
  name                = local.namespace
  location            = var.location
  resource_group_name = var.resource_group_name

  # Optional Attributes
  sku                                = var.sku
  allow_resource_only_permissions    = var.allow_resource_only_permissions
  cmk_for_query_forced               = var.cmk_for_query_forced
  daily_quota_gb                     = var.daily_quota_gb
  internet_ingestion_enabled         = var.internet_ingestion_enabled
  internet_query_enabled             = var.internet_query_enabled
  local_authentication_disabled      = var.local_authentication_disabled
  retention_in_days                  = strcontains(var.environment, "prod") ? 90 : var.retention_in_days
  reservation_capacity_in_gb_per_day = var.sku == "CapacityReservation" ? var.reservation_capacity_in_gb_per_day : null

  tags = var.tags
}