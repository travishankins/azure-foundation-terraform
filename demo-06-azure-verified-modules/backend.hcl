# Backend configuration file for Demo 6
# From Demo 2 outputs

resource_group_name  = "rg-terraform-state"
storage_account_name = "tfstatebd7ovu"
container_name       = "tfstate"
key                  = "demo06-avm.tfstate"
use_azuread_auth     = true  # Required when subscription policies block key-based auth
