# Demo 2: Storage Account for Remote State

## Overview
This demo creates the Azure infrastructure needed for remote state management:
- Resource Group for state storage
- Storage Account with security settings
- Blob Container for state files

## 🎯 Key Concepts Demonstrated

1. **Storage Account for State** - Azure Blob Storage for Terraform state
2. **State Container** - Dedicated container for state files
3. **Versioning & Retention** - Blob versioning and 7-day retention policy
4. **Security Settings** - TLS 1.2, private containers
5. **Azure AD Authentication** - Using Azure AD instead of storage keys (required when subscription policies block key-based auth)

## ⚠️ Important Note on Authentication

This demo configures the Azure provider with `storage_use_azuread = true` because some Azure subscriptions have policies that prevent key-based authentication on storage accounts. 

**If you encounter this error:**
```
Error: Key based authentication is not permitted on this storage account
```

**The solution is already implemented:** The provider is configured to use Azure AD authentication instead of storage access keys.

## Files
- `main.tf` - Creates storage account infrastructure for remote state
- `outputs.tf` - Displays backend configuration for use in other projects

## Demo Steps

**💬 INSTRUCTOR INTRO:**
> "In the last demo, we saw the limitation of local state files. Now we're going to solve that by creating remote state storage in Azure. This is infrastructure that will hold our state files for all future demos. Think of it as building the foundation before we build the house."

---

### 1. Initialize Terraform
```bash
cd demo-02-remote-state-setup
terraform init
```

**💬 INSTRUCTOR SAYS:**
> "Notice this demo still uses local state - we need local state to CREATE the remote state storage. It's a chicken-and-egg situation. After this, all our other demos will use the storage account we're about to create."

---

### 2. Review the Plan
```bash
terraform plan
```

**💬 INSTRUCTOR SAYS:**
> "Let's see what we're creating: a resource group, a storage account with a randomized name (because storage account names must be globally unique), and a blob container called 'tfstate'. Notice the security settings - TLS 1.2, private access, blob versioning enabled. These are production best practices."

**What to show**: 
- Resource group for state storage
- Storage account with unique name
- Blob container for state files
- Security configurations

**👀 POINT OUT:**
- Random suffix ensures globally unique name
- Blob versioning for state recovery
- Private container access
- TLS 1.2 minimum

---

### 3. Apply the Configuration
```bash
terraform apply
```

**💬 INSTRUCTOR SAYS:**
> "I'll type 'yes' to create these resources. Watch the output carefully - we'll need the storage account name for all our future demos."

**What to show**:
- Type 'yes' to confirm
- Resources are created
- Backend configuration is output
- **Save the storage account name!**

**👀 POINT OUT:**
- Creation order (RG first, then storage, then container)
- Random suffix in storage account name
- Output shows ready-to-use backend configuration

---

### 4. Save Backend Configuration
Copy the backend configuration from the outputs:
```bash
terraform output backend_config
```

**💬 INSTRUCTOR SAYS:**
> "Here's the beautiful part - Terraform outputs the exact configuration we need for other projects. Copy this storage account name - we'll use it in demos 3, 4, 5, and 6. This is the backend configuration that enables team collaboration."

**👀 POINT OUT:**
- Pre-formatted backend configuration
- Shows both inline and file-based options
- Ready to copy-paste

---

### 5. Verify in Azure Portal
Show:
- Resource group: `rg-terraform-state`
- Storage account: `tfstate<random>`
- Container: `tfstate`
- Blob versioning enabled

**💬 INSTRUCTOR SAYS:**
> "Let me show you in the Azure Portal. Here's our storage account. If I go to containers, you can see 'tfstate' - this is where all our future state files will live. Click on properties and you'll see versioning is enabled - this means if something goes wrong, we can roll back to previous versions of our state."

**👀 POINT OUT:**
- Storage account exists
- Container is private (no public access)
- Versioning is enabled under properties
- This is empty now, but will fill up in next demos

---

### 6. View Storage Account Properties
```bash
terraform output storage_account_name
```

**💬 INSTRUCTOR SAYS:**
> "I'm saving this storage account name to my notes. You'll see me use it in every subsequent demo. In a real team environment, this would be documented in your team wiki or onboarding guide."

**👀 POINT OUT:**
- Storage account name is unique
- Will be used in all remaining demos
- In production, this would be created once and shared

## Key Points to Highlight

**💬 INSTRUCTOR WRAP-UP:**
> "Perfect! We now have our remote state storage. This storage account will serve as the central repository for all our Terraform state files. Multiple team members can use it, it has automatic locking to prevent conflicts, and versioning for safety. In the next demo, we'll actually USE this remote state to deploy a virtual network."

✅ **Remote State** - Stored in Azure, accessible to team  
✅ **State Locking** - Azure Storage provides automatic locking  
✅ **Versioning** - Blob versioning allows state recovery  
✅ **Security** - TLS 1.2, private access, no public blobs  
✅ **Unique Naming** - Random suffix ensures globally unique name  

**Why This Matters:**
- **Team Collaboration** - Multiple people can work safely
- **State Protection** - Centralized, versioned, backed up
- **Automatic Locking** - Prevents concurrent modification conflicts
- **Disaster Recovery** - Blob versioning enables rollback  

## Important Notes
🔐 The storage account key is sensitive - in production, use:
- Azure AD authentication instead of access keys
- Managed identities for CI/CD pipelines
- RBAC for granular permissions

## State File Location
After this demo, state files can be stored at:
```
https://<storage-account>.blob.core.windows.net/tfstate/terraform.tfstate
```

## Next Demo
Demo 3 will use this remote state backend to deploy a VNet, demonstrating team collaboration capabilities.

## Cleanup Note
⚠️ **DO NOT DELETE** this infrastructure until after completing demos 3-6, as they will use this remote state backend.

To destroy later:
```bash
terraform destroy
```
