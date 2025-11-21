# Backend configuration for Demo 7
# Use with: terraform init -backend-config=backend.hcl
# Don't commit this file with real values - use .gitignore

resource_group_name  = "rg-terraform-state"
storage_account_name = "tfstatepb4p68"  # Replace with your storage account from demo-02
container_name       = "tfstate"
key                  = "demo07-avm-custom.tfstate"
