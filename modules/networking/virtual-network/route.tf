resource "azurerm_route_table" "main" {
  for_each = { for route_table in var.route_tables : route_table.name => route_table }

  name                = "rt-${each.key}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_route" "main" {
  for_each = { for rt in local.routes_per_route_table : format("%s.%s", rt.route_table_name, rt.name) => rt }

  name                   = each.value.name
  resource_group_name    = var.resource_group_name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address
  route_table_name       = azurerm_route_table.main[each.value.route_table_name].name
}

resource "azurerm_subnet_route_table_association" "main" {
  for_each = { for assoc in var.subnet_rt_association : assoc.association_name => assoc }

  subnet_id      = azurerm_subnet.main[each.value.subnet_name].id
  route_table_id = azurerm_route_table.main[each.value.route_table_name].id

  depends_on = [azurerm_route_table.main]
}