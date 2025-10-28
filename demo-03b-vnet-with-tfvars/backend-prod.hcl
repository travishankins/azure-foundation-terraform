# Backend configuration file for Demo 3B
# From Demo 2 outputs

resource_group_name  = "rg-terraform-state"
storage_account_name = "tfstatepb4p68"
container_name       = "tfstate"
key                  = "demo03b-vnet-prod-tfvars.tfstate"
use_azuread_auth     = true  # Required when subscription policies block key-based auth
