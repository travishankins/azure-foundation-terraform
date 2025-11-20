# Demo 7: Azure Verified Modules with Customization

## Overview
This demo showcases how to use **Azure Verified Modules (AVM)** from the Terraform Registry while implementing custom naming conventions, environment-specific configurations, and organizational standards. This is the practical application of AVM concepts from Demo 6.

**💬 INSTRUCTOR INTRO:**
> "Now we're putting Azure Verified Modules into action - with a twist. Demo 6 introduced AVM. This demo shows you how to REALLY use them in production with your organization's standards. We're taking Microsoft's battle-tested modules and adding our custom naming, environment-specific rules, and organizational policies on top. This is the pattern Fortune 500 companies use."

## 🎯 What This Demo Covers

- ✅ Using real AVM modules from the official Terraform Registry
- ✅ Implementing custom naming conventions across all resources
- ✅ Environment-based configuration (dev/uat/prod)
- ✅ Centralized tagging strategy with automatic timestamps
- ✅ Security best practices with environment-specific rules
- ✅ Diagnostic settings and monitoring integration
- ✅ Container and blob configuration customization
- ✅ Locals-driven configuration (like Demo 4)

## 📦 Azure Verified Modules Used

| Module | Purpose | Version |
|--------|---------|---------|
| [avm-res-network-virtualnetwork](https://registry.terraform.io/modules/Azure/avm-res-network-virtualnetwork/azurerm) | Virtual Network | ~> 0.4 |
| [avm-res-keyvault-vault](https://registry.terraform.io/modules/Azure/avm-res-keyvault-vault/azurerm) | Key Vault | ~> 0.9 |
| [avm-res-storage-storageaccount](https://registry.terraform.io/modules/Azure/avm-res-storage-storageaccount/azurerm) | Storage Account | ~> 0.2 |
| [avm-res-operationalinsights-workspace](https://registry.terraform.io/modules/Azure/avm-res-operationalinsights-workspace/azurerm) | Log Analytics | ~> 0.3 |

## 🏗️ Resources Deployed

1. **Resource Group** - Base container with custom naming
2. **Virtual Network** - 10.70.0.0/16 with 3 subnets (web, app, data)
3. **Key Vault** - RBAC-enabled with environment-based network rules
4. **Storage Account** - 3 containers with versioning and retention
5. **Log Analytics Workspace** - Environment-specific retention policies
6. **Diagnostic Settings** - Monitoring for Key Vault and Storage

## 🎨 Custom Naming Convention

All resources follow this pattern:
```
{org-prefix}-{resource-type}-{environment}-{random-suffix}

Examples:
- demo07-rg-dev-a1b2
- demo07-vnet-dev-a1b2
- demo07kvdeva1b2 (Key Vault - no dashes)
- demo07stdeva1b2 (Storage - lowercase, no dashes)
```

## 🔧 Environment-Based Customization

| Feature | Dev | Prod |
|---------|-----|------|
| Storage Replication | LRS | GRS |
| Key Vault Network | Allow All | Deny (IP whitelist) |
| Storage Public Access | Enabled | Disabled |
| Log Retention | 30 days | 90 days |
| Blob Retention | 7 days | 30 days |
| Change Feed | Disabled | Enabled |

## 📋 Prerequisites

1. Azure subscription with appropriate permissions
2. Terraform >= 1.6
3. Azure CLI authenticated or service principal
4. Remote state storage configured (from demo-02)

## Demo Steps

**💬 INSTRUCTOR NOTE:**
> "Before starting, make sure you have your storage account name from Demo 2. We'll be using remote state and showing how AVM modules integrate into a real workflow."

---

### Part 1: Review the Custom Naming Strategy

#### 1. Examine the Locals
```bash
cd demo-07-avm-with-customization
cat locals.tf
```

**💬 INSTRUCTOR SAYS:**
> "First, let's look at our naming strategy. In locals.tf, I've defined a naming convention that works across all resources. The pattern is organization prefix, resource type, environment, and a random suffix. Some resources like Key Vault and Storage have special rules - no dashes, lowercase only, length limits. I handle all that complexity in locals so the rest of my code stays clean."

**What to show**:
- Naming convention in locals
- Random suffix for uniqueness
- Resource-specific name formatting (Key Vault, Storage)
- Environment-based configurations

**👀 POINT OUT:**
- Centralized naming logic
- Handles Azure naming constraints automatically
- Easy to change convention in one place

---

#### 2. Review Environment Configurations
```bash
cat locals.tf | grep -A 20 "environment_config"
```

**💬 INSTRUCTOR SAYS:**
> "See this environment_config map? It's like Demo 4's advanced features. Dev gets LRS storage and less restrictive network rules. Prod gets GRS replication, stricter security, longer retention. The code looks up the environment and applies the right settings automatically."

**👀 POINT OUT:**
- Dev: LRS, Allow All network rules, 7 days retention
- Prod: GRS, Deny network rules, 30 days retention
- Automatic based on environment variable

---

### Part 2: Deploy to Development

#### 1. Update Backend Configuration
Create or update `backend.hcl`:
```hcl
resource_group_name  = "rg-terraform-state"
storage_account_name = "tfstateXXXXXX"  # Your storage account from demo-02
container_name       = "tfstate"
key                  = "demo07-avm-custom-dev.tfstate"
```

**💬 INSTRUCTOR SAYS:**
> "Updating the backend config with our storage account name. Notice the key - demo07-avm-custom-dev.tfstate. We'll use different keys for dev and prod, just like in Demo 4."

---

#### 2. Review the Dev Variables
```bash
cat dev.tfvars
```

**💬 INSTRUCTOR SAYS:**
> "The dev.tfvars file is simple - organization prefix, environment, location, and tags. All the complex configuration logic lives in locals.tf. This separation keeps our variable files clean and easy to understand."

**What to show**:
- Simple variable values
- Custom tags for the organization
- Environment set to "dev"

---

#### 3. Initialize Terraform
```bash
terraform init -backend-config=backend.hcl
```

**💬 INSTRUCTOR SAYS:**
> "Initializing now. Watch Terraform download the AVM modules from the registry. These are coming straight from Microsoft - production-ready, tested modules. We're not writing networking code from scratch; we're using Microsoft's verified implementation."

**What to show**:
- Downloading modules from registry.terraform.io
- Module versions being locked
- Each AVM module initialized

**👀 POINT OUT:**
- "Downloading registry.terraform.io/Azure/avm..." messages
- Modules are external, not local
- Version constraints being applied

---

#### 4. Review the Deployment Plan
```bash
terraform plan -var-file=dev.tfvars
```

**💬 INSTRUCTOR SAYS:**
> "Look at this plan. See the resource addresses? 'module.vnet.azurerm_virtual_network.this[0]' - that 'this' comes from the AVM module's internal structure. We're not writing azurerm_virtual_network directly; the AVM module creates it for us with all Microsoft's best practices baked in. Check the names - demo07-vnet-dev with a random suffix, demo07kvdev... - all following our naming convention, but deployed via AVM modules."

**What to show**:
- AVM module resource paths (module.vnet.azurerm_virtual_network.this)
- Custom naming applied to AVM resources
- Storage replication = LRS (dev setting)
- Network rules = Allow All (dev setting)
- 3 storage containers created automatically
- Diagnostic settings linking to Log Analytics

**👀 POINT OUT:**
- Module internals visible in plan (e.g., "this[0]")
- Custom names on AVM-created resources
- Environment-specific configs active
- Many resources from concise code

---

#### 5. Deploy Development Environment
```bash
terraform apply -var-file=dev.tfvars
```

**💬 INSTRUCTOR SAYS:**
> "Applying now. The AVM modules handle all the complexity - RBAC for Key Vault, diagnostic settings integration, subnet configurations, everything. We just provided the high-level inputs and our naming conventions."

**What to show**:
- Resources creating via AVM modules
- Diagnostic settings automatically configured
- Containers created with custom names

---

#### 6. Review Outputs
```bash
terraform output
terraform output naming_convention
terraform output deployment_summary
```

**💬 INSTRUCTOR SAYS:**
> "Check out these outputs. The naming_convention shows our pattern in action. Deployment_summary shows all the environment-specific settings that were automatically applied - LRS storage, shorter retention, dev-appropriate security. All this came from our locals based on environment = 'dev'."

**What to show**:
- All resource names with consistent convention
- Environment-specific settings displayed
- Storage container names
- Module outputs accessible

**👀 POINT OUT:**
- Naming consistency across all resources
- Environment config visible in summary
- Easy access to important values

---

### Part 3: Show AVM Module Customization

#### 1. Examine the VNet Module Configuration
```bash
cat main.tf | grep -A 30 "module \"vnet\""
```

**💬 INSTRUCTOR SAYS:**
> "Let me show you how we customized the AVM virtual network module. The module call starts simple - source from the registry, version pinned. Then look at the inputs: name uses our custom local, resource_group_name uses our RG, address_space is defined. The subnets block - that's the AVM module's API. We provide subnet names and CIDRs, the module handles all the Terraform resource creation, dependency management, everything."

**What to highlight**:
- Module source from Terraform Registry
- Version pinning (~> 0.4)
- Custom naming via locals
- Subnets configuration using AVM's API
- Tags merging our org tags

**👀 POINT OUT:**
- Registry source, not local path
- Version constraint for stability
- Our naming, Microsoft's implementation
- Cleaner than raw resources

---

#### 2. Examine the Key Vault Module
```bash
cat main.tf | grep -A 35 "module \"key_vault\""
```

**💬 INSTRUCTOR SAYS:**
> "The Key Vault module shows environment-based customization. See 'public_network_access_enabled = local.current_config.kv_network_access == "Allow" ? true : false'? That's environment-driven. In dev, network access is allowed. In prod, it would be denied. The AVM module creates the Key Vault with all Azure best practices - soft delete, purge protection options, RBAC - we just configure the high-level behavior."

**What to highlight**:
- Environment-based network rules
- RBAC authorization enabled
- Diagnostic settings integration
- Contact information customization

**👀 POINT OUT:**
- Conditional logic for environment
- Microsoft best practices automatic
- Security by default

---

#### 3. Examine Storage with Containers
```bash
cat main.tf | grep -A 40 "module \"storage\""
```

**💬 INSTRUCTOR SAYS:**
> "The storage module is interesting. Look at account_replication_type - it uses local.current_config.storage_replication. Dev gets LRS, prod gets GRS, automatic. Then see the containers block? We're creating three containers - data, logs, and backups - right in the module call. The AVM module handles container creation, versioning, retention policies. We just declare what we want."

**What to highlight**:
- Environment-based replication
- Multiple containers in one module call
- Container-specific settings (versioning, retention)
- Hierarchical namespace for ADLS Gen2
- Blob properties and change feed

**👀 POINT OUT:**
- Containers created with storage account
- Each container has own settings
- Environment determines replication
- ADLS Gen2 enabled automatically

---

### Part 4: Deploy to Production (Same Code!)

**💬 INSTRUCTOR TRANSITION:**
> "Now the real test - deploying to production with the same code. Only the tfvars and backend config change. Watch how different the infrastructure becomes."

---

#### 1. Create Production Backend Config
Create `backend-prod.hcl`:
```hcl
resource_group_name  = "rg-terraform-state"
storage_account_name = "tfstateXXXXXX"
container_name       = "tfstate"
key                  = "demo07-avm-custom-prod.tfstate"
```

**💬 INSTRUCTOR SAYS:**
> "New backend config pointing to a different state file key. Dev and prod states are completely isolated."

---

#### 2. Create Production Variables
Create `prod.tfvars`:
```hcl
organization_prefix = "demo07"
environment         = "prod"
location            = "East US"

tags = {
  Environment = "Production"
  Project     = "AVM-Demo"
  CostCenter  = "IT-Production"
  Owner       = "Platform-Team"
  Compliance  = "Required"
}

key_vault_sku = "premium"  # HSM-backed keys
key_vault_allowed_ips = ["YOUR_IP/32"]  # Add your IP

storage_shared_key_enabled = false  # Use Azure AD only
storage_allowed_ips = ["YOUR_IP/32"]
```

**💬 INSTRUCTOR SAYS:**
> "Production tfvars are stricter. Environment is 'prod'. Premium Key Vault for HSM-backed keys. Shared access keys disabled on storage - Azure AD auth only. IP whitelisting for network access. Compliance tags. This is how you lock down production."

**👀 POINT OUT:**
- Environment = "prod" triggers all prod configs
- Premium SKU vs standard
- Stricter security settings
- Compliance tags

---

#### 3. Re-initialize for Production
```bash
terraform init -backend-config=backend-prod.hcl -reconfigure
```

**💬 INSTRUCTOR SAYS:**
> "Re-initializing with -reconfigure to point to prod state file. Same modules, different state."

---

#### 4. Plan Production Deployment
```bash
terraform plan -var-file=prod.tfvars
```

**💬 INSTRUCTOR SAYS:**
> "Look at this prod plan carefully. Names include 'prod' instead of 'dev'. Storage replication is GRS - geo-redundant. Key Vault network rules are 'Deny' with IP whitelist only. Blob retention is 30 days instead of 7. Change feed enabled. Log Analytics retention is 90 days. All because environment = 'prod'. Same code, production-grade infrastructure."

**What to show**:
- Resource names with "prod"
- Storage replication: GRS
- Network rules: Deny with IP whitelist
- Longer retention periods (30 days vs 7)
- Change feed enabled
- 90-day Log Analytics retention

**👀 POINT OUT:**
- Dramatically different settings
- More restrictive security
- Production-grade resilience
- All automatic from environment variable

---

#### 5. Review the Differences Side-by-Side
```bash
# In another terminal, show dev output
cd demo-07-avm-with-customization
terraform init -backend-config=backend.hcl -reconfigure
terraform output deployment_summary

# Back to prod terminal
terraform output deployment_summary
```

**💬 INSTRUCTOR SAYS:**
> "Put dev and prod outputs side by side. Dev: LRS, Allow All, 7 days, 30-day logs. Prod: GRS, Deny with IP, 30 days, 90-day logs. One codebase, two completely different security postures. This is infrastructure as code done right."

---

### Part 5: Demonstrate AVM Benefits

**💬 INSTRUCTOR TRANSITION:**
> "Let me show you what we DIDN'T have to write because we're using AVM modules."

#### 1. Show What AVM Provides
```bash
terraform state list | grep module.vnet
terraform state show module.vnet.azurerm_virtual_network.this[0]
```

**💬 INSTRUCTOR SAYS:**
> "Look at the state. The VNet module created the virtual network, all subnets, potentially NSGs, route tables - all the complexity hidden. Show the full state of the VNet - see all the properties AVM set up? DDoS protection config, DNS servers handling, encryption in transit. We didn't write any of that. Microsoft did, and we benefit."

**What to show**:
- Multiple resources from one module call
- Complex resource configurations handled
- Best practices automatic

---

#### 2. Check Key Vault Configuration
```bash
terraform state show module.key_vault.azurerm_key_vault.this
```

**💬 INSTRUCTOR SAYS:**
> "Key Vault state shows RBAC enabled, soft delete configured, purge protection, all the security settings Microsoft recommends. We specified high-level requirements, AVM implemented Azure best practices."

**👀 POINT OUT:**
- Soft delete enabled
- Purge protection configured
- RBAC authorization enabled
- All from Microsoft's template

---

#### 3. Verify in Azure Portal
Open Azure Portal and show:
- Resource naming consistency
- Tags applied universally
- Diagnostic settings configured
- Storage containers created
- Network security rules
- Key Vault RBAC

**💬 INSTRUCTOR SAYS:**
> "In the portal, everything is perfect. Names follow our convention. Tags are consistent. Diagnostic settings are wired up. Storage has all three containers with the right retention policies. This is the power of combining AVM modules with custom configuration."

**👀 POINT OUT:**
- Professional naming scheme
- Comprehensive tagging
- Monitoring configured automatically
- Production-ready infrastructure

## 🎯 Key Customization Examples

### 1. Custom Naming with Locals
```hcl
locals {
  prefix              = var.organization_prefix
  environment         = var.environment
  resource_group_name = "${local.prefix}-rg-${local.environment}-${random_string.suffix.result}"
}
```

### 2. Environment-Based Configuration
```hcl
account_replication_type = var.environment == "prod" ? "GRS" : "LRS"
```

### 3. Dynamic Tagging
```hcl
tags = merge(
  var.tags,
  {
    Environment = var.environment
    DeploymentDate = timestamp()
  }
)
```

### 4. Conditional Resources
```hcl
network_rules = var.environment == "prod" ? {
  default_action = "Deny"
  ip_rules       = var.storage_allowed_ips
} : null
```

## 📊 Testing Validation

After deployment, verify:

```bash
# Check resource group
az group show --name $(terraform output -raw resource_group_name)

# Check virtual network
az network vnet show --name $(terraform output -raw virtual_network_name) \
  --resource-group $(terraform output -raw resource_group_name)

# Check Key Vault
az keyvault show --name $(terraform output -raw key_vault_name)

# Check Storage Account
az storage account show --name $(terraform output -raw storage_account_name)
```

## 🔍 What Makes This Different from Demo 6?

| Aspect | Demo 6 | Demo 7 |
|--------|--------|--------|
| AVM Modules | Mentioned but not used | Actually implemented |
| Naming | Basic hardcoded names | Custom convention with locals |
| Environment | Single config | Multi-environment support |
| Customization | Minimal | Extensive (naming, tags, rules) |
| Monitoring | Not included | Full diagnostic settings |
| Security | Basic | Environment-based policies |
| Containers | None | 3 containers with custom names |

## 🧹 Cleanup

### Destroy Development
```bash
terraform init -backend-config=backend.hcl -reconfigure
terraform destroy -var-file=dev.tfvars
```

**💬 INSTRUCTOR SAYS:**
> "Destroying dev environment. AVM modules handle cleanup properly - diagnostic settings removed first, then monitored resources. Proper dependency management."

### Destroy Production
```bash
terraform init -backend-config=backend-prod.hcl -reconfigure
terraform destroy -var-file=prod.tfvars
```

**👀 POINT OUT:**
- Separate state files mean isolated destruction
- Can destroy dev without affecting prod
- AVM modules clean up dependencies correctly

## Key Points to Highlight

**💬 INSTRUCTOR WRAP-UP:**
> "This is enterprise Terraform in action. We've combined three powerful concepts: Azure Verified Modules for Microsoft's best practices, locals for custom configuration logic, and environment-based deployments. We wrote about 200 lines of code and got production-grade infrastructure with custom naming, security controls, monitoring, and environment-specific behavior. This is the pattern used by Fortune 500 companies. You start with AVM modules - don't reinvent networking or storage. Layer on your organization's naming and tagging. Add environment-specific security rules. One codebase deploys everywhere with appropriate configurations. That's modern infrastructure as code."

### 📚 Key Learnings

#### 1. **AVM + Customization = Enterprise Ready**
✅ Microsoft provides best-practice modules  
✅ You add organizational standards  
✅ Result: Production-ready, compliant infrastructure  
✅ No need to be Azure experts - Microsoft already built it  

#### 2. **Naming Conventions at Scale**
✅ Centralized in locals.tf  
✅ Handles Azure naming constraints automatically  
✅ Consistent across all resources  
✅ Easy to change organization-wide  
✅ Special handling for Key Vault, Storage (no dashes, length limits)  

#### 3. **Environment-Based Configuration**
✅ Single codebase, multiple environments  
✅ Automatic configuration based on environment variable  
✅ Dev gets developer-friendly settings  
✅ Prod gets security and resilience  
✅ Add new environments by adding tfvars file  

#### 4. **Security by Default**
✅ More restrictive in production automatically  
✅ RBAC authorization on Key Vault  
✅ Network rules environment-specific  
✅ Azure AD authentication in prod  
✅ Longer retention in production  

#### 5. **Observability Built-In**
✅ Diagnostic settings configured automatically  
✅ Log Analytics workspace per environment  
✅ Monitoring ready on day one  
✅ No separate monitoring deployment needed  

#### 6. **Module Composition**
✅ AVM modules integrate seamlessly  
✅ Outputs from one feed inputs to another  
✅ Diagnostic settings reference Log Analytics  
✅ Clean dependency management  

**Enterprise Benefits:**
- **Reduced Development Time**: Use AVM instead of writing from scratch
- **Lower Maintenance**: Microsoft maintains AVM modules
- **Consistent Standards**: Naming and tagging enforced automatically
- **Security Compliance**: Production settings automatic
- **Easy Scaling**: Add environments with just tfvars files
- **Best Practices**: Microsoft's expertise embedded

## 🔗 Related Demos

- **Demo 6**: Basic introduction to AVM concept
- **Demo 4**: Advanced features and locals
- **Demo 5**: Custom modules vs AVM modules

## 📖 Additional Resources

- [Azure Verified Modules](https://aka.ms/avm)
- [Terraform Registry - AVM](https://registry.terraform.io/namespaces/Azure)
- [Azure Naming Conventions](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
