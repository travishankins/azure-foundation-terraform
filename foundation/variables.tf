variable "environment" {
  type        = string
  description = "The environment in which the resources are deployed to."
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID for this environment. If not provided, uses current Azure CLI context."
  default     = null
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be deployed."
  default     = "Central US"
}

variable "solution_name" {
  type        = string
  description = "The solution name used for resource naming conventions."
  default     = "foundation"
}

variable "resource_group_name" {
  description = "The name of the resource group to use."
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Tags to be associated with each resource."
}

#vnet variables
variable "vnet_address_space" {
  type        = list(string)
  description = "The Address space for the vnet"
}

variable "subnets" {
  type        = any
  description = "list of object for the subnets"
}

variable "nsgs_and_nsg_rules" {
  type        = list(any)
  description = "list of object for the network security groups and rules."
}

variable "subnet_nsg_association" {
  type        = list(any)
  description = "list of object subnet and network security group association."
}

# key vault variables
variable "key_vault_sku" {
  type        = string
  description = "The sku name for the key vault"
}