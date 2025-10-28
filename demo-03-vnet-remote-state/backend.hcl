# Backend configuration file
# REPLACE these values with outputs from Demo 2

resource_group_name  = "rg-terraform-state"
storage_account_name = "tfstatepb4p68"  # From Demo 2 output
container_name       = "tfstate"
key                  = "demo03-vnet.tfstate"
use_azuread_auth     = true  # Required when subscription policies block key-based auth
