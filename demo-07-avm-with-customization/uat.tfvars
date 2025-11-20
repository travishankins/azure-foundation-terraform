# UAT Environment Configuration
# Use with: terraform plan -var-file=uat.tfvars

organization_prefix = "demo07"
environment         = "uat"
location            = "East US"

tags = {
  Project     = "AVM-Demo"
  CostCenter  = "IT-Testing"
  Owner       = "QA-Team"
  Environment = "UAT"
}

# Key Vault Configuration
key_vault_sku         = "standard"
key_vault_allowed_ips = []

# Storage Configuration
storage_shared_key_enabled = true
storage_allowed_ips        = []

# Monitoring
enable_monitoring = true
