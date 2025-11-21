# Demo 3: Virtual Network with Remote State
# This demonstrates using remote state backend for team collaboration

terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # Remote state backend - REPLACE VALUES FROM DEMO 2 OUTPUT
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state" # From demo 2
    storage_account_name = "tfstatepb4p68"      # From demo 2 - replace XXXXXX
    container_name       = "tfstate"
    key                  = "demo03-vnet.tfstate" # Unique key for this deployment
  }
}

provider "azurerm" {
  features {}

  # Use Azure AD for storage backend authentication
  storage_use_azuread = true
}

# Resource group for VNet
resource "azurerm_resource_group" "vnet" {
  name     = "rg-demo-03-app2"
  location = "West Central US"

  tags = {
    Environment = "Demo"
    ManagedBy   = "Terraform"
    Demo        = "03-VNet-Remote-State"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "vnet-demo-03"
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    Environment = "Demo"
    ManagedBy   = "Terraform"
    Demo        = "03-VNet-Remote-State"
  }
}

# Subnets
resource "azurerm_subnet" "subnet1" {
  name                 = "subnet-web"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet-app"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "subnet3" {
  name                 = "subnet-data"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.10.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "web" {
  name                = "nsg-web"
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = "Demo"
    ManagedBy   = "Terraform"
    Demo        = "03-VNet-Remote-State"
  }
}

# Associate NSG with subnet
resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.web.id
}
