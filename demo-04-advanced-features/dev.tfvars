# Development Environment Configuration
project_name = "demo04"
environment  = "dev"
location     = "East US"

vnet_address_space = "10.10.0.0/16"
subnet_names       = ["web", "app"]

tags = {
  CostCenter = "Engineering"
  Owner      = "DevTeam"
}
