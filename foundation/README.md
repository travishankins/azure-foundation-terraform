# Foundation Infrastructure

This directory contains the Terraform configuration for deploying foundational Azure infrastructure components that are shared across all environments and workstreams.

## 🏗️ **Components Deployed**

- **Virtual Network**: Core networking with subnets for private endpoints and applications
- **Network Security Groups**: Security rules and subnet associations  
- **Key Vault**: Centralized secrets management
- **Log Analytics Workspace**: Centralized logging and monitoring
- **Private DNS Zones**: Internal DNS resolution for private endpoints
- **Diagnostic Settings**: Logging configuration for all resources

## 🚀 **Quick Deployment**

### Single Subscription (Default)
```bash
# Initialize and deploy to development
terraform init
terraform plan -var-file="foundation-dev.tfvars"
terraform apply -var-file="foundation-dev.tfvars"
```

### Multi-Subscription
```bash
# Deploy to specific subscription per environment
terraform workspace select dev || terraform workspace new dev
terraform plan -var-file="foundation-dev.tfvars"
terraform apply -var-file="foundation-dev.tfvars"
```

## 📁 **Files Overview**

- **`main.tf`**: Primary resource definitions and module calls
- **`variables.tf`**: Input variable declarations
- **`versions.tf`**: Terraform and provider version constraints
- **`backend.tf`**: Remote state backend configuration
- **`foundation-*.tfvars`**: Environment-specific variable values

## ⚙️ **Configuration**

Key variables to customize:
- `location`: Azure region for deployment
- `vnet_address_space`: IP address ranges for the virtual network
- `subnets`: Subnet configurations with service endpoints
- `subscription_id`: Optional for multi-subscription deployments

See the [main README](../README.md) for complete deployment instructions and multi-subscription setup.
