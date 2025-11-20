# Local values for naming, tagging, and environment-specific configurations

locals {
  # Random suffix for globally unique resource names
  suffix = random_string.suffix.result

  # Base naming components
  prefix      = var.organization_prefix
  environment = var.environment
  location    = var.location

  # Standard naming convention: {prefix}-{resource-type}-{environment}-{suffix}
  resource_group_name  = "${local.prefix}-rg-${local.environment}-${local.suffix}"
  vnet_name            = "${local.prefix}-vnet-${local.environment}-${local.suffix}"
  virtual_network_name = "${local.prefix}-vnet-${local.environment}-${local.suffix}"
  log_analytics_name   = "${local.prefix}-law-${local.environment}-${local.suffix}"

  # Network configuration
  vnet_address_space = ["10.70.0.0/16"]
  subnets = {
    web = {
      name             = "subnet-web"
      address_prefixes = ["10.70.1.0/24"]
    }
    app = {
      name             = "subnet-app"
      address_prefixes = ["10.70.2.0/24"]
    }
    data = {
      name             = "subnet-data"
      address_prefixes = ["10.70.3.0/24"]
    }
  }

  # Key Vault name (max 24 chars, alphanumeric and hyphens only, must start with letter)
  # Remove hyphens and truncate to meet constraints
  key_vault_name = lower(substr(
    replace("${local.prefix}kv${local.environment}${local.suffix}", "-", ""),
    0,
    24
  ))

  # Storage Account name (3-24 chars, lowercase and numbers only)
  storage_account_name = lower(substr(
    replace("${local.prefix}st${local.environment}${local.suffix}", "-", ""),
    0,
    24
  ))

  # Container names for storage account
  container_names = {
    data    = "data"
    logs    = "logs"
    backups = "backups"
  }

  # Merged tags with defaults
  common_tags = merge(
    var.tags,
    {
      Environment    = var.environment
      ManagedBy      = "Terraform"
      DeploymentDate = timestamp()
      Demo           = "07-AVM-With-Customization"
    }
  )

  # Environment-specific configurations
  environment_config = {
    dev = {
      storage_replication      = "LRS"
      kv_network_access        = "Allow"
      storage_network_access   = "Allow"
      blob_retention_days      = 7
      container_retention_days = 7
      log_retention_days       = 30
      enable_change_feed       = false
      allowed_ips              = []
    }
    uat = {
      storage_replication      = "GRS"
      kv_network_access        = "Deny"
      storage_network_access   = "Deny"
      blob_retention_days      = 14
      container_retention_days = 14
      log_retention_days       = 60
      enable_change_feed       = false
      allowed_ips              = var.key_vault_allowed_ips
    }
    prod = {
      storage_replication      = "GRS"
      kv_network_access        = "Deny"
      storage_network_access   = "Deny"
      blob_retention_days      = 30
      container_retention_days = 30
      log_retention_days       = 90
      enable_change_feed       = true
      allowed_ips              = var.key_vault_allowed_ips
    }
  }

  # Current environment configuration
  current_config = local.environment_config[var.environment]

  # Naming convention documentation
  naming_convention = {
    pattern     = "{org-prefix}-{resource-type}-{environment}-{random-suffix}"
    example     = "${local.prefix}-vnet-${local.environment}-${local.suffix}"
    key_vault   = "alphanumeric only, max 24 chars"
    storage     = "lowercase alphanumeric only, max 24 chars"
    explanation = "Consistent naming across all resources with Azure naming constraints handled automatically"
  }
}
