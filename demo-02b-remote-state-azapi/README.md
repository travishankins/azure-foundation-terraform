# Demo 2B: Remote State Setup with AzAPI Provider

## Overview
This demo creates the **same infrastructure as Demo 2**, but uses the **AzAPI provider** instead of AzureRM for the storage account and container. This demonstrates the difference between the two providers and when to use each.

## 🎯 Learning Objectives

- Understand the difference between **AzureRM** and **AzAPI** providers
- Learn when to use AzAPI vs AzureRM
- See how AzAPI uses raw ARM API JSON
- Compare resource creation approaches

## 📊 Provider Comparison

### AzureRM Provider (Demo 2)
```hcl
resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.state.name
  location                 = azurerm_resource_group.state.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  # ✅ Simple, HCL-style configuration
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
}
```

**Characteristics:**
- ✅ Easy to read and write (HCL syntax)
- ✅ Strong typing and validation
- ✅ Well-documented resource attributes
- ✅ IDE autocomplete support
- ❌ Can lag behind new Azure features
- ❌ Limited to what the provider supports

### AzAPI Provider (Demo 2B)
```hcl
resource "azapi_resource" "storage_account" {
  type      = "Microsoft.Storage/storageAccounts@2023-01-01"
  name      = "tfstate${random_string.suffix.result}"
  parent_id = azurerm_resource_group.state.id
  location  = azurerm_resource_group.state.location

  body = jsonencode({
    sku = {
      name = "Standard_LRS"
    }
    kind = "StorageV2"
    properties = {
      minimumTlsVersion        = "TLS1_2"
      allowBlobPublicAccess    = false
      # ✅ Direct ARM API JSON - anything Azure supports
    }
  })
}
```

**Characteristics:**
- ✅ Supports ALL Azure features immediately
- ✅ Uses official ARM API schemas
- ✅ Can use preview/beta features
- ✅ Stays current with Azure releases
- ❌ More verbose (JSON in HCL)
- ❌ Less IDE support
- ❌ Requires ARM API knowledge

## 💬 INSTRUCTOR SAYS

"Demo 2 used the AzureRM provider - it's simple and clean. But what if Azure releases a new feature tomorrow and the provider doesn't support it yet?"

"That's where **AzAPI** comes in. It's a thin wrapper around the Azure REST API, so it supports **everything** Azure supports, the day it's released."

"Think of it this way:"
- **AzureRM** = "The easy button" - best for 90% of use cases
- **AzAPI** = "The power user option" - when you need cutting-edge features or precise control

## 🚀 How to Use

### Deploy the Infrastructure

```bash
cd demo-02b-remote-state-azapi

# Initialize
terraform init

# Plan
terraform plan

# Apply
terraform apply

# View outputs
terraform output
```

### Use the Backend in Other Demos

After deployment, copy the storage account name from outputs:

```bash
terraform output storage_account_name
```

Then update your `backend.hcl` files in other demos.

## 👀 POINT OUT

### 1. Resource Type Specification

**AzureRM:**
```hcl
resource "azurerm_storage_account" "tfstate" {
  # Provider handles the API version
}
```

**AzAPI:**
```hcl
resource "azapi_resource" "storage_account" {
  type = "Microsoft.Storage/storageAccounts@2023-01-01"
  #                                         ^^^^^^^^^^
  #                                  You specify API version!
}
```

### 2. Configuration Body

**AzureRM:**
```hcl
account_tier             = "Standard"
account_replication_type = "LRS"
```

**AzAPI:**
```hcl
body = jsonencode({
  sku = {
    name = "Standard_LRS"
  }
})
```

### 3. Mixed Provider Usage

**Notice in main.tf:**
```hcl
# Resource Group - Using AzureRM (simple)
resource "azurerm_resource_group" "state" {
  name     = "rg-terraform-state-azapi"
  location = "East US"
}

# Storage Account - Using AzAPI (demonstrate the difference)
resource "azapi_resource" "storage_account" {
  type      = "Microsoft.Storage/storageAccounts@2023-01-01"
  parent_id = azurerm_resource_group.state.id  # ← References AzureRM resource
}
```

## 🎓 When to Use Each Provider

### Use AzureRM When:
- ✅ The feature is well-established and supported
- ✅ You want simple, readable code
- ✅ Team is learning Terraform
- ✅ Using standard Azure services
- ✅ Want strong typing and validation

**Example:** Creating VNets, VMs, Resource Groups, Key Vaults (Demo 1-6)

### Use AzAPI When:
- ✅ You need a brand-new Azure feature
- ✅ Using preview/beta features
- ✅ AzureRM doesn't support what you need yet
- ✅ You need precise control over API versions
- ✅ Working with complex/nested configurations

**Examples:**
- New Azure services on day one
- Preview features not yet in AzureRM
- Custom ARM templates in Terraform
- Advanced configurations

### Use BOTH When:
- ✅ Migrating from AzureRM to AzAPI gradually
- ✅ Most infrastructure is standard (AzureRM) but one feature needs AzAPI
- ✅ Demonstrating the difference (like this demo!)

## 📚 Code Comparison

### Storage Account Creation

#### Demo 2 (AzureRM) - 15 lines
```hcl
resource "azurerm_storage_account" "tfstate" {
  name                            = "tfstate${random_string.suffix.result}"
  resource_group_name             = azurerm_resource_group.state.name
  location                        = azurerm_resource_group.state.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true
  
  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 7
    }
  }
}
```

#### Demo 2B (AzAPI) - 30 lines
```hcl
resource "azapi_resource" "storage_account" {
  type      = "Microsoft.Storage/storageAccounts@2023-01-01"
  name      = "tfstate${random_string.suffix.result}"
  parent_id = azurerm_resource_group.state.id
  location  = azurerm_resource_group.state.location

  body = jsonencode({
    sku = {
      name = "Standard_LRS"
    }
    kind = "StorageV2"
    properties = {
      minimumTlsVersion         = "TLS1_2"
      allowBlobPublicAccess     = false
      allowSharedKeyAccess      = true
      publicNetworkAccess       = "Enabled"
      supportsHttpsTrafficOnly  = true
      accessTier                = "Hot"
      
      blobProperties = {
        isVersioningEnabled = true
        deleteRetentionPolicy = {
          enabled = true
          days    = 7
        }
      }
    }
  })
}
```

**Notice:**
- AzAPI is more verbose but gives exact control
- Property names match ARM API exactly
- JSON structure from Azure docs can be copied directly

## 🔄 Data Source Usage

Because we use AzAPI for the storage account, we need a data source to get the access keys:

```hcl
data "azurerm_storage_account" "tfstate" {
  name                = azapi_resource.storage_account.name
  resource_group_name = azurerm_resource_group.state.name
  
  depends_on = [azapi_resource.storage_account]
}
```

## 🎯 Key Takeaways

1. **AzureRM** = Developer-friendly, best for most scenarios
2. **AzAPI** = Power-user tool for new/advanced features
3. **You can use both** in the same configuration
4. **AzAPI uses ARM API JSON** directly from Azure docs
5. **AzAPI specifies API versions** explicitly for control

## 🎬 Demo Script

### Step 1: Compare Providers
```bash
# Show AzureRM version (Demo 2)
cat ../demo-02-remote-state-setup/main.tf

# Show AzAPI version (Demo 2B)
cat main.tf
```

**Say:** "Same infrastructure, different providers. Notice the JSON in AzAPI vs clean HCL in AzureRM."

### Step 2: Deploy
```bash
terraform init
terraform plan
terraform apply
```

**Point out:** The two providers downloading during init

### Step 3: Show Outputs
```bash
terraform output storage_account_properties
```

**Say:** "AzAPI gives us raw access to all ARM API responses!"

## 🧹 Clean Up

```bash
terraform destroy
```

## 📖 Related Demos

- **Demo 2** - Same infrastructure using AzureRM (compare!)
- **Demo 3** - Uses the storage account created here
- **Demo 4-6** - All use AzureRM (standard approach)

## 📚 Additional Resources

### Finding AzAPI Resource Schemas

**Here's how to find AzAPI resource schemas:**

#### 1. Azure REST API Documentation (Primary Source)
🔗 **https://learn.microsoft.com/en-us/rest/api/azure/**

**Workflow:**
1. Search for your resource type (e.g., "Storage Account")
2. Find the CREATE operation
3. Copy the JSON schema from the Request Body section
4. Paste into `body = jsonencode({})`

**Example for Storage Account:**
- URL: https://learn.microsoft.com/en-us/rest/api/storagerp/storage-accounts/create
- Shows exact JSON structure needed

#### 2. Azure Resource Templates Reference
🔗 **https://learn.microsoft.com/en-us/azure/templates/**

**Workflow:**
1. Search for resource (e.g., "Microsoft.Storage/storageAccounts")
2. Select API version
3. View the complete schema with all properties
4. Copy property names and structure

#### 3. VS Code Extensions (Helpful Tools)

Install these for better AzAPI support:

```bash
# AzAPI provider extension with snippets
code --install-extension azapi-vscode.azapi

# Azure Terraform extension
code --install-extension ms-azuretools.vscode-azureterraform

# Azure API Center extension
code --install-extension microsoft.azure-api-center
```

**Features:**
- ✅ Code snippets (type `azapi` and browse templates)
- ✅ Syntax highlighting
- ✅ Links to documentation
- ✅ Some auto-completion support

#### 4. Azure Portal "Export Template" Trick

**Clever approach for complex resources:**

1. Create a resource in Azure Portal (manual)
2. Navigate to the resource → **"Export template"**
3. Copy the ARM template JSON
4. Convert to Terraform `jsonencode()` format

**Example:**
```json
// From Azure Portal Export Template
{
  "type": "Microsoft.Storage/storageAccounts",
  "apiVersion": "2023-01-01",
  "properties": {
    "minimumTlsVersion": "TLS1_2",
    "allowBlobPublicAccess": false
  }
}
```

**Becomes:**
```hcl
resource "azapi_resource" "storage" {
  type = "Microsoft.Storage/storageAccounts@2023-01-01"
  
  body = jsonencode({
    properties = {
      minimumTlsVersion      = "TLS1_2"
      allowBlobPublicAccess  = false
    }
  })
}
```

#### 5. Azure CLI to Discover JSON Structure

**Get actual resource JSON:**

```bash
# Create or view a resource
az storage account show \
  --name mystorageaccount \
  --resource-group mygroup \
  --output json

# This shows the exact JSON structure Azure uses!
```

**Then copy relevant properties into your AzAPI resource.**

#### 6. AzAPI Examples Repository
🔗 **https://github.com/Azure/terraform-azapi-examples**

Browse real-world examples of common resources with working code.

#### 7. Find Resource Types and API Versions

```bash
# List all resource types for a provider
az provider show -n Microsoft.Storage \
  --query "resourceTypes[].resourceType" -o table

# Get available API versions
az provider show -n Microsoft.Storage \
  --query "resourceTypes[?resourceType=='storageAccounts'].apiVersions[]" -o tsv
```

### Why Limited IntelliSense?

**The Reality:**
- ❌ AzureRM has strongly-typed HCL schema → Great IntelliSense
- ❌ AzAPI uses free-form JSON in `body` → Limited IntelliSense
- ❌ JSON schema validation happens at plan/apply, not edit time

**But the trade-off is worth it:**
- ✅ AzAPI supports **every** Azure feature on day one
- ✅ No waiting for AzureRM provider updates
- ✅ Can use preview/beta features immediately
- ✅ Direct access to ARM API capabilities

### Recommended Workflow

1. **Start with Azure Docs** - Find the resource schema
2. **Use Portal Export** - For complex resources, create manually and export
3. **Test incrementally** - Build the `body` section step by step
4. **Validate often** - Run `terraform validate` and `terraform plan`
5. **Refer to examples** - Check the AzAPI examples repo for similar resources

💡 **Pro Tip:** Keep the Azure REST API docs open in a browser tab while writing AzAPI resources!

---

## 📚 Reference Links

- [AzAPI Provider Documentation](https://registry.terraform.io/providers/Azure/azapi/latest/docs)
- [Azure REST API Reference](https://learn.microsoft.com/en-us/rest/api/azure/)
- [Azure Resource Templates](https://learn.microsoft.com/en-us/azure/templates/)
- [When to use AzAPI](https://learn.microsoft.com/en-us/azure/developer/terraform/overview-azapi-provider)
- [AzAPI Examples Repository](https://github.com/Azure/terraform-azapi-examples)
- [AzAPI VS Code Extension](https://marketplace.visualstudio.com/items?itemName=azapi-vscode.azapi)

---

**Key Insight:** Use **AzureRM by default**, reach for **AzAPI when you need it**. Both are valid tools in your Terraform toolkit! 🛠️
