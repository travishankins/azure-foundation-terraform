# Demo 6: Azure Verified Modules (Reference)

## Overview
This demo explains **Azure Verified Modules (AVM)** - production-ready, Microsoft-endorsed Terraform modules. While this demo uses standard resources for simplicity, it demonstrates where and how to find Azure Verified Modules for production use.

## What are Azure Verified Modules (AVM)?

**💬 INSTRUCTOR INTRO:**
> "In the last demo, we built our own modules. That's great for organization-specific needs. But what if you could use modules that Microsoft has already built, tested, and maintains? That's Azure Verified Modules. Think of it like the difference between building your own libraries versus using NPM packages or PyPI packages - you CAN build everything yourself, but sometimes it's better to use what's already proven."

Azure Verified Modules are:
- ✅ **Microsoft Endorsed** - Official Microsoft modules
- ✅ **Production Ready** - Battle-tested and reliable
- ✅ **Best Practices** - Follow Azure CAF and Well-Architected Framework
- ✅ **Comprehensive** - Cover all Azure resources
- ✅ **Maintained** - Regular updates and security patches
- ✅ **Documented** - Extensive documentation and examples
- ✅ **Tested** - Automated testing and validation

## AVM vs Custom Modules

| Aspect | Custom Modules (Demo 5) | Azure Verified Modules (Demo 6) |
|--------|------------------------|----------------------------------|
| **Source** | Your organization | Microsoft + Community |
| **Maintenance** | You maintain | Microsoft maintains |
| **Updates** | Manual | Automatic via version |
| **Testing** | Your responsibility | Comprehensive CI/CD |
| **Documentation** | You document | Extensive docs |
| **Best Practices** | Your standards | Microsoft standards |
| **Support** | Internal | Community + MS |
| **Learning Curve** | Your patterns | Industry standard |

## When to Use Each?

### Use Custom Modules When:
- Organization-specific requirements
- Custom naming conventions
- Internal policies and standards
- Proprietary configurations
- Full control needed

### Use Azure Verified Modules When:
- Standard Azure resources
- Production deployments
- Following Microsoft best practices
- Reduced maintenance overhead
- Need regular security updates
- Enterprise compliance required

## Files
- `main.tf` - Uses AVM modules from Terraform Registry
- `outputs.tf` - Outputs from AVM modules

## Finding Azure Verified Modules

### Terraform Registry
Browse modules at: https://registry.terraform.io/

Search for: `Azure/avm-`

### Popular AVM Modules
- `Azure/avm-res-network-virtualnetwork/azurerm` - Virtual Networks
- `Azure/avm-res-storage-storageaccount/azurerm` - Storage Accounts
- `Azure/avm-res-keyvault-vault/azurerm` - Key Vaults
- `Azure/avm-res-compute-virtualmachine/azurerm` - Virtual Machines
- `Azure/avm-res-containerservice-managedcluster/azurerm` - AKS

### AVM Naming Convention
```
Azure/avm-{res|ptn}-{servicename}-{resourcetype}/azurerm
```
- `res` - Resource modules (single resource)
- `ptn` - Pattern modules (multiple resources)

## Demo Steps

**💬 INSTRUCTOR NOTE:**
> "This demo uses standard Terraform resources for reliability, but I'll show you WHERE to find Azure Verified Modules and HOW to evaluate them for your production use. AVM modules can have complex requirements and breaking changes, so understanding how to find and assess them is more valuable than forcing a demo that might break."

---

### 1. Browse the Terraform Registry
Visit: https://registry.terraform.io/namespaces/Azure

**💬 INSTRUCTOR SAYS:**
> "Let me open the Terraform Registry in my browser. I'm searching for 'Azure AVM'. Look at all these modules - virtual networks, storage accounts, Key Vaults, AKS clusters. Each has the Microsoft verified badge. Click on any one and you get comprehensive documentation, usage examples, input/output lists, and version history."

**What to show**:
- Official Azure modules
- Verified badge
- Documentation tabs
- Usage examples
- Version history
- Download statistics

**👀 POINT OUT:**
- Verified badge = Microsoft endorsed
- Download counts show popularity
- Recent updates = actively maintained
- Examples tab has ready-to-use code

---

### 2. Review Module Documentation
Look at a VNet module:
```
https://registry.terraform.io/modules/Azure/avm-res-network-virtualnetwork/azurerm/latest
```

**💬 INSTRUCTOR SAYS:**
> "Let's look at the VNet module documentation. See the README? It explains what the module does. Inputs tab shows every variable - required ones, optional ones, defaults. Outputs tab shows what values you get back. Resources tab shows what Azure resources it creates. Dependencies tab shows other modules it needs. This is enterprise-grade documentation."

**What to highlight**:
- Required vs optional inputs
- Default values
- Output values available
- Submodules
- Version requirements
- Examples

**👀 POINT OUT:**
- Complete API documentation
- Type constraints shown
- Validation rules explained
- Examples copy-pasteable

---

### 3. Understand the Tradeoffs

**💬 INSTRUCTOR SAYS:**
> "Here's the honest truth about AVM modules: they're incredibly powerful and comprehensive, but that means complexity. A simple VNet module might have 50+ input variables because it supports every Azure feature. For a demo or getting started, standard resources are simpler. For production with enterprise requirements, AVM modules give you everything you need."

**AVM vs Custom Modules Comparison:**

**Use Custom Modules (Demo 5) When:**
> "Use custom modules when you have organization-specific needs, custom naming conventions, or want full control. You maintain them, you update them, you own them."

**Use Azure Verified Modules When:**
> "Use AVM when you want Microsoft's best practices, need comprehensive feature support, want automatic security updates, or don't want to maintain module code. Let Microsoft do the heavy lifting."

---

### 4. Deploy the Demo Infrastructure
```bash
cd demo-06-azure-verified-modules
# Update backend config
terraform init
terraform plan
terraform apply
```

**💬 INSTRUCTOR SAYS:**
> "I'm deploying standard resources here to keep the demo simple and reliable. In production, you'd replace these with AVM module calls. The syntax would be similar - just change the source from a local path to the registry path, add version pinning, and adjust the input variables to match the module's API."

**What to show**:
- Standard resource deployment
- Clean, working code
- Same remote state patterns

---

### 5. Show How to Use AVM (Code Example)

**💬 INSTRUCTOR SAYS:**
> "Let me show you what using an AVM module would look like. Instead of this standard resource code, you'd have a module block."

Show this comparison:
```hcl
# Standard Resource (what we're using in demo)
resource "azurerm_virtual_network" "demo" {
  name                = "vnet-demo-06"
  resource_group_name = azurerm_resource_group.demo.name
  location            = "East US"
  address_space       = ["10.60.0.0/16"]
}

# Azure Verified Module (production approach)
module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.1.0"  # Pin to specific version
  
  name                = "vnet-production"
  resource_group_name = azurerm_resource_group.demo.name
  location            = "East US"
  address_space       = ["10.60.0.0/16"]
  
  # AVM modules support all Azure features
  enable_ddos_protection = true
  dns_servers           = ["10.0.0.4", "10.0.0.5"]
  # ... many more options available
}
```

**👀 POINT OUT:**
- Registry source vs local path
- Version pinning for stability
- More comprehensive options
- Microsoft best practices built-in

---

### 6. Demonstrate Module Search Strategy

**💬 INSTRUCTOR SAYS:**
> "Here's how I find the right module: I go to registry.terraform.io, search 'Azure AVM' plus the resource type. I look for the verified badge. I check recent updates - if it hasn't been updated in a year, I'm cautious. I review the download count - popular modules are usually well-tested. I read the examples tab to see if it matches my use case."

**Search Strategy:**
1. Go to https://registry.terraform.io/
2. Search: `Azure avm <resource-type>`
3. Filter by verified (checkmark icon)
4. Check recent updates (< 6 months ideal)
5. Review download count
6. Read documentation quality
7. Check examples

**👀 POINT OUT:**
- Multiple modules might exist for same resource
- Naming convention: `Azure/avm-res-<service>-<resource>/azurerm`
- Look for `res` (resource) or `ptn` (pattern) in name

---

### 7. View Deployment Outputs
```bash
terraform output
terraform output deployment_summary
```

**💬 INSTRUCTOR SAYS:**
> "Our deployment summary shows standard resources deployed successfully. In production, you'd see similar outputs but from AVM modules. The outputs would be richer - AVM modules typically provide more output values for integration with other systems."

**👀 POINT OUT:**
- Clean deployment
- Outputs work the same way
- Infrastructure is production-ready

## Key Points to Highlight

**💬 INSTRUCTOR WRAP-UP:**
> "Azure Verified Modules represent the future of enterprise Terraform on Azure. Microsoft is investing heavily in these - comprehensive modules for every Azure service, following CAF best practices, regularly updated. You've now seen the full spectrum: raw Terraform resources for learning, custom modules for organization-specific needs, and Azure Verified Modules for production deployments with Microsoft backing. Choose the right tool for the job - sometimes that's custom modules, sometimes it's AVM, often it's a combination."

### Benefits of Azure Verified Modules

#### 1. **Production Ready**
✅ Extensively tested by Microsoft and community  
✅ Used by Microsoft customers worldwide  
✅ Security best practices built-in  
✅ Compliance features included  

#### 2. **Reduced Maintenance**
✅ Microsoft maintains the modules  
✅ Regular updates and security patches  
✅ Bug fixes provided  
✅ Feature additions as Azure evolves  

#### 3. **Version Control**
```hcl
version = "~> 0.1"  # Allow patch updates (0.1.x)
version = "0.1.5"   # Pin exact version
version = ">= 0.1"  # Minimum version (risky)
```
✅ Semantic versioning  
✅ Controlled updates  
✅ Stability guarantees  

#### 4. **Comprehensive Documentation**
Every AVM module includes:
✅ README with examples  
✅ Input variable documentation  
✅ Output documentation  
✅ Submodule documentation  
✅ Migration guides  
✅ Change logs  

#### 5. **Community Support**
✅ GitHub issues for problems  
✅ Community discussions  
✅ Microsoft support available  
✅ Regular community contributions  

#### 6. **Standardization**
✅ Consistent naming across modules  
✅ Standard inputs/outputs pattern  
✅ Azure best practices embedded  
✅ CAF compliance built-in  

### Decision Matrix: When to Use What

| Scenario | Use This | Why |
|----------|----------|-----|
| **Learning Terraform** | Standard Resources | Understand fundamentals |
| **Quick Prototypes** | Standard Resources | Fast and simple |
| **Org-Specific Patterns** | Custom Modules | Full control of conventions |
| **Shared Team Standards** | Custom Modules | Enforce team practices |
| **Production Deployments** | Azure Verified Modules | Microsoft best practices |
| **Enterprise Compliance** | Azure Verified Modules | Built-in compliance features |
| **Minimize Maintenance** | Azure Verified Modules | Microsoft maintains for you |
| **Hybrid Approach** | Mix of All Three | Best of all worlds |

**Real-World Strategy:**
> "In production, I recommend wrapping AVM modules with thin custom modules. The AVM module handles Azure specifics, your wrapper adds organization conventions like tagging and naming. You get Microsoft's expertise plus your standards - best of both worlds."

### Finding the Right Module

**Quality Indicators:**
✅ Verified badge (Microsoft verified)  
✅ Recent updates (< 6 months)  
✅ Good documentation with examples  
✅ High download count  
✅ Active GitHub repository  
✅ Responsive to issues  

**Red Flags:**
⚠️ No updates in > 1 year  
⚠️ No examples in documentation  
⚠️ Many open issues with no responses  
⚠️ No version tags  
⚠️ Minimal documentation  

### AVM Module Lifecycle

```
Microsoft Releases → Terraform Registry → Your Code
                          ↓
                    Version Pinning
                          ↓
                   Controlled Updates
```

### Version Management

```hcl
# Recommended for production
module "storage" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "~> 0.1"  # Allows 0.1.x updates, not 0.2.x
}

# For testing latest features
module "storage" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = ">= 0.1"  # Allows any version >= 0.1
}

# For absolute stability
module "storage" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.1.5"  # Exact version only
}
```

## Advanced: Using AVM Submodules

Some AVM modules include submodules:
```hcl
module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.1"
  
  # Main VNet configuration
  name = "my-vnet"
  
  # Using submodule features
  enable_ddos_protection = true
  enable_vm_protection   = true
}
```

## Best Practices

### 1. Pin Versions
```hcl
version = "~> 0.1"  # Good - allows patch updates
version = ">= 0.1"  # Risky - could break
```

### 2. Review Changelogs
Before updating, review:
- GitHub releases
- CHANGELOG.md
- Breaking changes

### 3. Test Updates
```bash
# Create test environment
terraform workspace new test
terraform apply -var-file=test.tfvars

# If successful, update production
terraform workspace select prod
```

### 4. Use terraform.lock.hcl
```bash
# Commit this file to version control
git add .terraform.lock.hcl
```

## Finding the Right Module

### Search Strategy
1. Visit https://registry.terraform.io/
2. Search: `Azure avm <resource-type>`
3. Filter by:
   - Verified (checkmark icon)
   - Recent updates
   - Download count
   - Documentation quality

### Module Quality Indicators
✅ Verified badge (Microsoft verified)  
✅ Recent updates (< 6 months)  
✅ Good documentation  
✅ Examples included  
✅ High download count  
✅ Active GitHub repository  

## Comparison Summary

| Feature | Demo 5 (Custom) | Demo 6 (AVM) |
|---------|----------------|--------------|
| Module Source | Local filesystem | Terraform Registry |
| Maintenance | Your team | Microsoft |
| Updates | Manual | Version-controlled |
| Best Practices | Yours | Microsoft CAF |
| Documentation | Yours | Comprehensive |
| Testing | Yours | Automated CI/CD |
| Support | Internal | Community + MS |
| Customization | Full | Limited |

## When to Combine Both?

Ideal production setup:
```hcl
# Use AVM for standard resources
module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.1"
  # Standard VNet
}

# Use custom modules for org-specific needs
module "custom_monitoring" {
  source = "../modules/custom/monitoring"
  # Your custom monitoring setup
}

# Wrap AVM with custom module for standardization
module "standard_storage" {
  source = "../modules/wrappers/storage"  # Your wrapper
  # Calls AVM internally with your defaults
}
```

## Cleanup
```bash
terraform destroy
```

## Resources

### Azure Verified Modules
- Registry: https://registry.terraform.io/namespaces/Azure
- GitHub: https://github.com/Azure/terraform-azurerm-avm-*
- Documentation: https://azure.github.io/Azure-Verified-Modules/

### Learning Resources
- Azure CAF: https://docs.microsoft.com/azure/cloud-adoption-framework/
- Terraform Registry: https://registry.terraform.io/
- AVM Specifications: https://azure.github.io/Azure-Verified-Modules/specs/

## Conclusion

Azure Verified Modules provide:
- ✅ Production-ready code
- ✅ Microsoft best practices
- ✅ Reduced maintenance
- ✅ Regular updates
- ✅ Community support

Use them as a foundation and customize with your own modules where needed!
