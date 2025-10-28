# Backend configuration file for Demo 5
# From Demo 2 outputs

resource_group_name  = "rg-terraform-state"
storage_account_name = "tfstatebd7ovu"
container_name       = "tfstate"
key                  = "demo05-modules.tfstate"
use_azuread_auth     = true  # Required when subscription policies block key-based auth
