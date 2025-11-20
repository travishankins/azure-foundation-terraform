# Production Environment Configuration
# Use with: terraform plan -var-file=prod.tfvars

resource_group_name = "rg-demo-03b-vnet-prod"
location            = "East US"
environment         = "prod"

vnet_name          = "vnet-demo-03b-prod"
vnet_address_space = ["10.10.0.0/16"]

# Subnets configuration - More subnets for production
subnets = {
  web = {
    name             = "subnet-web"
    address_prefixes = ["10.10.1.0/24"]
  }
  app = {
    name             = "subnet-app"
    address_prefixes = ["10.10.2.0/24"]
  }
  data = {
    name             = "subnet-data"
    address_prefixes = ["10.10.3.0/24"]
  }
  mgmt = {
    name             = "subnet-management"
    address_prefixes = ["10.10.4.0/24"]
  }
  gateway = {
    name             = "GatewaySubnet"
    address_prefixes = ["10.10.255.0/24"]
  }
}

nsg_name = "nsg-web-prod"

# NSG Rules - Stricter rules for production (HTTPS only)
nsg_rules = [
  {
    name                       = "Allow-HTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "Deny-HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]

tags = {
  ManagedBy  = "Terraform"
  Project    = "Demo"
  CostCenter = "IT-Production"
  Compliance = "Required"
}
