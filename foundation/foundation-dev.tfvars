environment = "dev"
# subscription_id     = "00000000-0000-0000-0000-000000000000"  # Optional: Uncomment for multi-subscription
resource_group_name = "rg-shared-dev-01"
location            = "Central US"
tags = {
  "Environment"  = "Development"
  "WorkloadName" = "Enterprise Platform"
  "SolutionName" = "Shared Infrastructure"
  "Region"       = "Central US"
  "Owner"        = "Platform Team"
  "IAC"          = "Terraform"
  "CostCenter"   = "IT"
}

# vnet variables
vnet_address_space = ["10.160.0.0/24"]
subnets = [
  {
    subnet_name                               = "pe-subnet"
    private_endpoint_network_policies_enabled = "Enabled"
    address_prefixes                          = ["10.160.0.128/27"]
    service_endpoints                         = ["Microsoft.Storage.Global"]
  },
  {
    subnet_name                               = "app-subnet"
    private_endpoint_network_policies_enabled = "Enabled"
    address_prefixes                          = ["10.160.0.160/27"]
    service_endpoints                         = ["Microsoft.Storage.Global", "Microsoft.KeyVault"]
  }
]

nsgs_and_nsg_rules = [
  {
    name                   = "pe-subnet-nsg"
    network_security_rules = []
  },
  {
    name = "app-subnet-nsg"
    network_security_rules = [
      {
        name                       = "allow-https-inbound"
        priority                   = 100
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "VirtualNetwork"
        direction                  = "Inbound"
        protocol                   = "Tcp"
        access                     = "Allow"
      }
    ]
  }
]

subnet_nsg_association = [
  {
    association_name = "pe-subnet-nsg-assoc"
    subnet_name      = "pe-subnet"
    nsg_name         = "pe-subnet-nsg"
  },
  {
    association_name = "app-subnet-nsg-assoc"
    subnet_name      = "app-subnet"
    nsg_name         = "app-subnet-nsg"
  }
]

# key vault variables
key_vault_sku = "standard"
