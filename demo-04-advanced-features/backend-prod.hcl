# Backend configuration for Production environment
# terraform init -backend-config=backend-prod.hcl

resource_group_name  = "rg-terraform-state"
storage_account_name = "tfstatepb4p68"
container_name       = "tfstate"
key                  = "demo-04-prod.tfstate"
use_azuread_auth     = true  # Required when subscription policies block key-based auth
