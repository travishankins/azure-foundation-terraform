# Backend configuration for UAT environment
# terraform init -backend-config=backend-uat.hcl

resource_group_name  = "rg-terraform-state"
storage_account_name = "tfstatepb4p68"
container_name       = "tfstate"
key                  = "demo-04-uat.tfstate"
use_azuread_auth     = true  # Required when subscription policies block key-based auth
