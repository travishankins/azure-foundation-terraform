# 🎯 Quick Demo Reference Card

## Before You Start
1. Run Demo 2 first → Get storage account name
2. Update all `backend-*.hcl` files with storage account name
3. Have Azure Portal open
4. Review README instructor dialogue

---

## Demo Flow Narrative

### Demo 1 (10 min): "Let's Start Simple"
**Key Message**: "This is the core Terraform workflow. Notice the state file on my laptop - that's a problem."

**Commands**:
```bash
cd demo-01-local-state
terraform init
terraform plan
terraform apply  # type: yes
cat terraform.tfstate  # show the state file
terraform destroy  # type: yes
```

**👀 SHOW**: Local state file exists, portal resource

---

### Demo 2 (15 min): "Enabling Team Collaboration"  
**Key Message**: "We're building the infrastructure to hold our state files. This enables teams."

**Commands**:
```bash
cd demo-02-remote-state-setup
terraform init
terraform apply  # type: yes
terraform output backend_config  # SAVE THIS!
```

**👀 SHOW**: Storage account in portal, container, versioning enabled

⚠️ **IMPORTANT**: Save the storage account name!

---

### Demo 3 (15 min): "Real Infrastructure, Remote State"
**Key Message**: "Same Terraform, but notice - NO local state file. It's in Azure."

**BEFORE**: Update `backend.hcl` with storage account name

**Commands**:
```bash
cd demo-03-vnet-remote-state
terraform init -backend-config=backend.hcl
terraform plan
terraform apply  # type: yes
ls -la  # NO terraform.tfstate!
```

**👀 SHOW**: 
- Portal: State file in storage container
- Portal: VNet, subnets, NSG deployed
- Local: NO state file

**OPTIONAL - State Locking Demo**:
Terminal 1: `terraform apply` (don't confirm)
Terminal 2: `terraform plan` (shows locked!)

---

### Demo 4 (20 min): "One Code, Multiple Environments"
**Key Message**: "SAME code deploys dev and prod differently. That's the power of Terraform."

**BEFORE**: Update all `backend-*.hcl` files

**Commands - DEV**:
```bash
cd demo-04-advanced-features
cat dev.tfvars  # show config
cat locals.tf   # show the magic
terraform init -backend-config=backend-dev.hcl
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars  # type: yes
terraform output deployment_summary
terraform output environment_config  # B2s, no backup
```

**Commands - PROD** (optional but powerful):
```bash
cat prod.tfvars  # compare to dev!
terraform init -backend-config=backend-prod.hcl -reconfigure
terraform plan -var-file=prod.tfvars
terraform apply -var-file=prod.tfvars  # type: yes
terraform output deployment_summary
terraform output environment_config  # D4s_v3, backup enabled!
```

**👀 SHOW**:
- Different tfvars files
- `locals.tf` with environment_config map
- Portal: Different resources (dev has 2 subnets, prod has 4)
- Portal: Prod has Log Analytics Workspace, dev doesn't
- Output: Different VM sizes, backup settings

**OPTIONAL - Terraform Console**:
```bash
terraform console -var-file=prod.tfvars
> local.resource_prefix
> local.is_production
> local.current_config
> exit
```

---

### Demo 5 (20 min): "Building with Modules"
**Key Message**: "Instead of 500 lines of code, we have 150. Same infrastructure, much cleaner."

**BEFORE**: Update backend in `main.tf`

**Commands**:
```bash
cd demo-05-custom-modules
ls -la ../modules/  # show modules available
cat main.tf  # show clean module calls
terraform init  # watch module initialization
terraform plan  # see module.name.resource pattern
terraform apply  # type: yes
terraform state list  # all prefixed with module.
terraform output deployment_summary
```

**👀 SHOW**:
- Module directory structure
- Clean main.tf vs raw resources
- Module initialization messages
- Portal: Complex infrastructure from simple code
- Consistent naming and tags (from modules)

---

### Demo 6 (15 min): "Microsoft-Built Modules"
**Key Message**: "You CAN build everything yourself, or use Microsoft's verified modules. Let me show you where to find them."

**Commands**:
```bash
cd demo-06-azure-verified-modules
# Update backend in main.tf
terraform init
terraform apply  # type: yes
terraform output deployment_summary
```

**👀 SHOW - IN BROWSER**:
1. Open https://registry.terraform.io/namespaces/Azure
2. Search for "avm-res-network"
3. Click on VNet module
4. Show: Documentation, Inputs, Outputs, Examples tabs
5. Show: Version history, download count
6. Show: Verified badge

**💬 SAY**: 
"This demo uses standard resources for reliability, but in production you'd use these AVM modules. They have Microsoft's best practices, security configs, and regular updates built in. You get comprehensive features without writing complex code."

---

## Quick Troubleshooting

### State is locked?
```bash
terraform force-unlock <LOCK_ID>  # use carefully!
```

### Need to change backend?
```bash
terraform init -reconfigure
```

### Module not found?
```bash
terraform init -upgrade
```

### Azure auth issues?
```bash
az login
az account show
```

---

## Key Talking Points by Demo

| Demo | Main Point |
|------|------------|
| 1 | Local state = simple but not team-ready |
| 2 | Remote state = collaboration + locking |
| 3 | Remote state in action, no local file |
| 4 | Same code → different environments |
| 5 | Modules = reusability + standardization |
| 6 | AVM = Microsoft best practices ready-made |

---

## Cleanup Commands

```bash
# Demos 1-2 (local state)
cd demo-0X-name && terraform destroy -auto-approve

# Demos 3-6 (remote state)
cd demo-0X-name && terraform init -backend-config=backend.hcl && terraform destroy -auto-approve
```

---

## Demo Combinations

**30 min**: 1 → 2 → 3  
**45 min**: 2 → 4 → 5  
**60 min**: 1 → 2 → 3 → 4  
**90 min**: All 6

---

## Emergency Shortcuts

### If short on time:
- **Demo 1**: Skip destroy, just show state file
- **Demo 3**: Skip state locking test
- **Demo 4**: Do dev OR prod, not both
- **Demo 5**: Skip state inspection
- **Demo 6**: Just show registry, skip deployment

### If something breaks:
- Have Azure Portal ready to show existing resources
- Fall back to code walkthrough of main.tf
- Every demo has comprehensive README to read from

---

## Success Metrics

You'll know the demo went well if:
✅ Audience sees state file transition (local → remote)  
✅ "Aha!" moment on Demo 4 (same code, different envs)  
✅ Appreciation for modules reducing complexity  
✅ Questions about using this in their work  

---

**Remember**: Follow the 💬 INSTRUCTOR SAYS sections in each README!

Good luck! 🚀
