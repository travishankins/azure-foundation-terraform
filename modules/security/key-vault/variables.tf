# Global variables
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group for this resource."
}

variable "location" {
  type        = string
  description = "The location of the resource."
}

variable "resource_instance_count" {
  type        = string
  description = "The instance of resource type in the resource group if more that one resource exists in the same resource group. "
}

variable "resource_type_abbrv" {
  type        = string
  description = "The resource type abbreviation."
  default     = "kv"
}

variable "environment" {
  type        = string
  description = "The environment the resource will be deployed to."
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

variable "solution_name" {
  type        = string
  description = "solution name for azure data bricks."
}

# key vault variables
variable "enabled_for_deployment" {
  type        = bool
  description = "Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. Defaults to false."
}

variable "enabled_for_disk_encryption" {
  type        = bool
  description = "Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to false."
}

variable "enabled_for_template_deployment" {
  type        = bool
  description = "Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. Defaults to false."
}

variable "enable_rbac_authorization" {
  type        = bool
  description = " Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions."
}

variable "public_network_access_enabled" {
  type        = bool
  description = " Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions."
  default     = true
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Is Purge Protection enabled for this Key Vault? Defaults to false."
  default     = false
}

variable "subnets" {
  description = "A list of virtual network subnes to add to key vault ACL."
  type = list(object({
    name                 = optional(string) # Specifies the name of the Subnet.
    virtual_network_name = optional(string) # Specifies the name of the Virtual Network this Subnet is located within.
    resource_group_name  = optional(string) # Specifies the name of the resource group the Virtual Network is located in.
  }))

  default = []
}

variable "network_acls" {
  description = "A network ACL object that contains bypass, default action, ip_rules, and virtual_network_subnet_ids."
  type = object({
    bypass         = optional(string)       # Specifies which traffic can bypass the network rules. Possible values are AzureServices and None.
    default_action = optional(string)       # The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny.
    ip_rules       = optional(list(string)) # One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault.
    subnet_ids     = optional(list(string)) # One or more subnets IDs,  which should be able to access the Key Vault. 
  })
  default = null
}

variable "sku_name" {
  type        = string
  description = "The Name of the SKU used for this Key Vault. Possible values are standard and premium."

  validation {
    condition = (
      contains(["standard", "premium"], var.sku_name)
    )
    error_message = "The value for sku_name must be one of premium or standard."
  }
}

variable "soft_delete_retention_days" {
  type        = number
  description = "The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days."
  default     = 30

  validation {
    condition     = (var.soft_delete_retention_days <= 90 && var.soft_delete_retention_days >= 7)
    error_message = "The value for soft_delete_retention_days must be between 7 and 90 (the default)."
  }
}
