# Terraform Demo Series - Complete Guide

## 🎯 Overview

This repository contains **6 progressive Terraform demos** designed to showcase Azure infrastructure deployment from basic concepts to advanced patterns. Perfect for demonstrations, training, and learning Terraform.

## 📚 Demo Structure

Each demo builds upon the previous ones, introducing new concepts progressively:

```
📦 Terraform Demos
├── 🔰 Demo 1: Local State        → Basics
├── 📦 Demo 2: Remote State       → Team Collaboration  
├── 🌐 Demo 3: VNet Deployment    → Using Remote State
├── ⚙️  Demo 4: Advanced Features  → Locals, Outputs, Tfvars
├── 🧩 Demo 5: Custom Modules     → Code Reusability
└── ✅ Demo 6: Azure Verified     → Production-Ready Modules
```

---

## 🚀 Demo Progression

### Demo 1: Resource Group with Local State
**Duration: 5-10 minutes**

**What you'll demonstrate:**
- Basic Terraform workflow (init, plan, apply, destroy)
- Local state file creation and inspection
- Simple resource deployment
- Terraform outputs

**Key Learning Points:**
- ✅ Terraform basics
- ⚠️ Local state limitations

**Files:** `demo-01-local-state/`

---

### Demo 2: Storage Account for Remote State
**Duration: 10-15 minutes**

**What you'll demonstrate:**
- Creating Azure Storage for remote state
- Security best practices (TLS, versioning, private access)
- Backend configuration options
- Preparing infrastructure for team collaboration

**Key Learning Points:**
- ✅ Why remote state matters
- ✅ State locking
- ✅ Team collaboration enablement

**Files:** `demo-02-remote-state-setup/`

**Prerequisites:** Azure subscription access

---

### Demo 3: Virtual Network with Remote State
**Duration: 10-15 minutes**

**What you'll demonstrate:**
- Using remote state backend
- Deploying complex networking (VNet, subnets, NSGs)
- State locking in action
- Backend configuration patterns

**Key Learning Points:**
- ✅ Remote state in practice
- ✅ Team collaboration patterns
- ✅ State isolation

**Files:** `demo-03-vnet-remote-state/`

**Prerequisites:** Complete Demo 2 first

---

### Demo 4: Advanced Terraform Features
**Duration: 15-20 minutes**

**What you'll demonstrate:**
- Local values and computed properties
- Complex outputs
- Environment-specific tfvars files
- Multiple state files per environment
- Conditional resource deployment
- Dynamic resource creation (for_each)
- CIDR subnet calculation

**Key Learning Points:**
- ✅ DRY principles with locals
- ✅ Environment separation
- ✅ Advanced Terraform patterns
- ✅ Conditional logic

**Files:** `demo-04-advanced-features/`

**Prerequisites:** Complete Demo 2 for remote state backend

---

### Demo 5: Using Custom Modules
**Duration: 15-20 minutes**

**What you'll demonstrate:**
- Creating reusable modules
- Module inputs and outputs
- Module composition and dependencies
- Abstraction and encapsulation
- Organizational standards enforcement

**Key Learning Points:**
- ✅ Code reusability
- ✅ Module best practices
- ✅ Dependency management
- ✅ Standardization

**Files:** `demo-05-custom-modules/`

**Uses Modules From:** `modules/` directory

**Prerequisites:** Complete Demo 2 for remote state backend

---

### Demo 6: Azure Verified Modules
**Duration: 15-20 minutes**

**What you'll demonstrate:**
- Using official Azure Verified Modules
- Terraform Registry integration
- Version management
- Production-ready patterns
- Microsoft best practices

**Key Learning Points:**
- ✅ Azure Verified Modules (AVM)
- ✅ Module versioning
- ✅ Registry usage
- ✅ Production deployment patterns

**Files:** `demo-06-azure-verified-modules/`

**Prerequisites:** Complete Demo 2 for remote state backend

---

## 🎬 Complete Demo Flow

### Option 1: Full Progressive Demo (60-90 minutes)
Do all demos in sequence to show complete Terraform journey:
```
Demo 1 → Demo 2 → Demo 3 → Demo 4 → Demo 5 → Demo 6
```

### Option 2: Focused Demos (20-30 minutes each)

**Beginner Track:**
- Demo 1: Basics
- Demo 2: Remote State
- Demo 3: Real Infrastructure

**Intermediate Track:**
- Demo 4: Advanced Features
- Demo 5: Custom Modules

**Advanced Track:**
- Demo 5: Custom Modules
- Demo 6: Production Patterns

---

## ⚙️ Prerequisites

### Required Tools
- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)
- Azure subscription with appropriate permissions

### Azure Permissions Needed
- Create Resource Groups
- Create Virtual Networks
- Create Storage Accounts
- Create Key Vaults
- Create Network Security Groups

### Setup Steps

#### 1. Install Tools
```bash
# Install Terraform
brew install terraform  # macOS
# or download from https://www.terraform.io/downloads

# Install Azure CLI
brew install azure-cli  # macOS
# or download from https://docs.microsoft.com/cli/azure/install-azure-cli
```

#### 2. Azure Login
```bash
az login
az account set --subscription "your-subscription-id"
az account show
```

#### 3. Clone Repository
```bash
git clone <repository-url>
cd azure-foundation-terraform
```

---

## 🎯 Quick Start Guide

### Running Demo 1 (No Prerequisites)
```bash
cd demo-01-local-state
terraform init
terraform plan
terraform apply
# Explore the state file
cat terraform.tfstate
# Cleanup
terraform destroy
```

### Running Demos 2-6 (Requires Demo 2)
```bash
# First, setup remote state (Demo 2)
cd demo-02-remote-state-setup
terraform init
terraform apply
# Note the storage account name from outputs
terraform output storage_account_name

# Then run any other demo
cd ../demo-03-vnet-remote-state  # or demo-04, demo-05, demo-06
# Update backend configuration with storage account name
terraform init -backend-config=backend.hcl  # if using .hcl file
terraform plan
terraform apply
terraform destroy
```

---

## 📊 Concept Comparison Matrix

| Concept | Demo 1 | Demo 2 | Demo 3 | Demo 4 | Demo 5 | Demo 6 |
|---------|--------|--------|--------|--------|--------|--------|
| **Local State** | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Remote State** | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **State Locking** | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Basic Resources** | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| **Locals** | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| **Tfvars** | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| **Conditionals** | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| **Custom Modules** | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |
| **Registry Modules** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |

---

## 🎤 Presentation Tips

### Demo 1
**Focus:** "This is how simple Terraform can be"
- Show the terraform.tfstate file
- Emphasize limitations for team use

### Demo 2
**Focus:** "Enabling team collaboration"
- Show Azure Storage account in portal
- Explain state locking importance
- Show blob versioning feature

### Demo 3
**Focus:** "Real infrastructure using remote state"
- Show state file in Azure Storage
- Demonstrate state locking (try to run plan twice)
- Compare to Demo 1 (no local state file)

### Demo 4
**Focus:** "Production-ready patterns"
- Show same code deploying different environments
- Demonstrate locals simplifying configuration
- Show conditional resources (Log Analytics in prod only)
- Compare dev.tfvars vs prod.tfvars outputs

### Demo 5
**Focus:** "Building reusable components"
- Show module source code
- Demonstrate simple inputs creating complex infrastructure
- Show how same module used across projects
- Compare to non-module approach

### Demo 6
**Focus:** "Leveraging Microsoft best practices"
- Browse Terraform Registry live
- Show module documentation
- Compare custom vs verified modules
- Discuss version management

---

## 📝 Common Demo Scenarios

### Scenario 1: Introduction to Terraform (30 min)
```
Demo 1 → Demo 2 → Demo 3
```
**Narrative:** "From local experimentation to team collaboration"

### Scenario 2: Advanced Terraform (30 min)
```
Demo 4 → Demo 5
```
**Narrative:** "Production patterns and code organization"

### Scenario 3: Enterprise Terraform (45 min)
```
Demo 2 → Demo 4 → Demo 5 → Demo 6
```
**Narrative:** "Complete enterprise deployment pipeline"

### Scenario 4: Modules Deep Dive (30 min)
```
Demo 5 → Demo 6
```
**Narrative:** "Custom vs verified modules - when to use each"

---

## 🔧 Troubleshooting

### Issue: Backend Already Initialized
```bash
terraform init -reconfigure
```

### Issue: State Locked
```bash
# If state is legitimately locked, wait
# If lock is stale, force unlock (use carefully!)
terraform force-unlock <lock-id>
```

### Issue: Module Not Found
```bash
# Ensure you're in correct directory
# Re-initialize to download modules
terraform init -upgrade
```

### Issue: Azure Authentication
```bash
# Re-authenticate
az logout
az login
az account show
```

---

## 🧹 Cleanup After Demos

### Quick Cleanup (Keep State Storage)
```bash
cd demo-01-local-state && terraform destroy -auto-approve; cd ..
cd demo-03-vnet-remote-state && terraform init -backend-config=backend.hcl && terraform destroy -auto-approve; cd ..
cd demo-04-advanced-features && terraform init -backend-config=backend-dev.hcl -reconfigure && terraform destroy -var-file=dev.tfvars -auto-approve; cd ..
cd demo-05-custom-modules && terraform destroy -auto-approve; cd ..
cd demo-06-azure-verified-modules && terraform destroy -auto-approve; cd ..
```

### Complete Cleanup (Including State Storage)
```bash
# First destroy all demos (as above)
# Then destroy state storage
cd demo-02-remote-state-setup
terraform destroy -auto-approve
```

### Verify in Azure Portal
Check that all resource groups are deleted:
```bash
az group list --query "[?starts_with(name, 'rg-demo')].name" -o table
```

---

## 📖 Additional Resources

### Terraform Documentation
- [Terraform Docs](https://www.terraform.io/docs)
- [Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

### Azure Documentation
- [Azure CAF](https://docs.microsoft.com/azure/cloud-adoption-framework/)
- [Azure Landing Zones](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/)
- [Azure Naming Conventions](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging)

### Azure Verified Modules
- [AVM Registry](https://registry.terraform.io/namespaces/Azure)
- [AVM GitHub](https://github.com/Azure/terraform-azurerm-avm)
- [AVM Specifications](https://azure.github.io/Azure-Verified-Modules/)

---

## 🎓 Learning Path

### Beginner
1. Complete Demo 1 - Understand basics
2. Complete Demo 2 - Setup collaboration
3. Complete Demo 3 - Deploy real infrastructure
4. Read each demo's README thoroughly

### Intermediate
1. Complete Demo 4 - Master advanced features
2. Experiment with different tfvars configurations
3. Complete Demo 5 - Learn modules
4. Create your own simple module

### Advanced
1. Complete Demo 6 - Production patterns
2. Combine custom and verified modules
3. Implement CI/CD pipeline
4. Add automated testing

---

## 💡 Demo Customization Tips

### Changing Regions
Update `location` variable in each demo:
```hcl
variable "location" {
  default = "West US"  # Change as needed
}
```

### Changing Naming Conventions
Update resource names in each demo to match your standards.

### Adding More Environments
In Demo 4, create additional tfvars files:
```bash
cp demo-04-advanced-features/dev.tfvars demo-04-advanced-features/staging.tfvars
# Edit staging.tfvars
```

### Using Different Modules
In Demo 5, swap out modules or add new ones:
```hcl
module "cosmos_db" {
  source = "../modules/data/cosmos-db"
  # ...
}
```

---

## 🏆 Success Metrics

After completing these demos, you should be able to:
- ✅ Explain Terraform workflow (init, plan, apply, destroy)
- ✅ Understand local vs remote state
- ✅ Configure remote state backends
- ✅ Use locals, outputs, and variables effectively
- ✅ Create and use custom modules
- ✅ Use Azure Verified Modules
- ✅ Manage multiple environments
- ✅ Implement Terraform best practices

---

## 🤝 Contributing

Improvements welcome! Consider:
- Additional demo scenarios
- New modules
- Documentation enhancements
- Bug fixes

---

## 📞 Support

For questions or issues:
1. Check demo README files
2. Review Terraform documentation
3. Check Azure provider documentation
4. Open an issue in the repository

---

## 📅 Demo Checklist

Before starting your demo:
- [ ] Tools installed (Terraform, Azure CLI)
- [ ] Azure authentication working
- [ ] Repository cloned
- [ ] Demo 2 completed (for Demos 3-6)
- [ ] Backend configurations updated with storage account name
- [ ] Previous demo resources destroyed
- [ ] Terminal windows prepared
- [ ] Azure Portal open for verification
- [ ] README files reviewed

---

## 🎬 Recommended Demo Order by Audience

### For Developers
```
Demo 1 → Demo 3 → Demo 5
Focus: Getting started and code organization
```

### For DevOps Engineers
```
Demo 2 → Demo 3 → Demo 4 → Demo 6
Focus: Team collaboration and production patterns
```

### For Architects
```
Demo 4 → Demo 5 → Demo 6
Focus: Design patterns and enterprise architecture
```

### For Managers/Leadership
```
Demo 1 → Demo 2 → Demo 6
Focus: Value proposition and production readiness
```

---

## 🌟 Key Takeaways

1. **Start Simple** - Demo 1 shows Terraform is approachable
2. **Think Team** - Demo 2-3 enable collaboration
3. **Be Sophisticated** - Demo 4 shows advanced patterns
4. **Stay DRY** - Demo 5 promotes code reuse
5. **Use Standards** - Demo 6 leverages proven solutions

---

**Ready to demo? Start with Demo 1!** 🚀

Each demo folder contains its own detailed README with step-by-step instructions.
