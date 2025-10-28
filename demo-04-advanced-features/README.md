# Demo 4: Advanced Terraform Features

## Overview
This demo showcases advanced Terraform patterns and best practices:
- **Locals**: Computed values and DRY principles
- **Outputs**: Different types of output values
- **Variables**: Input validation and defaults
- **Tfvars**: Environment-specific configuration files
- **Conditional Resources**: Resources deployed based on conditions
- **Dynamic Blocks**: For_each and dynamic resource creation
- **Multiple State Files**: Separate state per environment

## Key Concepts

### 1. **Locals**
Computed values that are calculated once and reused throughout the configuration:
- Resource naming conventions
- Merged tags
- Environment-specific configurations
- Dynamic subnet calculations using CIDR

### 2. **Outputs**
Various output patterns:
- Simple outputs (strings, IDs)
- Complex objects (maps of subnet details)
- Conditional outputs (prod-only resources)
- Formatted text outputs (deployment summary)
- Sensitive outputs

### 3. **Variables**
Input validation and type constraints:
- Required variables
- Default values
- Validation rules
- Type constraints (string, list, map)

### 4. **Tfvars Files**
Environment-specific configuration:
- `dev.tfvars` - Development settings
- `uat.tfvars` - UAT settings
- `prod.tfvars` - Production settings

### 5. **Multiple State Files**
Separate state files for each environment:
- `demo04-dev.tfstate`
- `demo04-uat.tfstate`
- `demo04-prod.tfstate`

## Files Structure
```
demo-04-advanced-features/
├── main.tf              # Main configuration
├── locals.tf            # Local values (best practice separation)
├── variables.tf         # Variable definitions with validation
├── outputs.tf           # Comprehensive outputs
├── dev.tfvars          # Dev environment values
├── uat.tfvars          # UAT environment values
├── prod.tfvars         # Production environment values
├── backend-dev.hcl     # Dev backend config
├── backend-uat.hcl     # UAT backend config
├── backend-prod.hcl    # Prod backend config
└── README.md           # This file
```

## Demo Steps

**💬 INSTRUCTOR INTRO:**
> "This is where Terraform really shines. We're going to use the SAME code to deploy three different environments - dev, UAT, and production. Each will have different configurations: different sizes, different features, different address spaces. The code is identical; only the variable files change. This is how enterprise teams manage multiple environments."

---

### Part 1: Deploy to Dev Environment

#### 1. Update Backend Configuration
Update all `backend-*.hcl` files with your storage account name from Demo 2.

**💬 INSTRUCTOR SAYS:**
> "First, I'm updating all three backend files with our storage account name. Notice each has a different key - demo04-dev.tfstate, demo04-uat.tfstate, demo04-prod.tfstate. This means three separate state files, so dev changes don't affect production."

---

#### 2. Initialize for Dev
```bash
cd demo-04-advanced-features
terraform init -backend-config=backend-dev.hcl
```

**💬 INSTRUCTOR SAYS:**
> "I'm initializing with the dev backend configuration. This points to the dev state file in Azure."

---

#### 3. Review Dev Configuration
```bash
cat dev.tfvars
cat locals.tf
```

**💬 INSTRUCTOR SAYS:**
> "Look at dev.tfvars - project name 'demo04', environment 'dev', only 2 subnets. Now look at locals.tf - this is where the magic happens. See the environment_config? For dev, it defines a small VM size (B2s), instance count of 1, and backup disabled. These are automatic based on the environment variable."

**What to show**: Environment-specific values and computed locals

**👀 POINT OUT:**
- Tfvars contains simple values
- Locals contains complex logic
- Environment drives configuration

---

#### 4. Plan for Dev
```bash
terraform plan -var-file=dev.tfvars
```

**💬 INSTRUCTOR SAYS:**
> "Running the plan with dev.tfvars. Watch the resource names - they'll all include 'demo04-dev'. Notice we're creating 2 subnets, NOT 3. Storage replication is LRS. And critically - NO Log Analytics Workspace. We have a conditional in the code that only creates that in production."

**What to show**:
- Resource names include "demo04-dev"
- 2 subnets (web, app)
- No Log Analytics Workspace (count = 0)
- Storage replication: LRS

**👀 POINT OUT:**
- Computed naming convention
- Conditional resource (count = 0 for LAW)
- Dynamic subnet creation

---

#### 5. Apply Dev
```bash
terraform apply -var-file=dev.tfvars
```

**💬 INSTRUCTOR SAYS:**
> "Applying to dev environment. Same code, but configured for development workloads."

---

#### 6. Review Dev Outputs
```bash
terraform output
terraform output deployment_summary
terraform output environment_config
```

**💬 INSTRUCTOR SAYS:**
> "Look at the outputs. The deployment_summary shows all our configurations. Environment_config shows VM Size B2s, instance count 1, backup false - these came from our locals! The code looked up 'dev' in the environment_config map and used those values automatically."

**What to show**:
- Different output types (string, map, formatted text)
- Computed local values in action
- Environment-specific config (B2s VM, no backup)

---

### Part 2: Deploy to Production (Same Code!)

**💬 INSTRUCTOR TRANSITION:**
> "Now here's where it gets interesting. I'm going to deploy to production using the EXACT same Terraform code. The only thing that changes is the tfvars file and the backend configuration. Watch how different the infrastructure is."

---

#### 1. Re-initialize for Production
```bash
terraform init -backend-config=backend-prod.hcl -reconfigure
```

**💬 INSTRUCTOR SAYS:**
> "I'm re-initializing with -reconfigure to switch to the production backend. This points to a completely different state file. Dev and prod states are totally isolated."

**What to show**: Different state file (demo04-prod.tfstate)

---

#### 2. Review Production Configuration
```bash
cat prod.tfvars
```

**💬 INSTRUCTOR SAYS:**
> "Compare this to dev.tfvars. Environment is 'prod', we have 4 subnets instead of 2, different address space (10.30 instead of 10.10), and different tags showing this is a production workload."

**What to show**: 
- Different values than dev
- 4 subnets instead of 2
- Different address space
- Different tags (Compliance: Required)

**👀 POINT OUT:**
- Same variables, different values
- More subnets in production
- Compliance tags

---

#### 3. Plan for Production
```bash
terraform plan -var-file=prod.tfvars
```

**💬 INSTRUCTOR SAYS:**
> "Look at this plan carefully. Resource names now include 'demo04-prod'. We have 4 subnets this time. Storage replication is GRS - geo-redundant - because it's production. And most importantly, see that Log Analytics Workspace? It's being created! The same code that skipped it in dev creates it in prod. That's the power of conditionals."

**What to show**:
- Resource names include "demo04-prod"
- 4 subnets (web, app, data, mgmt)
- Log Analytics Workspace INCLUDED (count = 1)
- Storage replication: GRS (geo-redundant)
- Different address space (10.30.0.0/16)

**👀 POINT OUT:**
- Same code, different result
- Conditional resource creation
- Production-grade settings automatic

---

#### 4. Apply Production
```bash
terraform apply -var-file=prod.tfvars
```

**💬 INSTRUCTOR SAYS:**
> "Applying to production now. Watch how Terraform creates production-grade infrastructure from the same code we used for dev."

---

#### 5. Review Production Outputs
```bash
terraform output deployment_summary
terraform output log_analytics_workspace_id
terraform output environment_config
```

**💬 INSTRUCTOR SAYS:**
> "Check out these outputs. Environment_config now shows VM Size D4s_v3 - much bigger than dev's B2s. Instance count is 3. Backup is enabled. Storage replication is GRS. And log_analytics_workspace_id actually has a value! All of this was determined automatically based on environment = 'prod'."

**What to show**:
- Log Analytics deployed in prod
- Different VM size (D4s_v3)
- Backup enabled
- GRS replication
- All from same code!

### Part 3: Demonstrate Locals

**💬 INSTRUCTOR TRANSITION:**
> "Let me show you under the hood. Terraform has an interactive console where we can test expressions and see how locals are computed."

#### 1. Review locals.tf File
```bash
cat locals.tf
```

**💬 INSTRUCTOR SAYS:**
> "This file is pure gold for enterprise Terraform. Look at what we have: resource_prefix combines project and environment. common_tags merges our custom tags with default tags. environment_config is a lookup table - depending on the environment, we get different VM sizes, instance counts, backup settings. And subnets are calculated dynamically using cidrsubnet - no manual IP math!"

**What to show**: 
- Locals separated into their own file (best practice)
- Computed naming conventions
- Environment-specific configurations
- Tag merging
- Conditional values
- CIDR calculations

**👀 POINT OUT:**
- Clean separation of concerns
- Complex logic in one place
- Easy to maintain and modify

---

#### 2. Show Computed Values
```bash
terraform console -var-file=prod.tfvars
```

In the console:
```hcl
> local.resource_prefix
> local.common_tags
> local.current_config
> local.subnets
> local.is_production
> local.storage_replication
> local.log_retention_days
> cidrsubnet("10.0.0.0/16", 8, 0)
> cidrsubnet("10.0.0.0/16", 8, 1)
```

**💬 INSTRUCTOR SAYS:**
> "Let me try some of these. I type 'local.resource_prefix' and hit enter - it shows 'demo04-prod'. local.is_production returns true because we're using prod.tfvars. local.current_config shows the production settings from our lookup table. See how cidrsubnet works? Give it a CIDR block and an index, it calculates the subnet automatically. No more subnet calculator websites!"

**What to show**: How locals compute and simplify complex logic

**👀 POINT OUT:**
- Interactive testing
- Locals are expressions, evaluated at runtime
- Type 'exit' to leave console

### Part 4: Demonstrate Different State Files

**💬 INSTRUCTOR TRANSITION:**
> "Let me prove that dev and prod are completely isolated with separate state files."

#### 1. List State Files in Azure
Navigate to Azure Portal → Storage Account → tfstate container

**💬 INSTRUCTOR SAYS:**
> "Back in the Azure Portal, look at our tfstate container. See multiple state files here? demo04-dev.tfstate and demo04-prod.tfstate sit side by side. They're completely independent. I could destroy dev without affecting prod. This is environment isolation at the state level."

**What to show**:
- Multiple state files coexist
- `demo04-dev.tfstate`
- `demo04-prod.tfstate`
- Each environment is independent

**👀 POINT OUT:**
- Separate files in same container
- Different sizes (prod is bigger)
- Independent lifecycles

---

#### 2. Switch Between Environments
```bash
# Switch to dev
terraform init -backend-config=backend-dev.hcl -reconfigure
terraform state list

# Switch to prod
terraform init -backend-config=backend-prod.hcl -reconfigure
terraform state list
```

**💬 INSTRUCTOR SAYS:**
> "Watch me switch between environments. I re-initialize with dev backend config, run state list - see 2 subnets. Now I switch to prod backend, run state list again - 4 subnets. Same code directory, different state, different infrastructure. This is powerful."

**What to show**: Different resources in each state

**👀 POINT OUT:**
- Easy to switch between environments
- Each has different resources
- -reconfigure flag forces backend change

## Key Points to Highlight

**💬 INSTRUCTOR WRAP-UP:**
> "This demo showed enterprise-grade Terraform patterns. One codebase, multiple environments, each configured appropriately. Locals keep our code DRY. Tfvars make environments easy to configure. Separate state files provide complete isolation. Conditional resources let us deploy expensive services only where needed. This is how Fortune 500 companies manage their cloud infrastructure - and now you know how to do it too."

### Locals
✅ **DRY Principle** - Define once, use many times  
✅ **Computed Values** - Dynamic calculations  
✅ **Naming Conventions** - Consistent resource naming  
✅ **Tag Management** - Merge common and custom tags  
✅ **Complex Logic** - Environment-specific configurations  
✅ **Separation of Concerns** - Locals in separate file for clarity  

### Outputs
✅ **Documentation** - Self-documenting infrastructure  
✅ **Integration** - Output values for other tools  
✅ **Debugging** - View resource attributes  
✅ **Different Types** - Strings, objects, formatted text  
✅ **Conditional** - Show/hide based on conditions  

### Variables & Tfvars
✅ **Validation** - Input validation prevents errors  
✅ **Type Safety** - Strongly typed inputs  
✅ **Environment Separation** - Different values per environment  
✅ **Reusability** - Same code, different configs  

### Multiple State Files
✅ **Environment Isolation** - Separate state per environment  
✅ **Blast Radius** - Changes only affect one environment  
✅ **Parallel Deployments** - No state conflicts  
✅ **Clear Separation** - Dev changes don't affect prod  

**Enterprise Benefits:**
- One codebase for all environments
- Environment-appropriate configurations automatic
- Easy to add new environments (just add tfvars file)
- Promotes consistency while allowing flexibility  

## Advanced Patterns Demonstrated

### 1. Conditional Resources
```hcl
count = var.environment == "prod" ? 1 : 0
```
Deploy resources only in specific environments

### 2. Dynamic Resource Creation
```hcl
for_each = local.subnets
```
Create resources based on map/list

### 3. Conditional Logic
```hcl
account_replication_type = var.environment == "prod" ? "GRS" : "LRS"
```
Different settings per environment

### 4. CIDR Calculation
```hcl
cidrsubnet(var.vnet_address_space, 8, idx)
```
Automatic subnet calculation

### 5. Tag Merging
```hcl
merge(var.tags, local.default_tags)
```
Combine multiple tag sources

## Cleanup

### Delete Dev Environment
```bash
terraform init -backend-config=backend-dev.hcl -reconfigure
terraform destroy -var-file=dev.tfvars
```

### Delete Production Environment
```bash
terraform init -backend-config=backend-prod.hcl -reconfigure
terraform destroy -var-file=prod.tfvars
```

## Next Demo
Demo 5 will show how to use custom modules to organize and reuse Terraform code.
