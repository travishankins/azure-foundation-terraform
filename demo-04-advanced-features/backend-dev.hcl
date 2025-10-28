# Backend configuration for different environments
# Use different state files for each environment

# For Dev environment
# terraform init -backend-config=backend-dev.hcl

resource_group_name  = "rg-terraform-state"
storage_account_name = "tfstatepb4p68"
container_name       = "tfstate"
key                  = "demo-04-dev.tfstate"
use_azuread_auth     = true  # Required when subscription policies block key-based auth
