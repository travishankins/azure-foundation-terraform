# Development Environment Configuration
# Use with: terraform plan -var-file=dev.tfvars

resource_group_name = "rg-demo-03b-vnet-dev"
location            = "East US"
environment         = "dev"

vnet_name          = "vnet-demo-03b-dev"
vnet_address_space = ["10.0.0.0/16"]

# Subnets configuration
subnets = {
  web = {
    name             = "subnet-web"
    address_prefixes = ["10.0.1.0/24"]
  }
  app = {
    name             = "subnet-app"
    address_prefixes = ["10.0.2.0/24"]
  }
  data = {
    name             = "subnet-data"
    address_prefixes = ["10.0.3.0/24"]
  }
}

vnet_name          = "vnet-demo-04b-dev"
vnet_address_space = ["10.0.0.0/16"]

# Subnets configuration
subnets = {
  web = {
    name             = "subnet-web"
    address_prefixes = ["10.0.1.0/24"]
  }
  app = {
    name             = "subnet-app"
    address_prefixes = ["10.0.2.0/24"]
  }
  data = {
    name             = "subnet-data"
    address_prefixes = ["10.0.3.0/24"]
  }
}


nsg_name = "nsg-web-dev"

# NSG Rules - Allow HTTP and HTTPS for dev
nsg_rules = [
  {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "Allow-HTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "Allow-SSH"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]

tags = {
  ManagedBy   = "Terraform"
  Project     = "Demo"
  CostCenter  = "IT-Development"
}
