locals {
  namespace = "${var.solution_name}-${var.resource_type_abbrv}-${var.environment}-${var.resource_instance_count}"

}

locals {

  # produces a list of vne peering IDs
  peering_ids = [
    for peers in var.vnet_peers : azurerm_virtual_network_peering.main[peers.name].id
  ]

  # produces a map of subnet name with an object as the value. the object consists of the subnet ID as a key and the subnet address space as the value.
  subnet_outputs = {
    for subnet in var.subnets : subnet.subnet_name => zipmap(azurerm_subnet.main[*][subnet.subnet_name].id, azurerm_subnet.main[*][subnet.subnet_name].address_prefixes)
  }

  # merges a nested list of objects into one list of objects used to provide values to the security group and security network rules resource blocks.
  nsg_rules_per_nsg = flatten([
    for nsg in var.network_security_groups : [
      for nsg_rule in nsg.network_security_rules : merge({ nsg_name = nsg.name }, nsg_rule)
    ]
  ])

  # merges a nested list of objects into one list of objects used to provide values to the route table and routes resource blocks.
  routes_per_route_table = flatten([
    for route_table in var.route_tables : [
      for route in route_table.routes : merge({ route_table_name = route_table.name }, route)
    ]
  ])

}