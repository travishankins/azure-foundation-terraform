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
  default     = "rbac"
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

# rbac assignment variables
variable "scope" {
  type        = string
  description = "The scope at which the Role Assignment applies to, such as /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333, /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup, or /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup/providers/Microsoft.Compute/virtualMachines/myVM, or /providers/Microsoft.Management/managementGroups/myMG. Changing this forces a new resource to be created."
}

variable "role_definition_name" {
  type        = string
  description = "The name of a built-in Role. Changing this forces a new resource to be created. Conflicts with role_definition_id."
}

variable "principal_id" {
  type        = string
  description = "The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to. Changing this forces a new resource to be created."
}

variable "description" {
  type        = string
  description = " The description for this Role Assignment. Changing this forces a new resource to be created."
}

variable "skip_service_principal_aad_check" {
  type        = bool
  description = "If the principal_id is a newly provisioned Service Principal set this value to true to skip the Azure Active Directory check which may fail due to replication lag. This argument is only valid if the principal_id is a Service Principal identity."
  default     = false
}