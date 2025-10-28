# Local values for Demo 4
# Separating locals into their own file is a best practice for organization

locals {
  # Common naming convention
  resource_prefix = "${var.project_name}-${var.environment}"

  # Common tags that will be applied to all resources
  common_tags = merge(
    var.tags,
    {
      ManagedBy   = "Terraform"
      Environment = var.environment
      Project     = var.project_name
      Demo        = "04-Advanced-Features"
      DeployedAt  = timestamp()
    }
  )

  # Environment-specific configurations
  # This allows different sizing, features, etc. per environment
  environment_config = {
    dev = {
      vm_size        = "Standard_B2s"
      instance_count = 1
      enable_backup  = false
      storage_tier   = "Standard"
    }
    uat = {
      vm_size        = "Standard_D2s_v3"
      instance_count = 2
      enable_backup  = true
      storage_tier   = "Standard"
    }
    prod = {
      vm_size        = "Standard_D4s_v3"
      instance_count = 3
      enable_backup  = true
      storage_tier   = "Premium"
    }
  }

  # Get current environment configuration
  current_config = local.environment_config[var.environment]

  # Dynamic subnet configuration using for expression
  # This calculates subnet CIDR blocks automatically
  subnets = {
    for idx, subnet in var.subnet_names : subnet => {
      name           = "${local.resource_prefix}-${subnet}"
      address_prefix = cidrsubnet(var.vnet_address_space, 8, idx)
    }
  }

  # Computed resource names following naming conventions
  resource_names = {
    resource_group = "${local.resource_prefix}-rg"
    vnet           = "${local.resource_prefix}-vnet"
    log_analytics  = "${local.resource_prefix}-law"
  }

  # Conditional values based on environment
  is_production = var.environment == "prod"
  is_nonprod    = contains(["dev", "uat"], var.environment)

  # Replication type based on environment
  storage_replication = local.is_production ? "GRS" : "LRS"

  # Retention days based on environment
  log_retention_days = local.is_production ? 90 : 30
}
