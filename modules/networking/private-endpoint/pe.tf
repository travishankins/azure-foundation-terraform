locals {
  tenant_id       = data.azurerm_client_config.current.client_id
  subscription_id = data.azurerm_client_config.current.subscription_id
  namespace       = "${var.solution_name}-${var.resource_type_abbrv}-${var.attached_resource_abbrv}-${var.environment}-${var.resource_instance_count}"
  resource_alias  = length(regexall("^([a-z0-9\\-]+)\\.([a-z0-9\\-]+)\\.([a-z]+)\\.(azure)\\.(privatelinkservice)$", var.target_resource)) == 1 ? var.target_resource : null
  resource_id     = length(regexall("^\\/(subscriptions)\\/([a-z0-9\\-]+)\\/(resourceGroups)\\/([A-Za-z0-9\\-]+)\\/(providers)\\/([A-Za-z\\.]+)\\/([A-Za-z]+)\\/([A-Za-z0-9\\-]+)$", var.target_resource)) == 1 ? var.target_resource : null

}

data "azurerm_client_config" "current" {}

resource "azurerm_private_endpoint" "main" {
  name                = local.namespace
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  # This block is optional with no minimum number of items and no maximum number of items
  dynamic "ip_configuration" {
    for_each = var.ip_configurations

    content {
      name               = ip_configuration.value.name
      private_ip_address = ip_configuration.value.private_ip_address
      subresource_name   = ip_configuration.value.subresource_name
    }
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_group != null ? [var.private_dns_zone_group] : []

    content {
      name                 = private_dns_zone_group.value.name
      private_dns_zone_ids = private_dns_zone_group.value.private_dns_zone_ids
    }
  }

  private_service_connection {
    name                              = "${local.namespace}-psc"
    is_manual_connection              = var.is_manual_connection
    subresource_names                 = var.subresource_name
    private_connection_resource_alias = local.resource_alias
    private_connection_resource_id    = local.resource_id
    request_message                   = var.is_manual_connection == true ? var.request_message : null
  }

  tags = var.tags
}

resource "azurerm_private_dns_a_record" "main" {

  count = var.dns_zone_name == null ? 0 : 1

  name                = var.resource_name
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group_name
  ttl                 = 10
  records             = [azurerm_private_endpoint.main.private_service_connection[0].private_ip_address]

  tags = var.tags
}