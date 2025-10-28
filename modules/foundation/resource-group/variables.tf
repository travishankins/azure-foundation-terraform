variable "name" {
  description = "The name of the resource group"
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 90
    error_message = "Resource group name must be between 1 and 90 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9._\\-\\(\\)]+[a-zA-Z0-9._\\-\\(\\)]$", var.name))
    error_message = "Resource group name can only contain alphanumeric characters, periods, underscores, hyphens, and parentheses."
  }
}

variable "location" {
  description = "The Azure region where the resource group will be created"
  type        = string

  validation {
    condition = contains([
      "eastus", "eastus2", "southcentralus", "westus2", "westus3", "australiaeast",
      "southeastasia", "northeurope", "swedencentral", "uksouth", "westeurope",
      "centralus", "southafricanorth", "centralindia", "eastasia", "japaneast",
      "koreacentral", "canadacentral", "francecentral", "germanywestcentral",
      "norwayeast", "switzerlandnorth", "uaenorth", "brazilsouth", "eastus2euap",
      "qatarcentral", "centralusstage", "eastusstage", "eastus2stage", "northcentralusstage",
      "southcentralusstage", "westusstage", "westus2stage", "asia", "asiapacific",
      "australia", "brazil", "canada", "europe", "france", "germany", "global",
      "india", "japan", "korea", "norway", "southafrica", "switzerland", "uae",
      "uk", "unitedstates", "unitedstateseuap", "eastasiastage", "southeastasiastage",
      "northcentralus", "westus", "jioindiawest", "centraluseuap", "westcentralus",
      "southafricawest", "australiacentral", "australiacentral2", "australiasoutheast",
      "japanwest", "jioindiacentral", "koreasouth", "southindia", "westindia",
      "canadaeast", "francesouth", "germanynorth", "norwaywest", "switzerlandwest",
      "ukwest", "uaecentral", "brazilsoutheast"
    ], lower(var.location))
    error_message = "The location must be a valid Azure region."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource group"
  type        = map(string)
  default     = {}
}

variable "managed_by" {
  description = "The ID of the resource that manages this Resource Group"
  type        = string
  default     = null
}