resource "azurerm_private_dns_zone" "main" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Sleep is needed to wait for role assignment to propagate
resource "time_sleep" "dns_zone_vnet_link_sleep" {
  create_duration = "60s"

  depends_on = [azurerm_private_dns_zone.main]
}

# private dns zone vnet link
resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  count = var.link_to_vnet == true ? 1 : 0

  name                  = "${var.private_dns_zone_name}-${var.vnet_name}-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = var.private_dns_zone_name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false

  depends_on = [time_sleep.dns_zone_vnet_link_sleep]
}
