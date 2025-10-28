# Azure Key Vault Module

This module creates an Azure Key Vault with enterprise-grade security configurations, RBAC support, and network restrictions.

## Features

- ✅ Automatic purge protection for production environments
- ✅ RBAC authorization support
- ✅ Network access controls with private endpoints
- ✅ Soft delete with configurable retention
- ✅ Comprehensive access policy management
- ✅ Integration with Azure services (ARM templates, disk encryption, VM deployment)
- ✅ Consistent naming with random suffix for uniqueness

## Usage

### Basic Key Vault

```hcl
module "key_vault" {
  source = "git::https://github.com/your-org/terraform-modules.git//modules/security/key-vault?ref=v1.0.0"
  
  # Required variables
  resource_group_name     = "rg-myproject-dev-001"
  location               = "West US 3"
  environment            = "dev"
  solution_name          = "myapp"
  resource_instance_count = "001"
  
  # Key Vault configuration
  sku_name                        = "standard"
  enable_rbac_authorization       = true
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  
  tags = {
    Environment = "Development"
    Project     = "MyApplication"
    Owner       = "DevOps Team"
  }
}
```

### Production Key Vault with Network Restrictions

```hcl
module "key_vault" {
  source = "git::https://github.com/your-org/terraform-modules.git//modules/security/key-vault?ref=v1.0.0"
  
  # Required variables
  resource_group_name     = "rg-myproject-prod-001"
  location               = "West US 3"
  environment            = "prod"
  solution_name          = "myapp"
  resource_instance_count = "001"
  
  # Security configuration
  sku_name                      = "premium"
  enable_rbac_authorization     = true
  public_network_access_enabled = false
  purge_protection_enabled      = true
  soft_delete_retention_days    = 90
  
  # Network access controls
  network_acls = {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = ["203.0.113.0/24"]  # Your office IP range
    subnet_ids     = [var.private_subnet_id]
  }
  
  tags = {
    Environment = "Production"
    Project     = "MyApplication"
    Owner       = "Platform Team"
    CostCenter  = "12345"
  }
}
```

### Key Vault with Access Policies (Legacy)

```hcl
module "key_vault" {
  source = "git::https://github.com/your-org/terraform-modules.git//modules/security/key-vault?ref=v1.0.0"
  
  resource_group_name     = "rg-myproject-dev-001"
  location               = "West US 3"
  environment            = "dev"
  solution_name          = "myapp"
  resource_instance_count = "001"
  
  # Use access policies instead of RBAC
  enable_rbac_authorization = false
  
  # Access policies will be managed separately
  tags = var.common_tags
}

# Separate access policy resource
resource "azurerm_key_vault_access_policy" "example" {
  key_vault_id = module.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Create", "Delete", "Get", "List", "Update", "Import", "Backup", "Restore"
  ]

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Backup", "Restore"
  ]

  certificate_permissions = [
    "Get", "List", "Create", "Delete", "Update", "Import"
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | ~> 3.0 |
| random | ~> 3.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| resource_group_name | The name of the resource group | `string` | n/a | yes |
| location | The Azure region for the Key Vault | `string` | n/a | yes |
| environment | Environment name (dev, uat, prod) | `string` | n/a | yes |
| solution_name | Solution name for naming convention | `string` | n/a | yes |
| resource_instance_count | Instance count for naming | `string` | n/a | yes |
| sku_name | The SKU name of the Key Vault | `string` | `"standard"` | no |
| enabled_for_deployment | Enable Azure VMs to retrieve certificates | `bool` | `false` | no |
| enabled_for_disk_encryption | Enable Azure Disk Encryption access | `bool` | `false` | no |
| enabled_for_template_deployment | Enable ARM template deployment access | `bool` | `false` | no |
| enable_rbac_authorization | Use RBAC for access control | `bool` | `true` | no |
| purge_protection_enabled | Enable purge protection | `bool` | `false` | no |
| public_network_access_enabled | Enable public network access | `bool` | `true` | no |
| soft_delete_retention_days | Soft delete retention period | `number` | `7` | no |
| network_acls | Network access control configuration | `object` | `null` | no |
| tags | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Key Vault |
| name | The name of the Key Vault |
| uri | The URI of the Key Vault |
| vault_uri | The URI of the Key Vault for accessing secrets |
| tenant_id | The tenant ID associated with the Key Vault |
| resource_group_name | The resource group containing the Key Vault |

## Security Features

### Automatic Production Hardening
- **Purge Protection**: Automatically enabled for production environments
- **Extended Retention**: 90-day soft delete retention for production
- **Network Isolation**: Support for private endpoints and network ACLs

### RBAC Integration
- **Azure RBAC**: Preferred authentication method for modern Azure environments
- **Built-in Roles**: Support for Key Vault Administrator, Officer, Reader, etc.
- **Granular Permissions**: Fine-grained access control per secret/key/certificate

### Network Security
- **Private Endpoints**: Disable public access and use private connectivity
- **IP Allowlisting**: Restrict access to specific IP ranges
- **Virtual Network Integration**: Allow access from specific subnets

## Naming Convention

The module generates names using this pattern:
```
{solution_name}-kv-{random_suffix}-{environment}-{instance_count}
```

Example: `myapp-kv-a1b-prod-001`

## Best Practices

1. **Use RBAC**: Enable `enable_rbac_authorization = true` for new deployments
2. **Enable Purge Protection**: Always enable for production workloads
3. **Network Restrictions**: Use private endpoints or network ACLs in production
4. **Monitoring**: Enable diagnostic settings for audit logging
5. **Backup**: Implement backup strategies for critical secrets/keys

## Examples

See the [examples](../../../examples/) directory for:
- Basic Key Vault setup
- Production-ready configuration with network restrictions
- Integration with private endpoints
- RBAC role assignments

## Common Issues

### Access Denied Errors
- Ensure your service principal has `Key Vault Contributor` role
- Check if RBAC is enabled and assign appropriate Key Vault roles
- Verify network ACLs aren't blocking access

### Naming Conflicts
- Key Vault names must be globally unique
- The module uses random suffix to avoid conflicts
- Soft-deleted Key Vaults reserve names until purged

## License

This module is licensed under the MIT License - see the [LICENSE](../../../LICENSE) file for details.