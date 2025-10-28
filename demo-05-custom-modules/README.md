# Demo 5: Using Custom Modules

## Overview
This demo shows how to use your existing custom Terraform modules:
- **Resource Group module** - Creates resource groups with standard tags
- **Virtual Network module** - Creates VNet, subnets, NSGs
- **Key Vault module** - Creates secure Key Vault
- **Storage Account module** - Creates storage with advanced features
- **Private DNS Zone module** - Creates private DNS zones

## Key Concepts

### Why Use Modules?
✅ **Reusability** - Write once, use many times  
✅ **Standardization** - Consistent resource configuration  
✅ **Encapsulation** - Hide complexity, expose simple interface  
✅ **Maintainability** - Update in one place, affects all uses  
✅ **Team Collaboration** - Share modules across teams  
✅ **Best Practices** - Embed organizational standards  

### Module Structure
```
module "name" {
  source = "../path/to/module"
  
  # Required inputs
  required_variable = value
  
  # Optional inputs with defaults
  optional_variable = value
}
```

## Files
- `main.tf` - Uses 5 different custom modules
- `variables.tf` - Input variables
- `outputs.tf` - Outputs from all modules

## Demo Steps

**💬 INSTRUCTOR INTRO:**
> "Now we're moving from copying and pasting Terraform code to building reusable components. These modules in the modules directory are like libraries or packages in programming - write once, use everywhere. We've already built these modules, so let me show you how easy they make deployments."

---

### 1. Review Module Structure
```bash
# Look at the available modules
ls -la ../modules/

# Review a module's structure
ls -la ../modules/foundation/resource-group/
cat ../modules/foundation/resource-group/README.md
```

**💬 INSTRUCTOR SAYS:**
> "These are our custom modules - organized by category. Foundation, networking, security, storage. Let's peek inside the resource-group module. It's just Terraform code! main.tf, variables.tf, outputs.tf - the same structure we've been using. The difference is it's packaged for reuse."

**What to show**: Modules are just Terraform code organized for reuse

**👀 POINT OUT:**
- Organized directory structure
- Each module is self-contained
- Same file structure (main, variables, outputs)
- README documents usage

---

### 2. Review Module Usage in main.tf
```bash
cat main.tf
```

**💬 INSTRUCTOR SAYS:**
> "Look at how clean this is. Instead of 50 lines to create a storage account, I have 10 lines calling a module. The module call says 'source' - that's the path to the module. Then I pass in variables like environment and location. The module handles all the complexity - naming conventions, default settings, security configurations."

**What to highlight**:
- `source` points to local module path (../modules/...)
- Input variables passed to module
- Module outputs can be referenced (module.name.output)
- `depends_on` manages dependencies between modules

**👀 POINT OUT:**
- Much shorter than raw resources
- Clear intent - "create a vnet"
- Dependencies explicit
- Reusing proven code

---

### 3. Update Backend Configuration
Update the storage account name in `main.tf` backend block.

**💬 INSTRUCTOR SAYS:**
> "Updating the backend config with our storage account name from Demo 2."

---

### 4. Initialize Terraform
```bash
cd demo-05-custom-modules
terraform init
```

**💬 INSTRUCTOR SAYS:**
> "When I initialize, Terraform discovers all the modules. See it saying 'Initializing modules'? It's loading each one - resource_group, virtual_network, key_vault, etc. These modules are copied to .terraform/modules so Terraform can use them."

**What to show**:
- Terraform initializes each module
- Modules are copied to `.terraform/modules`
- Module loading messages

**👀 POINT OUT:**
- "Initializing modules" in output
- Each module listed
- Happens automatically

---

### 5. Review What Will Be Created
```bash
terraform plan
```

**💬 INSTRUCTOR SAYS:**
> "Look at the plan. Resource addresses now include the module name - 'module.resource_group.azurerm_resource_group.main'. This shows which module created which resource. We're deploying 5 modules worth of infrastructure, but the code in main.tf is only about 150 lines. Without modules, this would be 500+ lines."

**What to show**:
- Resources from 5 different modules
- Module names appear in resource addresses
- Example: `module.resource_group.azurerm_resource_group.main`

Expected resources:
- 1 Resource Group (from module)
- 1 VNet with 3 subnets (from module)
- 3 NSGs with rules (from module)
- 1 Key Vault (from module)
- 1 Storage Account (from module)
- 1 Private DNS Zone (from module)

**👀 POINT OUT:**
- Module prefix in addresses
- Many resources from simple code
- Complex resources abstracted

---

### 6. Apply the Configuration
```bash
terraform apply
```

**💬 INSTRUCTOR SAYS:**
> "Applying now. Watch the resources create - VNet module creates the network AND subnets AND security groups, all with one module call. That's the power of encapsulation."

**👀 POINT OUT:**
- Related resources created together
- Modules respect dependencies
- Creation order is correct

---

### 7. View Module Outputs
```bash
terraform output
terraform output deployment_summary
```

**💬 INSTRUCTOR SAYS:**
> "Module outputs bubble up. The storage_account module outputs the storage account name, I reference it as module.storage_account.storage_account_name in my outputs. Clean composition."

**👀 POINT OUT:**
- Outputs from all modules
- Formatted summary
- Easy access to important values
```bash
terraform output
terraform output deployment_summary
```

**What to show**:
- Outputs from multiple modules
- Module outputs are accessible via `module.<name>.<output>`

### 8. Inspect Module State
```bash
terraform state list
```

**💬 INSTRUCTOR SAYS:**
> "Looking at the state, every resource is prefixed with 'module.module_name'. This organization is automatic. If I need to target a specific module's resources, I can use terraform state commands with module paths."

**What to show**:
- Resources are prefixed with `module.<module_name>`
- Clear organization of resources

**👀 POINT OUT:**
- Module hierarchy in state
- Easy to identify resource sources
- Enables targeted operations

---

### 9. Show a Specific Module's Resources
```bash
terraform state list | grep module.virtual_network
terraform state show module.virtual_network.azurerm_virtual_network.main
```

**💬 INSTRUCTOR SAYS:**
> "I can filter state by module. Here are all resources from the virtual_network module. This makes debugging and management much easier in large deployments."

**👀 POINT OUT:**
- Grep filters by module
- Full resource details available
- Module namespace keeps things organized

---

### 10. Verify in Azure Portal
Show the deployed resources and highlight:
- Consistent naming conventions (from module logic)
- Standard tags (from module defaults)
- Complex resources created with simple inputs

**💬 INSTRUCTOR SAYS:**
> "In the portal, notice the naming. The Key Vault has a computed name following our standard convention - that came from the module. Tags are consistent across all resources - also from the modules. The storage account has hierarchical namespace enabled - that's a default the module sets. All these best practices are baked into the modules."

**👀 POINT OUT:**
- Naming convention consistency
- Standard tags on all resources
- Security settings from modules
- Best practices enforced automatically

## Key Points to Highlight

**💬 INSTRUCTOR WRAP-UP:**
> "Modules are THE way to scale Terraform in an organization. We just deployed a complete environment - networking, security, storage - with clean, simple code. Each module encapsulates best practices and complexity. Your team writes the module once, uses it hundreds of times. Next demo, I'll show you Azure Verified Modules - Microsoft's production-ready modules that we can use instead of building everything ourselves."

### Module Benefits Demonstrated

#### 1. **Abstraction**
Simple inputs create complex infrastructure:
✅ Hide complexity behind simple interfaces  
✅ Turn 100 lines of code into 10  
✅ Self-documenting through module names  

#### 2. **Reusability**
Same module used across:
✅ This demo  
✅ Foundation deployment (`../foundation/main.tf`)  
✅ Any future project  
✅ Different teams in the organization  

#### 3. **Standardization**
Modules enforce:
✅ Naming conventions automatically  
✅ Tagging standards company-wide  
✅ Security settings  consistently
✅ Best practices by default  

#### 4. **Encapsulation**
Module hides:
✅ Complex resource configurations  
✅ Conditional logic  
✅ Default values  
✅ Computed values  

**Enterprise Impact:**
- Faster deployments (reuse vs. recreate)
- Fewer errors (tested modules)
- Consistent infrastructure (standardization)
- Knowledge sharing (modules document patterns)

### Module Input/Output Pattern

#### Inputs (Variables)
```hcl
# What the module needs
variable "resource_group_name" {
  type = string
}
```

#### Processing (Resources & Locals)
```hcl
# What the module does
locals {
  storage_name = "${var.solution_name}${var.environment}..."
}
resource "azurerm_storage_account" "main" {
  name = local.storage_name
  ...
}
```

#### Outputs
```hcl
# What the module returns
output "storage_account_name" {
  value = azurerm_storage_account.main.name
}
```

## Module Dependency Chain

This demo shows proper module chaining:
```
module.resource_group
    ↓
    ├── module.virtual_network
    │       ↓
    │       └── module.private_dns_zone
    │
    ├── module.key_vault
    │
    └── module.storage_account
```

Using `depends_on` to manage dependencies.

## Comparing to Non-Module Approach

### Without Modules (Demo 1-4)
```hcl
# Direct resource creation
resource "azurerm_storage_account" "main" {
  name                     = "mystorageaccount"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  # 50+ more lines of configuration...
}
```

### With Modules (Demo 5)
```hcl
# Module abstracts complexity
module "storage_account" {
  source = "../modules/storage/storage-account"
  
  resource_group_name  = module.resource_group.name
  environment          = "demo"
  solution_name        = "demo05"
  # Module handles the rest!
}
```

## Module Development Tips

### 1. **Single Responsibility**
Each module should do one thing well:
- ✅ Good: `resource-group` module
- ❌ Bad: `entire-infrastructure` module

### 2. **Required vs Optional**
```hcl
# Required - no default
variable "resource_group_name" {
  type = string
}

# Optional - has default
variable "sku_name" {
  type    = string
  default = "standard"
}
```

### 3. **Output Important Values**
```hcl
output "key_vault_id" {
  value = azurerm_key_vault.main.id
}
```

### 4. **Document Your Modules**
Each module should have:
- `README.md` - Usage instructions
- Input variable descriptions
- Output descriptions
- Examples

## Advanced: Module Versioning

For production, use versioned modules:
```hcl
module "storage" {
  source  = "git::https://github.com/org/terraform-modules.git//storage?ref=v1.0.0"
  # or
  source  = "registry.terraform.io/org/module/azurerm"
  version = "1.0.0"
}
```

## Cleanup
```bash
terraform destroy
```

**What to show**: All module resources are destroyed in correct order

## Next Demo
Demo 6 will show Azure Verified Modules from the Terraform Registry - production-ready, Microsoft-verified modules.
