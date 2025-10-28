variable "project_name" {
  description = "The name of the project"
  type        = string

  validation {
    condition     = length(var.project_name) <= 10 && can(regex("^[a-z0-9]+$", var.project_name))
    error_message = "Project name must be <= 10 characters and contain only lowercase letters and numbers."
  }
}

variable "environment" {
  description = "The environment (dev, uat, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "uat", "prod"], var.environment)
    error_message = "Environment must be dev, uat, or prod."
  }
}

variable "location" {
  description = "The Azure region for resources"
  type        = string
  default     = "East US"
}

variable "vnet_address_space" {
  description = "The address space for the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_names" {
  description = "List of subnet names to create"
  type        = list(string)
  default     = ["web", "app", "data"]
}

variable "storage_account_tier" {
  description = "The tier of the storage account"
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}
