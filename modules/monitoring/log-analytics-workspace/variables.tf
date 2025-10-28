# Global variables
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group for this resource."
}

variable "location" {
  type        = string
  description = "The location of the resource."
}

variable "resource_type_abbrv" {
  type        = string
  description = "The resource type abbreviation."
  default     = "law"
}

variable "resource_instance_count" {
  type        = string
  description = "The instance of resource type in the resource group if more that one resource exists in the same resource group."
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
  description = "solution name for azure log analytics workspace."
}

# log analytics workspace variables
variable "sku" {
  description = " Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018. Defaults to PerGB2018."
  type        = string
  default     = "PerGB2018"

  validation {
    condition     = contains(["PerGB2018", "Free", "PerNode", "Premium", "Standard", "Standalone", "Unlimited", "CapacityReservation"], var.sku)
    error_message = "The value for the sku must be one of Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, or PerGB2018."
  }
}

variable "allow_resource_only_permissions" {
  description = "Specifies if the log Analytics Workspace allow users accessing to data associated with resources they have permission to view, without permission to workspace. Defaults to true."
  type        = bool
  default     = true
}

variable "cmk_for_query_forced" {
  description = "Is Customer Managed Storage mandatory for query management?"
  type        = bool
  default     = false
}

variable "daily_quota_gb" {
  description = "The workspace daily quota for ingestion in GB. Defaults to -1 (unlimited) if omitted."
  type        = number
  default     = "-1"
}

variable "internet_ingestion_enabled" {
  description = "Should the Log Analytics Workspace support ingestion over the Public Internet? Defaults to true."
  type        = bool
  default     = true
}

variable "internet_query_enabled" {
  description = "Should the Log Analytics Workspace support querying over the Public Internet? Defaults to true."
  type        = bool
  default     = true
}

variable "local_authentication_disabled" {
  description = "Specifies if the log Analytics workspace should enforce authentication using Azure AD. Defaults to false."
  type        = bool
  default     = false
}

variable "retention_in_days" {
  description = "The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730. Defaults to 30."
  type        = number
  default     = 30

  validation {
    condition     = var.retention_in_days <= 730 && var.retention_in_days >= 30
    error_message = "The value for retention_in_days must be between 30 and 730 (the default)."
  }
}

variable "reservation_capacity_in_gb_per_day" {
  description = "The capacity reservation level in GB for this workspace. Must be in increments of 100 between 100 and 5000. reservation_capacity_in_gb_per_day can only be used when the sku is set to 'CapacityReservation'."
  type        = number
  default     = 100
}