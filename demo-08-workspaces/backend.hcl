# Backend configuration for Demo 8
# Single backend, multiple workspaces

resource_group_name  = "rg-terraform-state"
storage_account_name = "tfstatepb4p68" # Replace with your storage account from demo-02
container_name       = "tfstate"
key                  = "demo08-workspaces.tfstate"
use_azuread_auth     = true

# Note: Workspaces are automatically handled by Terraform
# Actual state files will be:
# - env:/default/demo08-workspaces.tfstate
# - env:/dev/demo08-workspaces.tfstate
# - env:/uat/demo08-workspaces.tfstate
# - env:/prod/demo08-workspaces.tfstate
