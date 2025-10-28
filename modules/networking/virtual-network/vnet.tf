
# Use this data source to access the configuration of the azurerm provider
data "azurerm_client_config" "current" {}

# Vnet resource
resource "azurerm_virtual_network" "main" {
  name                = local.namespace
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  dns_servers         = var.dns_servers

  # blocks
  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan == null ? [] : ["enabled"]

    content {
      id     = var.ddos_protection_plan.id
      enable = var.ddos_protection_plan.enable
    }
  }

  dynamic "encryption" {
    for_each = var.encryption == null ? [] : ["enabled"]

    content {
      enforcement = var.encryption.enforcement
    }
  }

  tags = var.tags
}

# Vnet peering
# Note: this block only supports completd vnet peering for vnets created by the module. To complete peering for already existing vnets, go to the vnet being peered to and complete peering there.
# If this module it being used to create both vnets that will be peered together, then this resource block will support vnet peering on both ends.
resource "azurerm_virtual_network_peering" "main" {
  for_each = { for peer in var.vnet_peers : peer.name => peer }

  name                         = "${azurerm_virtual_network.main.name}-to-${element(split("/", each.value.remote_virtual_network_id), length(split("/", each.value.remote_virtual_network_id)) - 1)}-peering"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.main.name
  remote_virtual_network_id    = each.value.remote_virtual_network_id
  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit
  use_remote_gateways          = each.value.use_remote_gateways # must be set to false if using Global Virtual Network Peerings.
}
