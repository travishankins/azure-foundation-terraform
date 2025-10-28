# Demo 3B: Virtual Network with tfvars

## Overview
This is an enhanced version of Demo 3 that demonstrates **using variable files (tfvars)** instead of hardcoded values in the Terraform configuration.

## 🎯 Learning Objectives

Compare this demo to Demo 3 to understand:
- How to use tfvars files for different environments
- The benefits of separating configuration from code
- Dynamic resource creation using `for_each`
- Using `dynamic` blocks for repeatable nested configurations

## 📁 File Structure

```
demo-03b-vnet-with-tfvars/
├── versions.tf       ← Terraform/provider versions
├── variables.tf      ← Variable definitions
├── main.tf          ← Resources (no hardcoded values!)
├── outputs.tf       ← Output values
├── dev.tfvars       ← Development environment config
├── prod.tfvars      ← Production environment config
├── backend.hcl      ← Remote backend configuration
└── README.md        ← This file
```

## 🔍 Key Differences from Demo 3

### Demo 3 (Hardcoded Values)
```hcl
resource "azurerm_resource_group" "vnet" {
  name     = "rg-demo-03-vnet"        # ❌ Hardcoded
  location = "East US"                 # ❌ Hardcoded
}

resource "azurerm_subnet" "subnet1" {
  name             = "subnet-web"      # ❌ Hardcoded
  address_prefixes = ["10.0.1.0/24"]  # ❌ Hardcoded
}
# ... more hardcoded subnets
```

### Demo 3B (Using Variables)
```hcl
resource "azurerm_resource_group" "vnet" {
  name     = var.resource_group_name   # ✅ From tfvars
  location = var.location              # ✅ From tfvars
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets              # ✅ Dynamic creation

  name             = each.value.name
  address_prefixes = each.value.address_prefixes
}
```

## 💬 INSTRUCTOR SAYS

"In Demo 3, we saw how to deploy a VNet with remote state. But notice how everything was hardcoded - the names, addresses, rules. What if we want to deploy the same infrastructure to dev, UAT, and prod?"

"That's where **tfvars files** come in. Instead of duplicating code, we define the structure once and provide different values for each environment."

## 🚀 How to Use

### 1. Initialize with Remote Backend
```bash
terraform init -backend-config=backend.hcl
```

### 2. Deploy Development Environment
```bash
# Plan with dev config
terraform plan -var-file=dev.tfvars

# Apply dev environment
terraform apply -var-file=dev.tfvars
```

### 3. Deploy Production Environment
```bash
# First, re-initialize with different backend key if needed
# OR just apply directly (uses same state file)

# Plan with prod config
terraform plan -var-file=prod.tfvars

# Apply prod environment
terraform apply -var-file=prod.tfvars
```

## 👀 POINT OUT

### 1. File Organization - versions.tf

```hcl
# versions.tf - All version constraints in one place
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  
  # Backend configuration (commented out by default)
  # Uncomment and use: terraform init -backend-config=backend.hcl
}

provider "azurerm" {
  features {}
  storage_use_azuread = true
}
```

**Teaching Points:**
- ✅ **Separation of Concerns**: Version requirements separate from business logic
- ✅ **Easy to Find**: Team members know where to look for version info
- ✅ **Backend Flexibility**: Backend block is commented out, configured via `backend.hcl`
- ✅ **Provider Settings**: Azure AD auth for storage is configured here

**Why Backend is Commented Out:**
"Notice the backend block is commented out. This gives us flexibility:"
- Can run locally without remote state: `terraform init`
- Can use remote state when needed: `terraform init -backend-config=backend.hcl`
- Different team members can use different backends without changing code

**Alternative Approach:**
"In Demo 4, you'll see we keep the backend block uncommented. Both approaches work - it depends on your team's preference!"

---

### 2. Variable Definitions (variables.tf)
```hcl
variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
}
```
**Teaching Point:** "This defines the structure. Notice the complex type - a map of objects. This lets us create any number of subnets dynamically."

### 2. Dynamic Subnet Creation (main.tf)
```hcl
resource "azurerm_subnet" "subnets" {
  for_each = var.subnets  # Creates one subnet per map entry

  name             = each.value.name
  address_prefixes = each.value.address_prefixes
}
```
**Teaching Point:** "Using `for_each`, we don't need separate subnet1, subnet2, subnet3 resources. Add a subnet in tfvars, it creates automatically!"

### 3. Dynamic NSG Rules (main.tf)
```hcl
dynamic "security_rule" {
  for_each = var.nsg_rules
  content {
    name     = security_rule.value.name
    priority = security_rule.value.priority
    # ... more attributes
  }
}
```
**Teaching Point:** "The `dynamic` block lets us create repeating nested blocks from a list. Add more rules in tfvars, they're applied automatically."

### 4. Environment-Specific Configurations

**dev.tfvars:**
- 3 subnets (web, app, data)
- Permissive NSG rules (HTTP, HTTPS, SSH)
- Development tags

**prod.tfvars:**
- 5 subnets (including management and gateway)
- Strict NSG rules (HTTPS only, HTTP denied)
- Production tags with compliance requirements

## 📊 Comparison Table

| Aspect | Demo 3 (Hardcoded) | Demo 3B (With tfvars) |
|--------|-------------------|----------------------|
| Flexibility | Low - must edit code | High - just change tfvars |
| Reusability | None - copy/paste code | High - same code, different values |
| Subnet Creation | 3 separate resources | Dynamic with `for_each` |
| NSG Rules | 2 inline blocks | Dynamic list from tfvars |
| Environments | 1 configuration | Multiple tfvars files |
| Maintainability | Hard - scattered values | Easy - centralized in tfvars |

## 🎓 Advanced Concepts Demonstrated

### 1. for_each with Maps
Creates resources dynamically based on map keys:
```hcl
resource "azurerm_subnet" "subnets" {
  for_each = var.subnets
  # Creates: subnets["web"], subnets["app"], subnets["data"]
}
```

### 2. dynamic Blocks
Repeats nested configuration blocks:
```hcl
dynamic "security_rule" {
  for_each = var.nsg_rules
  content { ... }
}
```

### 3. Complex Variable Types
```hcl
map(object({
  name             = string
  address_prefixes = list(string)
}))
```

### 4. Map Outputs
```hcl
output "subnet_ids" {
  value = {
    for k, subnet in azurerm_subnet.subnets : k => subnet.id
  }
}
```

## 🎯 Demo Script

### Step 1: Show Variable Definition
```bash
cat variables.tf
```
**Say:** "Notice we define the structure of what we need - subnet names, CIDR blocks, NSG rules - but no actual values."

### Step 2: Show tfvars Files
```bash
cat dev.tfvars
cat prod.tfvars
```
**Say:** "Here's where the actual values live. Same structure, different values for each environment."

### Step 3: Show Main.tf
```bash
cat main.tf
```
**Say:** "The code is clean - no hardcoded values! It references variables using `var.name`."

### Step 4: Deploy Dev
```bash
terraform plan -var-file=dev.tfvars
```
**Say:** "Watch how it creates 3 subnets and 3 NSG rules from our dev configuration."

### Step 5: Compare Prod Plan
```bash
terraform plan -var-file=prod.tfvars
```
**Say:** "Same code, but now it creates 5 subnets with stricter security rules. That's the power of tfvars!"

### Step 6: Show Outputs
```bash
terraform output
```
**Say:** "Notice our subnet_details output shows all subnets dynamically, regardless of how many we created."

## 💡 Best Practices Demonstrated

1. ✅ **Separate configuration from code** - tfvars vs .tf files
2. ✅ **Use complex variable types** - maps, objects, lists
3. ✅ **Dynamic resource creation** - `for_each` instead of copy/paste
4. ✅ **Environment-specific values** - dev.tfvars, prod.tfvars
5. ✅ **Descriptive variable names** - Clear purpose and usage
6. ✅ **Variable validation** - Type constraints ensure correctness
7. ✅ **Organized file structure** - versions, variables, main, outputs

## 🔄 Workflow Comparison

### Demo 3 Workflow (Hardcoded)
1. Edit main.tf to change values
2. Risk of typos in multiple places
3. Hard to see what's different between environments
4. Must copy entire configuration for new environment

### Demo 3B Workflow (With tfvars)
1. Create new .tfvars file
2. Provide values for your environment
3. Run with `-var-file=environment.tfvars`
4. Same tested code, different values

## 🎬 Clean Up

```bash
# Destroy dev environment
terraform destroy -var-file=dev.tfvars

# Or destroy prod environment
terraform destroy -var-file=prod.tfvars
```

## 📚 Related Demos

- **Demo 3** - Same VNet but with hardcoded values (compare the difference!)
- **Demo 4** - Advanced features including locals and more complex tfvars usage
- **Demo 5** - Custom modules (next level of reusability)

## 🎯 Key Takeaways

1. **tfvars files** separate configuration from code
2. **for_each** creates resources dynamically
3. **dynamic blocks** handle repeating nested configuration
4. **Same code, multiple environments** without duplication
5. **Easier maintenance** - change values, not code

---

**Next Step:** After mastering tfvars, check out Demo 4 to see how **locals.tf** can add even more power with computed values and logic!
