provider "azurerm" {
  subscription_id = var.subscription_id # Optional: uses Azure CLI context if null
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

# Provider for random string generator used for resource naming convention
provider "random" {}

# Data source to access the configuration of the azurerm provider
data "azurerm_client_config" "current" {}

# Create the resource group
resource "azurerm_resource_group" "rg_shard" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

resource "time_sleep" "wait_for_rg" {
  create_duration = "60s"
  depends_on      = [azurerm_resource_group.rg_shard]
}

# Virtual network module
module "vnet" {
  source = "../modules/networking/virtual-network"

  resource_group_name     = var.resource_group_name
  resource_instance_count = "01"
  environment             = var.environment
  location                = var.location
  solution_name           = var.solution_name
  depends_on              = [azurerm_resource_group.rg_shard]


  # vnet
  address_space = var.vnet_address_space
  dns_servers   = ["10.1.1.10", "10.1.0.67"]

  # subnets
  subnets = var.subnets

  # nsgs and nsg rules
  # NOTE: module appends "-nsg" to the end of nsg name.
  network_security_groups = var.nsgs_and_nsg_rules

  # Subnet and NSG association
  subnet_nsg_association = var.subnet_nsg_association

  tags = var.tags
}

# Key vault module
module "key-vault" {
  source = "../modules/security/key-vault"

  resource_group_name     = var.resource_group_name
  resource_instance_count = "01"
  environment             = var.environment
  location                = var.location
  solution_name           = var.solution_name

  sku_name                        = var.key_vault_sku
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  enable_rbac_authorization       = false
  soft_delete_retention_days      = 7

  tags = var.tags
}

# Private DNS zone for Storage Accounts
module "adls-private-dns-zone" {
  source = "../modules/networking/private-dns-zone"

  resource_group_name   = var.resource_group_name
  private_dns_zone_name = "privatelink.dfs.core.windows.net"

  link_to_vnet = true
  vnet_id      = module.vnet.id
  vnet_name    = module.vnet.vnet_name

  tags = var.tags

  depends_on = [module.vnet]
}

module "kv-private-dns-zone" {
  source = "../modules/networking/private-dns-zone"

  resource_group_name   = var.resource_group_name
  private_dns_zone_name = "privatelink.blob.core.windows.net"

  link_to_vnet = true
  vnet_id      = module.vnet.id
  vnet_name    = module.vnet.vnet_name

  tags = var.tags

  depends_on = [module.vnet]
}

# Log analytics workpace
module "log-analytics-workspace" {
  source = "../modules/monitoring/log-analytics-workspace"

  resource_group_name     = var.resource_group_name
  resource_instance_count = "01"
  environment             = var.environment
  location                = var.location
  solution_name           = var.solution_name

  tags = var.tags
}

#######################
####### LOGGING #######
#######################

module "kv_diagnostic_setting" {
  source = "../modules/monitoring/diagnostic-settings"

  resource_group_name = var.resource_group_name
  location            = var.location
  environment         = var.environment
  name                = "kvlogs"


  target_resource_id             = module.key-vault.id
  log_analytics_destination_type = "Dedicated"
  logs_destinations_ids          = [module.log-analytics-workspace.id]
}

module "vnet_diagnostic_setting" {
  source = "../modules/monitoring/diagnostic-settings"

  resource_group_name = var.resource_group_name
  location            = var.location
  environment         = var.environment
  name                = "vnetlogs"


  target_resource_id             = module.vnet.id
  log_analytics_destination_type = "Dedicated"
  logs_destinations_ids          = [module.log-analytics-workspace.id]
}