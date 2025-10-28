# Demo 3B: Virtual Network with tfvars
# This demonstrates using variable files instead of hardcoded values
# Compare this to demo-03 to see the difference!

# Resource group for VNet
resource "azurerm_resource_group" "vnet" {
  name     = var.resource_group_name
  location = var.location

  tags = merge(var.tags, {
    Environment = var.environment
    Demo        = "03B-VNet-With-Tfvars"
  })
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name
  address_space       = var.vnet_address_space

  tags = merge(var.tags, {
    Environment = var.environment
    Demo        = "03B-VNet-With-Tfvars"
  })
}

# Subnets - created dynamically from variable
resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = each.value.address_prefixes
}

# Network Security Group
resource "azurerm_network_security_group" "main" {
  name                = var.nsg_name
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }

  tags = merge(var.tags, {
    Environment = var.environment
    Demo        = "03B-VNet-With-Tfvars"
  })
}

# Associate NSG with web subnet
resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.subnets["web"].id
  network_security_group_id = azurerm_network_security_group.main.id
}
