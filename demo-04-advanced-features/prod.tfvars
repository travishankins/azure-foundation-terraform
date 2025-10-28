# Production Environment Configuration
project_name = "demo04"
environment  = "prod"
location     = "East US"

vnet_address_space = "10.30.0.0/16"
subnet_names       = ["web", "app", "data", "mgmt"]

storage_account_tier = "Standard"

tags = {
  CostCenter = "Production"
  Owner      = "OpsTeam"
  Compliance = "Required"
}
