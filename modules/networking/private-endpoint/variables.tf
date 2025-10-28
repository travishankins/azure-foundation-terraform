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
  default     = "pe"
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
  description = "Solution name for private endpoint"
}

# private endpoint variable
variable "attached_resource_abbrv" {
  type        = string
  description = "The resource type abbreviation of the attached resource"
}

variable "is_manual_connection" {
  description = " Does the Private Endpoint require Manual Approval from the remote resource owner? Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

variable "request_message" {
  description = "A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection to the remote resource. The provider allows a maximum request message length of 140 characters, however the request message maximum length is dependent on the service the private endpoint is connected to. Only valid if is_manual_connection is set to true"
  type        = string
  default     = null
}

variable "ip_configurations" {
  description = "A list of ip configurations.  This allows a static IP address to be set for this Private Endpoint, otherwise an address is dynamically allocated from the Subnet."
  type = list(object({
    name               = string
    private_ip_address = string
    subresource_name   = optional(string)
  }))
  default = []
}

variable "private_dns_zone_group" {
  description = "Specifies details about the Private DNS Zone Group including name and ids."
  type = object({
    name                 = string
    private_dns_zone_ids = list(string)
  })
  default = null
}

variable "subresource_name" {
  description = " A list of subresource names which the Private Endpoint is able to connect to. subresource_names corresponds to group_id. Possible values are detailed in the product documentation in the Subresources column. Changing this forces a new resource to be created."
  type        = list(string)
}

variable "target_resource" {
  description = "Private Link Service Alias or ID of the target resource."
  type        = string

  validation {
    condition     = length(regexall("^([a-z0-9\\-]+)\\.([a-z0-9\\-]+)\\.([a-z]+)\\.(azure)\\.(privatelinkservice)$", var.target_resource)) == 1 || length(regexall("^\\/(subscriptions)\\/([a-z0-9\\-]+)\\/(resourceGroups)\\/([A-Za-z0-9\\-]+)\\/(providers)\\/([A-Za-z\\.]+)\\/([A-Za-z]+)\\/([A-Za-z0-9\\-]+)$", var.target_resource)) == 1
    error_message = "The `target_resource` variable must be a Private Link Service Alias or a resource ID."
  }
}

# Azurerm_dns_a_record variables
variable "resource_name" {
  description = "The name of the resource that private endpoint will be attached to"
  type        = string
  default     = null
}
variable "dns_zone_name" {
  description = "Specifies the DNS Zone where the resource exists. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "dns_zone_resource_group_name" {
  description = "Specifies the resource group where the DNS Zone (parent resource) exists. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "The subnet to connect the private endpoint to."
  type        = string
}