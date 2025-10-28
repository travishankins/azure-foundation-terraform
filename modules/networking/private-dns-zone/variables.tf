variable "private_dns_zone_name" {
  type        = string
  description = "The name of the Private DNS Zone. Must be a valid domain name. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for shared resources."
}

variable "vnet_name" {
  type        = string
  description = "Virtual network name."
}

variable "vnet_id" {
  type        = string
  description = "Virtual network resource ID."
}

variable "link_to_vnet" {
  type        = bool
  description = "Should the private DNS zone be linked to a VNet ? "
}

variable "tags" {
  type        = map(string)
  description = "Tags to be associated with each resource."
  default     = {}
}