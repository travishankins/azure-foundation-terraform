# Development Environment Configuration
# Use with: terraform plan -var-file=dev.tfvars

organization_prefix = "demo07"
environment         = "dev"
location            = "East US"

tags = {
  Project     = "AVM-Demo"
  CostCenter  = "IT-Engineering"
  Owner       = "Platform-Team"
  Environment = "Development"
}

# Key Vault Configuration
key_vault_sku         = "standard"
key_vault_allowed_ips = [] # Add IPs like ["1.2.3.4", "5.6.7.8"] if needed

# Storage Configuration
storage_shared_key_enabled = true
storage_allowed_ips        = []

# Monitoring
enable_monitoring = true
