locals {
  namespace = "${var.resource_type_abbrv}-${var.name}"
}

# Use this data source to access the configuration of the azurerm provider
data "azurerm_client_config" "current" {}

data "azurerm_monitor_diagnostic_categories" "main" {
  count = local.enabled ? 1 : 0

  resource_id = var.target_resource_id
}

resource "azurerm_monitor_diagnostic_setting" "main" {
  count = local.enabled ? 1 : 0

  name               = local.namespace
  target_resource_id = var.target_resource_id

  storage_account_id             = local.storage_id
  log_analytics_workspace_id     = local.log_analytics_id
  log_analytics_destination_type = local.log_analytics_destination_type
  eventhub_authorization_rule_id = local.eventhub_authorization_rule_id
  eventhub_name                  = local.eventhub_name

  dynamic "enabled_log" {
    for_each = local.logs

    content {
      category = enabled_log.key
    }
  }

  dynamic "metric" {
    for_each = local.metrics

    content {
      category = metric.key
      enabled  = metric.value.enabled
    }
  }

  lifecycle {
    ignore_changes = [log_analytics_destination_type]
  }
}