# Demo 1: Resource Group with Local State

## Overview
This demo shows the most basic Terraform deployment:
- Creates a single Azure Resource Group
- Uses **local state file** (terraform.tfstate)
- Minimal configuration

## Key Concepts
- **Local State**: State file stored locally in the working directory
- **Basic Resources**: Simple resource creation
- **Provider Configuration**: Setting up Azure provider

## Files
- `main.tf` - Main Terraform configuration with provider and resource
- `outputs.tf` - Output definitions to display resource information

## Demo Steps

### 1. Initialize Terraform
```bash
cd demo-01-local-state
terraform init
```

**💬 INSTRUCTOR SAYS:**
> "Let's start with the absolute basics. I'm going to run `terraform init`. This command downloads the Azure provider plugin that Terraform needs to communicate with Azure. Think of it like installing a driver for a piece of hardware."

**What happens**: Downloads Azure provider and initializes local backend

**👀 POINT OUT:**
- The `.terraform` directory is created
- Provider plugins are downloaded
- Local backend is initialized (no remote state yet)

---

### 2. Review the Plan
```bash
terraform plan
```

**💬 INSTRUCTOR SAYS:**
> "Now I'll run `terraform plan`. This is like a preview - Terraform shows me exactly what it's going to do before making any changes. Notice it says it will CREATE 1 resource - our resource group. Nothing has been deployed yet, this is just showing the plan."

**What to show**: Terraform shows what will be created (1 resource group)

**👀 POINT OUT:**
- The `+` sign means "create"
- Shows resource type and name
- Shows all attributes that will be set
- No actual changes are made yet

---

### 3. Apply the Configuration
```bash
terraform apply
```

**💬 INSTRUCTOR SAYS:**
> "Now let's actually deploy it with `terraform apply`. Terraform will show me the plan again and ask for confirmation. This safety mechanism prevents accidental deployments. I'll type 'yes' to proceed."

**What to show**: 
- Type 'yes' to confirm
- Watch the resource being created in real-time
- Outputs are displayed automatically
- `terraform.tfstate` file is created locally

**👀 POINT OUT:**
- Creation takes a few seconds
- Green text shows success
- Outputs display automatically
- The state file is created

---

### 4. View State File
```bash
cat terraform.tfstate
```

**💬 INSTRUCTOR SAYS:**
> "This is the state file - the most important file in Terraform. It's a JSON file that contains everything Terraform knows about our infrastructure. Look at this - it has the resource group ID, creation date, everything. This is how Terraform knows what exists in Azure."

**What to show**: JSON file containing current infrastructure state

**👀 POINT OUT:**
- It's JSON format
- Contains resource IDs and all attributes
- Shows dependency information
- **⚠️ WARNING:** Contains sensitive data (we'll see this in later demos)

---

### 5. View Outputs
```bash
terraform output
```

**💬 INSTRUCTOR SAYS:**
> "Outputs are values we've explicitly chosen to display. These are useful for getting information about our infrastructure - like resource IDs or names that other tools might need."

**👀 POINT OUT:**
- Clean, formatted output
- Can be used by other tools/scripts
- Can be marked as sensitive to hide values

---

### 6. Verify in Azure Portal
Show the resource group in Azure Portal

**💬 INSTRUCTOR SAYS:**
> "Let me switch to the Azure Portal now. Here's our resource group - `rg-demo-01-local-state`. Notice the tags we defined in Terraform are all here. What you see in the portal was created entirely from our code file. This is Infrastructure as Code!"

**👀 POINT OUT:**
- Resource exists in Azure
- Tags match our Terraform code
- Name matches our configuration
- Location is correct

---

### 7. Make a Change (Optional)
Edit `main.tf` to add a tag, then:
```bash
terraform plan
terraform apply
```

**💬 INSTRUCTOR SAYS:**
> "Watch this - I'm going to add a new tag to our resource group. When I run `terraform plan`, Terraform compares our code to the state file and says 'hey, this tag is new, I need to update the resource.' It shows a tilde `~` which means modify, not create or destroy."

**👀 POINT OUT:**
- Terraform detects the change
- Shows `~` for modification
- Only changes what's necessary
- Updates state file after applying

---

### 8. Cleanup
```bash
terraform destroy
```

**💬 INSTRUCTOR SAYS:**
> "Finally, `terraform destroy` will remove everything we created. This is one of the most powerful features of Infrastructure as Code - I can tear down entire environments with one command. This is perfect for dev environments or testing."

**👀 POINT OUT:**
- Shows what will be destroyed
- Requires confirmation
- Opposite of `apply`
- State file is updated (but kept)

## Key Points to Highlight

**💬 INSTRUCTOR WRAP-UP:**
> "So we've just seen the core Terraform workflow: write code, plan, apply, destroy. The state file is the source of truth. But here's the problem - this state file is on MY laptop. What if I'm sick tomorrow and someone else needs to manage this infrastructure? What if two people try to run terraform at the same time? That's why we need remote state, which we'll see in the next demo."

✅ **Local state** - Simple but not suitable for teams  
✅ **State file** - Contains sensitive data, tracks infrastructure  
✅ **Stateless to stateful** - Terraform knows what exists  
⚠️ **Limitations**: No collaboration, no locking, no versioning  

**Key Terraform Commands Demonstrated:**
- `terraform init` - Initialize and download providers
- `terraform plan` - Preview changes
- `terraform apply` - Deploy infrastructure
- `terraform output` - Display output values
- `terraform destroy` - Remove infrastructure  

## Next Demo
Demo 2 will show how to create remote state storage to enable team collaboration.
