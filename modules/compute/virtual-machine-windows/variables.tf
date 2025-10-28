# Global variables
variable "resource_group_name" {
  description = "The name of the resource group for this resource."
  type        = string
}

variable "location" {
  description = "The location of the resource."
  type        = string
}

variable "resource_instance_count" {
  description = "The instance of resource type in the resource group if more that one resource exists in the same resource group. "
  type        = string
}

variable "resource_type_abbrv" {
  description = "The resource type abbreviation."
  type        = string
  default     = "vm"
}

variable "environment" {
  description = "The environment the resource will be deployed to."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "solution_name" {
  type        = string
  description = "Specifies part of the name of the data factory. Changing this forces a new resource to be created."
}

# networking Variables
variable "subnet_id" {
  description = "ID of Subnet to be attached to Virtual Machine NIC."
  type        = string
}

variable "static_private_ip" {
  description = "Static private IP. Private IP is dynamic if not set."
  type        = string
  default     = null
}

variable "public_ip_sku" {
  description = "The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic. Changing this forces a new resource to be created.Sku for the public IP attached to the VM. Can be `null` if no public IP needed."
  type        = string
  default     = "Standard"
}

variable "custom_dns_label" {
  description = "Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
  type        = string
  default     = ""
}

variable "public_ip_zones" {
  description = "Zones for public IP attached to the VM. Can be `null` if no zone distpatch."
  type        = list(number)
  default     = [1, 2, 3]
}

# vm variables

variable "custom_computer_name" {
  description = "Custom name for the Virtual Machine Hostname. Based on `custom_name` if not set."
  type        = string
  default     = ""

  validation {
    condition     = var.custom_computer_name == "" || (can(regex("^[a-zA-Z0-9-]{1,15}$", var.custom_computer_name)) && !can(regex("^[0-9-]", var.custom_computer_name)))
    error_message = "The `custom_computer_name` value must be 15 characters long at most and can contain only allowed characters (Windows constraint) `[a-zA-Z0-9-]{1,15}`."
  }
}

variable "custom_data" {
  description = "The Base64-Encoded Custom Data which should be used for this Virtual Machine. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "user_data" {
  description = "The Base64-Encoded User Data which should be used for this Virtual Machine."
  type        = string
  default     = null
}

variable "admin_username" {
  description = "Username for Virtual Machine administrator account."
  type        = string
}

variable "admin_password" {
  description = "Password for Virtual Machine administrator account."
  type        = string
}

variable "vm_size" {
  description = "Size (SKU) of the Virtual Machine to create."
  type        = string
}

variable "availability_set_id" {
  description = "Id of the availability set in which host the Virtual Machine."
  type        = string
  default     = null
}

variable "zone_id" {
  description = "Specifies the Availability Zone in which this Windows Virtual Machine should be located. Changing this forces a new Windows Virtual Machine to be created."
  type        = string
  default     = null
}

variable "vm_image" {
  description = "Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/windows_virtual_machine.html#source_image_reference."
  type        = map(string)

  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

variable "vm_image_id" {
  description = "The ID of the Image which this Virtual Machine should be created from. This variable supersedes the `vm_image` variable if not null."
  type        = string
  default     = null
}

variable "vm_plan" {
  description = "Virtual Machine plan image information. See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#plan. This variable has to be used for BYOS image. Before using BYOS image, you need to accept legal plan terms. See https://docs.microsoft.com/en-us/cli/azure/vm/image?view=azure-cli-latest#az_vm_image_accept_terms."
  type = object({
    name      = string # Specifies the Name of the Marketplace Image this Virtual Machine should be created from. Changing this forces a new resource to be created.
    product   = string # Specifies the Product of the Marketplace Image this Virtual Machine should be created from. Changing this forces a new resource to be created.
    publisher = string # Specifies the Publisher of the Marketplace Image this Virtual Machine should be created from. Changing this forces a new resource to be created.
  })
  default = null
}

variable "license_type" {
  description = "Specifies the BYOL Type for this Virtual Machine. Possible values are `Windows_Client` and `Windows_Server` if set."
  type        = string
  default     = null
}

variable "os_disk_size_gb" {
  description = "Specifies the size of the OS disk in gigabytes."
  type        = string
  default     = null
}

variable "os_disk_storage_account_type" {
  description = "The Type of Storage Account which should back this the Internal OS Disk. Possible values are `Standard_LRS`, `StandardSSD_LRS`, `Premium_LRS`, `StandardSSD_ZRS` and `Premium_ZRS`."
  type        = string
  default     = "Premium_ZRS"
}

variable "os_disk_caching" {
  description = "Specifies the caching requirements for the OS Disk."
  type        = string
  default     = "ReadWrite"
}

variable "identity" {
  description = "Map with identity block informations as described here https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#identity."
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = {
    type         = "SystemAssigned"
    identity_ids = []
  }
}

variable "backup_policy_id" {
  description = "Backup policy ID from the Recovery Vault to attach the Virtual Machine to (value to `null` to disable backup)."
  type        = string
  default     = null
}

## Patching variables
variable "patch_mode" {
  description = "Specifies the mode of in-guest patching to this Windows Virtual Machine. Possible values are Manual, `AutomaticByOS` and `AutomaticByPlatform`. It also active path assessment when set to `AutomaticByPlatform`"
  type        = string
  default     = "AutomaticByOS"
}

variable "hotpatching_enabled" {
  description = "Should the VM be patched without requiring a reboot? Possible values are `true` or `false`."
  type        = bool
  default     = false
}

variable "maintenance_configuration_ids" {
  description = "List of maintenance configurations to attach to this VM."
  type        = list(string)
  default     = []
}

variable "patching_reboot_setting" {
  description = "Specifies the reboot setting for platform scheduled patching. Possible values are `Always`, `IfRequired` and `Never`."
  type        = string
  default     = "IfRequired"
  nullable    = false
}

variable "spot_instance" {
  description = "True to deploy VM as a Spot Instance"
  type        = bool
  default     = false
}

variable "spot_instance_max_bid_price" {
  description = "The maximum price you're willing to pay for this VM in US Dollars; must be greater than the current spot price. `-1` If you don't want the VM to be evicted for price reasons."
  type        = number
  default     = -1
}

variable "spot_instance_eviction_policy" {
  description = "Specifies what should happen when the Virtual Machine is evicted for price reasons when using a Spot instance. At this time the only supported value is `Deallocate`. Changing this forces a new resource to be created."
  type        = string
  default     = "Deallocate"
}

## managed disk variables
variable "storage_data_disk_config" {
  description = "Map of objects to configure storage data disk(s)."
  type = map(object({
    name                 = optional(string)
    create_option        = optional(string, "Empty")
    disk_size_gb         = number
    lun                  = optional(number)
    caching              = optional(string, "ReadWrite")
    storage_account_type = optional(string, "StandardSSD_ZRS")
    source_resource_id   = optional(string)
    extra_tags           = optional(map(string), {})
  }))
  default = {}
}

## diagnostics variables
variable "diagnostics_storage_account_uri" {
  description = "Name of the Storage Account uri for boot diagnostics and for legacy monitoring agent. i.e. https://<storageAccountName>.blob.core.windows.net"
  type        = string
  default     = null
}

variable "diagnostics_storage_account_key" {
  description = "Access key of the Storage Account used for Virtual Machine diagnostics. Used only with legacy monitoring agent, set to `null` if not needed."
  type        = string
  default     = null
}

## virtual machine extensions
variable "vm_extensions" {
  description = "Map of objects to configure extensions."
  type = map(object({
    name                       = optional(string)     # The name of the virtual machine extension peering. Changing this forces a new resource to be created.
    publisher                  = optional(string)     # The publisher of the extension, available publishers can be found by using the Azure CLI. Changing this forces a new resource to be created.
    type                       = optional(string)     #   The type of extension, available types for a publisher can be found using the Azure CLI.
    type_handler_version       = optional(string)     # Specifies the version of the extension to use, available versions can be found using the Azure CLI.
    auto_upgrade_minor_version = optional(bool, true) # Specifies if the platform deploys the latest minor version update to the type_handler_version specified.
    automatic_upgrade_enabled  = optional(bool, true) # Should the Extension be automatically updated whenever the Publisher releases a new version of this VM Extension?
    settings                   = optional(any)        # The settings passed to the extension, these are specified as a JSON object in a string.
  }))
  default = {}
}

## data collection rule
# variable "enable_data_collection_rule" {
#   description = "Flag to deploy data collection rule to Log analytics workspace for VM"
#   type        = bool
#   default     = true
# }

# variable "log_analytics_workspace" {
#   description = "LAW that data collection rule should be sent to"
#   type        = string
#   default     = null
# }
