resource "azurerm_subnet" "main" {
  for_each = { for subnet in var.subnets : subnet.subnet_name => subnet }

  name                              = each.value.subnet_name
  resource_group_name               = var.resource_group_name
  virtual_network_name              = azurerm_virtual_network.main.name
  private_endpoint_network_policies = each.value.private_endpoint_network_policies_enabled
  address_prefixes                  = each.value.address_prefixes

  service_endpoints = each.value.service_endpoints

  dynamic "delegation" {
    for_each = each.value.delegation == null ? [] : ["enabled"]

    content {
      name = each.value.delegation.name
      service_delegation {
        name    = each.value.delegation.service_delegation.service_name
        actions = each.value.delegation.service_delegation.actions
      }
    }
  }
}

resource "azurerm_network_security_group" "main" {
  for_each = { for nsg in var.network_security_groups : nsg.name => nsg }

  name                = "${each.key}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "main" {
  for_each = { for security_rule in local.nsg_rules_per_nsg : format("%s.%s", security_rule.nsg_name, security_rule.name) => security_rule }

  name                         = each.value.name
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_port_range            = each.value.source_port_range
  source_port_ranges           = each.value.source_port_ranges
  destination_port_range       = each.value.destination_port_range
  destination_port_ranges      = each.value.destination_port_ranges
  source_address_prefix        = each.value.source_address_prefix
  source_address_prefixes      = each.value.source_address_prefixes
  destination_address_prefix   = each.value.destination_address_prefix
  destination_address_prefixes = each.value.destination_address_prefixes
  resource_group_name          = var.resource_group_name
  network_security_group_name  = azurerm_network_security_group.main[each.value.nsg_name].name
}

resource "azurerm_subnet_network_security_group_association" "main" {
  for_each = { for assoc in var.subnet_nsg_association : assoc.association_name => assoc }

  subnet_id                 = azurerm_subnet.main[each.value.subnet_name].id
  network_security_group_id = azurerm_network_security_group.main[each.value.nsg_name].id

  depends_on = [azurerm_network_security_group.main]
}