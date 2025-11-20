# Demo 8: Terraform Workspaces

## Overview
This demo demonstrates **Terraform Workspaces** - a built-in feature for managing multiple environments with a single configuration and backend. Workspaces provide state isolation while using the same codebase.

**💬 INSTRUCTOR INTRO:**
> "We've seen environment management with separate state files in Demo 4. Now I'll show you Terraform Workspaces - an alternative approach. Instead of separate backend configs, you use one backend and Terraform creates isolated state files automatically. Think of it like Git branches - same repo, different branches. Same Terraform code, different workspaces. Each workspace is completely isolated, but management is simpler."

## 🎯 What This Demo Covers

- ✅ Creating and switching between Terraform workspaces
- ✅ Using `terraform.workspace` variable for dynamic configuration
- ✅ Workspace-specific resource naming and tagging
- ✅ Environment-based conditional resources
- ✅ Single backend, multiple isolated states
- ✅ Workspace comparison and management

## 📊 Workspaces vs Separate State Files

| Feature | Separate State Files (Demo 4) | Workspaces (Demo 8) |
|---------|-------------------------------|---------------------|
| **Backend Config** | Multiple files (backend-dev.hcl, backend-prod.hcl) | Single file (backend.hcl) |
| **State Files** | Manually named (demo04-dev.tfstate) | Automatic (env:/dev/demo08.tfstate) |
| **Switching** | `terraform init -reconfigure` | `terraform workspace select dev` |
| **List Environments** | Manual tracking | `terraform workspace list` |
| **Isolation** | Complete (different state keys) | Complete (different workspaces) |
| **Best For** | Different teams/projects | Same team, multiple environments |
| **Complexity** | More config files | Less config, more commands |

## 🏗️ Workspace Strategy

This demo uses 4 workspaces:
1. **default** - Default workspace (maps to dev)
2. **dev** - Development environment
3. **uat** - User acceptance testing
4. **prod** - Production environment

## Files
- `main.tf` - Workspace-aware configuration
- `outputs.tf` - Dynamic outputs based on workspace
- `backend.hcl` - Single backend configuration
- `README.md` - This file with instructor notes

## Demo Steps

**💬 INSTRUCTOR NOTE:**
> "Make sure you've completed Demo 2 for the remote state storage account. We'll use one backend configuration but create multiple isolated environments."

---

### Part 1: Understanding Workspaces

#### 1. Initialize Without Workspace (Default)
```bash
cd demo-08-workspaces

# Update backend.hcl with your storage account name first
terraform init -backend-config=backend.hcl
```

**💬 INSTRUCTOR SAYS:**
> "Initializing with a single backend config. Terraform starts in the 'default' workspace automatically. This is the workspace you're always in if you don't explicitly create others."

---

#### 2. Check Current Workspace
```bash
terraform workspace show
terraform workspace list
```

**💬 INSTRUCTOR SAYS:**
> "The 'workspace show' command tells us we're in 'default'. The 'list' command shows all workspaces - currently just default with an asterisk indicating it's active."

**What to show**:
```
* default
```

**👀 POINT OUT:**
- Asterisk (*) marks the active workspace
- Only default exists initially
- This is automatic, no configuration needed

---

### Part 2: Deploy to Default Workspace

#### 1. Plan in Default Workspace
```bash
terraform plan
```

**💬 INSTRUCTOR SAYS:**
> "Planning in the default workspace. Look at the resource names - they include 'default' in the name. The configuration is pulling from local.workspace_config['default'] in main.tf. Address space is 10.10.0.0/16, LRS storage, no monitoring. These are dev-level settings."

**What to show**:
- Resource names include "default"
- Address space: 10.10.0.0/16
- Storage: LRS
- No Log Analytics (monitoring disabled)
- NSG allows HTTP and SSH (dev settings)

**👀 POINT OUT:**
- terraform.workspace returns "default"
- All config driven by workspace name
- No separate tfvars file needed

---

#### 2. Apply Default Workspace
```bash
terraform apply
```

**💬 INSTRUCTOR SAYS:**
> "Applying to default workspace. Terraform creates these resources and stores the state in a workspace-specific location in the backend."

---

#### 3. View Outputs
```bash
terraform output current_workspace
terraform output workspace_configuration
terraform output deployment_summary
```

**💬 INSTRUCTOR SAYS:**
> "The outputs show we're in 'default' workspace with dev-level configurations. Instance count is 1, basic SKU, backups disabled, monitoring disabled."

**What to show**:
- current_workspace = "default"
- Configuration matches default/dev
- Deployment summary shows all settings

---

### Part 3: Create and Switch to Dev Workspace

#### 1. Create Dev Workspace
```bash
terraform workspace new dev
```

**💬 INSTRUCTOR SAYS:**
> "Creating a new workspace called 'dev' and Terraform automatically switches to it. This is like creating a new Git branch and checking it out. The workspace is empty - no state yet."

**What to show**:
```
Created and switched to workspace "dev"!
```

**👀 POINT OUT:**
- Workspace created instantly
- Automatically switched
- Previous workspace (default) still exists

---

#### 2. List Workspaces
```bash
terraform workspace list
```

**💬 INSTRUCTOR SAYS:**
> "Now we have two workspaces. The asterisk moved to 'dev' - that's our active workspace."

**What to show**:
```
  default
* dev
```

---

#### 3. Plan in Dev Workspace
```bash
terraform plan
```

**💬 INSTRUCTOR SAYS:**
> "Look at this plan carefully. Even though we're using the same main.tf, terraform.workspace now returns 'dev', so the configuration pulls from local.workspace_config['dev']. Resource names have 'dev' instead of 'default', but the configuration is identical because dev and default use the same settings in our locals."

**What to show**:
- Resource names with "dev"
- Same config as default (both dev-level)
- Clean plan (no existing state)

**👀 POINT OUT:**
- New state (no resources exist yet)
- Isolated from default workspace
- Same code, different workspace

---

#### 4. Deploy Dev Workspace
```bash
terraform apply
```

**💬 INSTRUCTOR SAYS:**
> "Applying to dev workspace. These resources are completely separate from the default workspace. We now have two identical environments running side by side."

---

### Part 4: Create UAT Workspace (Different Config!)

#### 1. Create and Switch to UAT
```bash
terraform workspace new uat
```

**💬 INSTRUCTOR SAYS:**
> "Creating UAT workspace. This one will be different - it uses different settings in our locals."

---

#### 2. Plan UAT Workspace
```bash
terraform plan
```

**💬 INSTRUCTOR SAYS:**
> "This is where it gets interesting. terraform.workspace is 'uat' now, so we get local.workspace_config['uat']. Look at the differences: address space is 10.20.0.0/16 instead of 10.10, storage is GRS instead of LRS, instance count is 2 instead of 1, and most importantly - Log Analytics workspace IS being created! The config enables monitoring for UAT. All this from the same code, just a different workspace."

**What to show**:
- Resource names with "uat"
- Location: Central US (different from dev's East US)
- Address space: 10.20.0.0/16 (different network)
- Storage: GRS (geo-redundant)
- Log Analytics: Creating (count = 1)
- NSG: No SSH allowed
- Backups: Enabled

**👀 POINT OUT:**
- Same code, dramatically different result
- Conditional resource (Log Analytics) appears
- More restrictive security
- Higher tier settings

---

#### 3. Deploy UAT
```bash
terraform apply
```

**💬 INSTRUCTOR SAYS:**
> "Deploying UAT with production-like settings. This workspace is isolated from dev and default."

---

#### 4. View UAT Outputs
```bash
terraform output workspace_configuration
terraform output deployment_summary
```

**💬 INSTRUCTOR SAYS:**
> "UAT configuration shows: GRS storage, monitoring enabled, 2 instances, Standard SKU. These are stepping-stone settings between dev and prod."

---

### Part 5: Create Production Workspace

#### 1. Create Prod Workspace
```bash
terraform workspace new prod
```

**💬 INSTRUCTOR SAYS:**
> "Creating prod workspace. This gets the most robust configuration."

---

#### 2. Review Prod Configuration
```bash
terraform plan
```

**💬 INSTRUCTOR SAYS:**
> "Production plan is the most locked down. Address space 10.30.0.0/16, location West US, GZRS storage (geo-zone-redundant - highest availability), 3 instances, Log Analytics with 90-day retention, Premium SKU. NSG is most restrictive - HTTPS only, no HTTP, no SSH. This is production-grade infrastructure from the same code we used for dev."

**What to show**:
- Names with "prod"
- Location: West US
- Address space: 10.30.0.0/16
- Storage: GZRS (highest tier)
- Log Analytics: 90-day retention
- Instance count: 3
- NSG: Only HTTPS (no HTTP, no SSH)
- Backups: 30 days
- Premium SKU

**👀 POINT OUT:**
- Most restrictive security
- Highest availability settings
- Longest retention
- All automatic from workspace name

---

#### 3. Deploy Production
```bash
terraform apply
```

**💬 INSTRUCTOR SAYS:**
> "Deploying production. Same code, fourth time, completely different result. That's the power of workspaces with dynamic configuration."

---

### Part 6: Demonstrate Workspace Management

#### 1. List All Workspaces
```bash
terraform workspace list
```

**💬 INSTRUCTOR SAYS:**
> "We now have four workspaces: default, dev, uat, and prod. The asterisk shows we're currently in prod."

**What to show**:
```
  default
  dev
  uat
* prod
```

---

#### 2. Switch Between Workspaces
```bash
terraform workspace select dev
terraform output deployment_summary

terraform workspace select uat
terraform output deployment_summary

terraform workspace select prod
terraform output deployment_summary
```

**💬 INSTRUCTOR SAYS:**
> "Switching is instant. No re-initialization, no backend reconfig. Just 'select' and Terraform loads that workspace's state. Dev shows LRS storage, UAT shows GRS, Prod shows GZRS. Same command, different results based on workspace."

**What to show**:
- Fast switching
- Different outputs per workspace
- No initialization needed

**👀 POINT OUT:**
- Instant switching
- Each workspace maintains its own state
- No backend reconfiguration required

---

#### 3. View All Workspace Configurations
```bash
terraform workspace select dev
terraform output workspace_comparison
```

**💬 INSTRUCTOR SAYS:**
> "The workspace_comparison output shows all four workspace configs side by side. See how they progress from Basic/LRS in default and dev, to Standard/GRS in UAT, to Premium/GZRS in prod. This is environment progression done right."

**What to show**:
- Side-by-side comparison
- Clear progression of settings
- Different locations, address spaces
- Monitoring progression

---

### Part 7: Check State Files in Azure

#### 1. Navigate to Storage Account in Portal
Go to: Storage Account → Containers → tfstate

**💬 INSTRUCTOR SAYS:**
> "In the Azure Portal, look at the tfstate container. You don't see four separate files named demo08-dev.tfstate, demo08-uat.tfstate. Instead, Terraform stores workspaces in a special folder structure. The state files are at: env:/default/demo08-workspaces.tfstate, env:/dev/demo08-workspaces.tfstate, env:/uat/demo08-workspaces.tfstate, env:/prod/demo08-workspaces.tfstate. One key, multiple workspace-prefixed paths. That's how Terraform isolates them."

**What to show**:
- Workspace state file structure
- env: prefix for workspaces
- Isolation within one backend

**👀 POINT OUT:**
- Not separate blob files
- Folder-like structure with env:/ prefix
- Same base key, different workspace prefixes

---

#### 2. Show Local Terraform Directory
```bash
ls -la .terraform/
cat .terraform/environment
```

**💬 INSTRUCTOR SAYS:**
> "Locally, Terraform tracks the current workspace in .terraform/environment file. It just contains the workspace name. That's how Terraform remembers which workspace you're in."

**What to show**:
- `.terraform/environment` file
- Contains current workspace name

---

### Part 8: Demonstrate Isolation

#### 1. Modify Dev, Check Prod Unchanged
```bash
terraform workspace select dev
terraform destroy -auto-approve

terraform workspace select prod
terraform state list
```

**💬 INSTRUCTOR SAYS:**
> "I'm destroying the dev workspace resources completely. Now I switch to prod and run state list - all prod resources still there, untouched. Complete isolation. Destroying one workspace doesn't affect others."

**👀 POINT OUT:**
- Actions in one workspace don't affect others
- State isolation is complete
- Same as separate backends, simpler to manage

---

#### 2. Cannot Delete Workspace With Resources
```bash
terraform workspace select default
terraform workspace delete dev
```

**💬 INSTRUCTOR SAYS:**
> "Terraform won't let you delete a workspace with resources. That's a safety feature. You must destroy resources first, then delete the workspace."

**What to show**:
- Error message about non-empty workspace
- Must destroy resources first

---

## Key Points to Highlight

**💬 INSTRUCTOR WRAP-UP:**
> "Workspaces are powerful for multi-environment management. One codebase, one backend configuration, multiple isolated environments. You switch with a simple command instead of re-initializing with different backend configs. They're perfect when one team manages all environments. However, if different teams own different environments, separate state files (Demo 4) give clearer ownership boundaries. Choose based on your organization: one team = workspaces, multiple teams = separate states. Both approaches are valid - workspaces are just more convenient for the single-team case."

### ✅ Workspace Benefits

#### 1. **Simplified Configuration**
✅ One backend config file, not three  
✅ No backend-specific HCL files  
✅ Less configuration to maintain  
✅ Easier onboarding (fewer files to understand)  

#### 2. **Easy Switching**
✅ `terraform workspace select` vs `terraform init -reconfigure`  
✅ Instant switching (no re-initialization)  
✅ Built-in listing (`workspace list`)  
✅ Clear indication of current workspace  

#### 3. **Dynamic Configuration**
✅ Use `terraform.workspace` in code  
✅ Lookup tables for workspace-specific settings  
✅ Conditional resources based on workspace  
✅ One codebase, multiple configurations  

#### 4. **State Isolation**
✅ Complete state separation  
✅ Automatic state file organization  
✅ No risk of state collisions  
✅ Safe parallel deployments  

### ⚠️ Workspace Considerations

#### When to Use Workspaces:
✅ Same team manages all environments  
✅ Environments have similar topology  
✅ Want simplified state management  
✅ Frequent switching between environments  
✅ Development/testing workflows  

#### When NOT to Use Workspaces:
❌ Different teams own different environments  
❌ Environments have radically different architectures  
❌ Need separate access controls per environment  
❌ Compliance requires separate state storage  
❌ Multi-region deployments with different backends  

### Workspace Commands Reference

```bash
# List workspaces
terraform workspace list

# Show current workspace
terraform workspace show

# Create new workspace
terraform workspace new <name>

# Switch to existing workspace
terraform workspace select <name>

# Delete workspace (must be empty)
terraform workspace delete <name>

# Create and switch in one command
terraform workspace new <name>
```

### Dynamic Configuration Pattern

```hcl
locals {
  workspace = terraform.workspace
  
  config = {
    dev  = { /* dev settings */ }
    uat  = { /* uat settings */ }
    prod = { /* prod settings */ }
  }
  
  current = local.config[local.workspace]
}

resource "azurerm_resource" "example" {
  name = "resource-${local.workspace}"
  # Use local.current.* for workspace-specific values
}
```

### Comparison with Demo 4

| Aspect | Demo 4 (Separate States) | Demo 8 (Workspaces) |
|--------|--------------------------|---------------------|
| Files | main.tf, backend-dev.hcl, backend-uat.hcl, backend-prod.hcl | main.tf, backend.hcl |
| Switching | `terraform init -backend-config=backend-prod.hcl -reconfigure` | `terraform workspace select prod` |
| Variables | dev.tfvars, uat.tfvars, prod.tfvars | Embedded in locals with workspace lookup |
| State Keys | demo04-dev.tfstate, demo04-uat.tfstate, demo04-prod.tfstate | env:/dev/demo08.tfstate, env:/uat/demo08.tfstate, env:/prod/demo08.tfstate |
| Complexity | More files | Fewer files, more Terraform commands |
| Team Model | Multi-team (separate ownership) | Single team (shared ownership) |
| Flexibility | Different backends per environment possible | All environments in same backend |

**Real-World Usage:**
> "In production, I see both patterns. Startups and small teams love workspaces for simplicity. Enterprises with separate dev/prod teams prefer separate states for clear ownership boundaries. Some organizations use hybrid: workspaces for dev/uat (owned by dev team), separate state for prod (owned by ops team). Know both patterns and choose the right tool for your situation."

## Best Practices

### 1. **Default Workspace**
- Never use default for production
- Use it as an alias for dev or don't use it at all
- Document which workspace maps to which environment

### 2. **Naming Convention**
Always include workspace in resource names:
```hcl
name = "${var.prefix}-${terraform.workspace}-${random_string.suffix.result}"
```

### 3. **Workspace Configuration**
Store all workspace configs in locals:
```hcl
locals {
  workspace_config = {
    dev  = { ... }
    prod = { ... }
  }
  config = local.workspace_config[terraform.workspace]
}
```

### 4. **Safety Checks**
Validate workspace before destructive actions:
```hcl
# In scripts
if [ "$TF_WORKSPACE" == "prod" ]; then
  read -p "Are you sure you want to modify PRODUCTION? " -n 1 -r
fi
```

### 5. **CI/CD Integration**
```bash
# In pipelines
export TF_WORKSPACE=dev
terraform workspace select $TF_WORKSPACE || terraform workspace new $TF_WORKSPACE
terraform plan
```

## Cleanup

### Destroy All Workspaces
```bash
# Destroy each workspace
terraform workspace select default
terraform destroy

terraform workspace select dev  
terraform destroy

terraform workspace select uat
terraform destroy

terraform workspace select prod
terraform destroy

# Delete empty workspaces (optional)
terraform workspace select default
terraform workspace delete dev
terraform workspace delete uat
terraform workspace delete prod
```

**💬 INSTRUCTOR SAYS:**
> "Destroying in reverse order - prod first since it's most critical to verify. Each workspace must be destroyed separately. The workspaces themselves persist even after destroying resources - they're just empty."

## Related Demos

- **Demo 4**: Alternative approach with separate state files
- **Demo 7**: AVM with environment customization (works great with workspaces!)
- **Foundation**: Could be deployed with workspaces for multi-environment

## Additional Resources

- [Terraform Workspaces Documentation](https://www.terraform.io/docs/language/state/workspaces.html)
- [When to Use Workspaces](https://www.terraform.io/docs/cloud/workspaces/index.html)
- [Workspace Best Practices](https://www.terraform.io/docs/language/state/workspaces.html#when-to-use-multiple-workspaces)
