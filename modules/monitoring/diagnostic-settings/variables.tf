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
  default     = "ds"
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

# diagnostic settings variables
variable "name" {
  type        = string
  description = "Specifies the name of the Diagnostic Setting. Changing this forces a new resource to be created."
}

variable "target_resource_id" {
  type        = string
  description = "The ID of the resource on which to activate the diagnostic settings."
}

variable "log_categories" {
  type        = list(string)
  description = "List of log categories. Defaults to all available."
  default     = null
}

variable "excluded_log_categories" {
  type        = list(string)
  description = "List of log categories to exclude."
  default     = []
}

variable "metric_categories" {
  type        = list(string)
  description = "List of metric categories. Defaults to all available."
  default     = null
}

# variable "retention_days" {
#   type        = number
#   description = "The number of days to keep diagnostic logs."
#   default     = 0
# }

variable "logs_destinations_ids" {
  type        = list(string)
  description = "List of destination resources IDs for logs diagnostic destination. Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set. If you want to use Azure EventHub as destination, you must provide a formatted string with both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the <code>&#124;</code> character."
}

variable "log_analytics_destination_type" {
  type        = string
  description = "Possible values are AzureDiagnostics and Dedicated. When set to 'Dedicated' logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table."
  default     = "AzureDiagnostics"
}