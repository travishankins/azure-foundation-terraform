# UAT Environment Configuration
project_name = "demo04"
environment  = "uat"
location     = "East US"

vnet_address_space = "10.20.0.0/16"
subnet_names       = ["web", "app", "data"]

tags = {
  CostCenter = "Engineering"
  Owner      = "QATeam"
}
