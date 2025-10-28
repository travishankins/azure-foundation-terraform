# Resource Group Module

This module creates an Azure Resource Group with consistent naming, tagging, and validation.

## Features

- ✅ Azure region validation
- ✅ Resource group name validation (Azure naming rules)
- ✅ Consistent tagging strategy
- ✅ Optional managed_by configuration
- ✅ Lifecycle management options

## Usage

### Basic Usage

```hcl
module "resource_group" {
  source = "git::https://github.com/your-org/terraform-modules.git//modules/foundation/resource-group?ref=v1.0.0"
  
  name     = "rg-myproject-dev-001"
  location = "West US 3"
  
  tags = {
    Environment = "development"
    Project     = "myproject"
    Owner       = "platform-team"
  }
}
```

### With Managed By

```hcl
module "resource_group" {
  source = "git::https://github.com/your-org/terraform-modules.git//modules/foundation/resource-group?ref=v1.0.0"
  
  name       = "rg-myproject-prod-001"
  location   = "West US 3"
  managed_by = azurerm_template_deployment.main.id
  
  tags = {
    Environment = "production"
    Project     = "myproject"
    Owner       = "platform-team"
    CostCenter  = "12345"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the resource group | `string` | n/a | yes |
| location | The Azure region where the resource group will be created | `string` | n/a | yes |
| tags | A mapping of tags to assign to the resource group | `map(string)` | `{}` | no |
| managed_by | The ID of the resource that manages this Resource Group | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Resource Group |
| name | The name of the Resource Group |
| location | The location of the Resource Group |
| tags | The tags applied to the Resource Group |
| managed_by | The ID of the resource that manages this Resource Group |

## Validation Rules

### Resource Group Name
- Must be between 1 and 90 characters
- Can contain alphanumeric characters, periods, underscores, hyphens, and parentheses
- Must not end with a period

### Location
- Must be a valid Azure region (validated against comprehensive list)

## Naming Convention

Recommended naming convention for resource groups:

```
rg-{workload/app}-{environment}-{region/instance}
```

Examples:
- `rg-webapp-dev-001`
- `rg-database-prod-westus3`
- `rg-shared-hub-001`

## Default Tags

The module automatically applies these default tags:

- `ManagedBy`: "Terraform"
- `Module`: "resource-group"
- `CreatedDate`: Current date (YYYY-MM-DD)

Additional tags provided via the `tags` variable will be merged with these defaults.

## Examples

See the [examples](../../../examples/) directory for complete usage examples.

## License

This module is licensed under the MIT License - see the [LICENSE](../../../LICENSE) file for details.