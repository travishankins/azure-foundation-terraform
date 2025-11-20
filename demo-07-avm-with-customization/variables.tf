# Variables for Demo 7: AVM with Customization

variable "organization_prefix" {
  type        = string
  description = "Organization prefix for resource naming (e.g., 'contoso', 'acme')"
  default     = "demo07"

  validation {
    condition     = can(regex("^[a-z0-9]{3,10}$", var.organization_prefix))
    error_message = "Organization prefix must be 3-10 lowercase alphanumeric characters."
  }
}

variable "environment" {
  type        = string
  description = "Environment name (dev, uat, prod)"
  default     = "dev"

  validation {
    condition     = contains(["dev", "uat", "prod"], var.environment)
    error_message = "Environment must be dev, uat, or prod."
  }
}

variable "location" {
  type        = string
  description = "Azure region for resources"
  default     = "East US"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to apply to all resources"
  default = {
    Project    = "AVM-Demo"
    CostCenter = "IT-Engineering"
  }
}

# Key Vault Variables
variable "key_vault_sku" {
  type        = string
  description = "SKU for Key Vault"
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.key_vault_sku)
    error_message = "Key Vault SKU must be standard or premium."
  }
}

variable "key_vault_allowed_ips" {
  type        = list(string)
  description = "List of allowed IP addresses for Key Vault access"
  default     = []
}

# Storage Account Variables
variable "storage_shared_key_enabled" {
  type        = bool
  description = "Enable shared key access for storage account"
  default     = true
}

variable "storage_allowed_ips" {
  type        = list(string)
  description = "List of allowed IP addresses for Storage Account access"
  default     = []
}

# Deployment Options
variable "enable_monitoring" {
  type        = bool
  description = "Enable diagnostic settings and monitoring"
  default     = true
}
