# Demo 3: Virtual Network with Remote State

## Overview
This demo deploys a complete virtual network infrastructure using **remote state backend**:
- Virtual Network with 3 subnets (web, app, data)
- Network Security Group with rules
- State stored in Azure Storage from Demo 2

## Key Concepts
- **Remote State Backend**: Using Azure Storage for state management
- **State Locking**: Automatic with Azure Storage backend
- **Separate State Files**: Using unique key for each deployment
- **Team Collaboration**: Multiple users can work safely

## Files
- `main.tf` - VNet infrastructure with backend configuration
- `backend.hcl` - Backend configuration file (alternative approach)
- `outputs.tf` - Network information outputs

## Prerequisites
✅ Complete Demo 2 first to create the remote state storage account

## Demo Steps

**💬 INSTRUCTOR INTRO:**
> "Now we get to use the remote state we just created. We're going to deploy a complete virtual network with subnets and security groups. But the key difference from Demo 1 is - there will be NO local state file. Everything will be stored in Azure. Let me show you."

---

### 1. Update Backend Configuration
First, get the storage account name from Demo 2:
```bash
cd ../demo-02-remote-state-setup
terraform output storage_account_name
```

Then update `backend.hcl` or the backend block in `main.tf` with the correct storage account name.

**💬 INSTRUCTOR SAYS:**
> "Before we can initialize, I need to configure the backend. I'm opening the `backend.hcl` file and pasting in the storage account name from Demo 2. See line 2 - that's where the storage account name goes. I'm also setting a unique key name - 'demo03-vnet.tfstate' - so this state file doesn't conflict with others."

**👀 POINT OUT:**
- Backend configuration is separate from main code
- Unique state file key for this deployment
- Uses storage account from Demo 2

---

### 2. Initialize with Remote Backend
```bash
cd demo-03-vnet-remote-state

# Option 1: Using backend.hcl file
terraform init -backend-config=backend.hcl

# Option 2: Using inline values (if you updated main.tf)
terraform init
```

**💬 INSTRUCTOR SAYS:**
> "Now watch carefully when I run `terraform init`. It's not just downloading providers - it's also configuring the REMOTE backend. See the message about 'Initializing the backend'? Terraform is connecting to our Azure Storage account right now."

**What to show**:
- Terraform initializes the remote backend
- State will be stored in Azure Storage
- State locking is enabled

**👀 POINT OUT:**
- "Initializing the backend" message
- Connection to Azure Storage
- No local state file will be created
- Different from Demo 1!

---

### 3. Review the Plan
```bash
terraform plan
```

**💬 INSTRUCTOR SAYS:**
> "Let's look at the plan. We're creating a complete network: 1 VNet, 3 subnets, a network security group with HTTP and HTTPS rules, and an association between the NSG and the web subnet. This is real-world infrastructure, not just a toy example."

**What to show**:
- 1 Resource Group
- 1 Virtual Network
- 3 Subnets
- 1 Network Security Group with rules
- 1 NSG-Subnet association

**👀 POINT OUT:**
- Multiple resource types
- Dependencies between resources
- Security rules configured
- Address spaces planned (10.0.x.x)

---

### 4. Apply the Configuration
```bash
terraform apply
```

**💬 INSTRUCTOR SAYS:**
> "I'm applying this now. While it's running, notice we're creating resources in a specific order. Terraform understands the dependencies - it creates the VNet first, then the subnets, because subnets need the VNet to exist."

**What to show**:
- Type 'yes' to confirm
- Resources are created in order
- Outputs display network information

**👀 POINT OUT:**
- Creation order (RG → VNet → Subnets → NSG → Association)
- Progress indicators
- Outputs show resource details
- No local state file created!

---

### 5. Verify Remote State in Azure
Navigate to Azure Portal → Storage Account (from Demo 2) → Containers → tfstate

**💬 INSTRUCTOR SAYS:**
> "Now for the magic - let me go to the Azure Portal. I'm navigating to our state storage account from Demo 2, opening the 'tfstate' container, and there it is - 'demo03-vnet.tfstate'. Click on it and you can see the state file. If I download it, you'd see the same JSON structure as Demo 1, but it's stored centrally in Azure, not on my laptop."

**What to show**:
- `demo03-vnet.tfstate` file in the container
- State is stored remotely, not locally
- Blob versioning shows state changes
- File size and last modified date

**👀 POINT OUT:**
- State file is in Azure Blob Storage
- Versioning enabled (can see history)
- Accessible to whole team
- Encrypted at rest

---

### 6. Check Local Directory
```bash
ls -la
```

**💬 INSTRUCTOR SAYS:**
> "Look at this - I'm running `ls -la` in my current directory. You see .terraform directory, you see our .tf files, but NO terraform.tfstate file. That's because it's in Azure! This is the key difference from Demo 1."

**What to show**:
- NO `terraform.tfstate` file locally
- Only `.terraform` directory and configuration files
- Proof that state is remote

**👀 POINT OUT:**
- No terraform.tfstate in current directory
- .terraform directory exists (provider plugins)
- .terraform.lock.hcl exists (dependency lock)
- State is 100% remote

---

### 7. View Outputs
```bash
terraform output
terraform output vnet_address_space
terraform output subnet_ids
```

**💬 INSTRUCTOR SAYS:**
> "Even though the state is remote, I can still query it with terraform output. Terraform fetches the state from Azure, reads it, and shows me the outputs. If my colleague ran this command from their computer, they'd see the same thing."

**👀 POINT OUT:**
- Outputs work the same as local state
- Data is fetched from Azure
- Team members see same outputs

---

### 8. Test State Locking (Optional)
In one terminal:
```bash
terraform apply
# Don't confirm yet
```

In another terminal (try to):
```bash
terraform plan
```

**💬 INSTRUCTOR SAYS:**
> "Let me demonstrate state locking. I'll open two terminal windows. In the first, I'll run terraform apply but NOT confirm it yet. Now in the second terminal, I'll try to run terraform plan. Watch what happens - Terraform says the state is locked! This prevents two people from making conflicting changes at the same time."

**What to show**: 
- Second command is blocked
- State lock prevents concurrent operations
- Error message shows who has the lock
- This prevents conflicts in team environments

**👀 POINT OUT:**
- Lock is automatic
- Shows lock ID
- Prevents race conditions
- Critical for team collaboration

---

### 9. View State Remotely
```bash
terraform state list
terraform state show azurerm_virtual_network.main
```

**💬 INSTRUCTOR SAYS:**
> "I can inspect the state with Terraform commands. `terraform state list` shows all resources, and `terraform state show` gives details about a specific resource. This data is coming from Azure Storage, not a local file."

**👀 POINT OUT:**
- State commands work with remote state
- Data fetched from Azure
- Same experience as local state, but shared

## Key Points to Highlight

**💬 INSTRUCTOR WRAP-UP:**
> "So we've just deployed production-quality network infrastructure using remote state. The key takeaways: no local state file, automatic state locking for team safety, and the state is accessible to everyone on the team. This is how real organizations use Terraform. In the next demos, we'll layer on more advanced patterns like locals, modules, and environment-specific configurations."

✅ **No Local State** - State file is in Azure, not on your machine  
✅ **Unique State Key** - Each deployment has its own state file  
✅ **State Locking** - Prevents concurrent modifications automatically  
✅ **Team Ready** - Multiple people can use same backend  
✅ **State Versioning** - Blob versioning allows rollback  
✅ **Secure** - State stored in private container  

**Team Collaboration Benefits:**
- **Shared State** - Everyone sees the same infrastructure
- **Automatic Locking** - No manual coordination needed
- **Version History** - Can track state changes over time
- **Disaster Recovery** - State backed up in Azure Storage  

## Backend Configuration Options

### Option 1: Hardcoded in main.tf
```hcl
backend "azurerm" {
  resource_group_name  = "rg-terraform-state"
  storage_account_name = "tfstateXXXXXX"
  container_name       = "tfstate"
  key                  = "demo03-vnet.tfstate"
}
```

### Option 2: Using backend.hcl file
```bash
terraform init -backend-config=backend.hcl
```

### Option 3: Environment variables
```bash
export ARM_ACCESS_KEY="<storage-account-key>"
terraform init
```

## Comparison: Local vs Remote State

| Feature | Local State (Demo 1) | Remote State (Demo 3) |
|---------|---------------------|----------------------|
| Location | Local disk | Azure Storage |
| Team Collaboration | ❌ No | ✅ Yes |
| State Locking | ❌ No | ✅ Yes |
| Versioning | ❌ No | ✅ Yes |
| Disaster Recovery | ❌ No | ✅ Yes |
| Security | ⚠️ On disk | ✅ Azure RBAC |

## Next Demo
Demo 4 will show advanced features like locals, multiple tfvars files, and managing multiple state files.

## Cleanup
```bash
terraform destroy
```

Note: This only destroys the VNet infrastructure, not the state storage account.
