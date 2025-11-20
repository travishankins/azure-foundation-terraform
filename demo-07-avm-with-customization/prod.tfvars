# Production Environment Configuration
# Use with: terraform plan -var-file=prod.tfvars

organization_prefix = "demo07"
environment         = "prod"
location            = "East US"

tags = {
  Project     = "AVM-Demo"
  CostCenter  = "IT-Production"
  Owner       = "Platform-Team"
  Environment = "Production"
  Compliance  = "Required"
}

# Key Vault Configuration
key_vault_sku = "premium" # Premium SKU for production
key_vault_allowed_ips = [
  # Add your allowed IPs here for production
  # "1.2.3.4",
  # "5.6.7.8"
]

# Storage Configuration
storage_shared_key_enabled = true
storage_allowed_ips = [
  # Add your allowed IPs here for production
  # "1.2.3.4",
  # "5.6.7.8"
]

# Monitoring
enable_monitoring = true
