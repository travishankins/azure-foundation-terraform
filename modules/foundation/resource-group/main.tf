locals {
  # Common tags that should be applied to all resources
  default_tags = {
    ManagedBy   = "Terraform"
    Module      = "resource-group"
    CreatedDate = formatdate("YYYY-MM-DD", timestamp())
  }

  # Merge provided tags with default tags
  merged_tags = merge(local.default_tags, var.tags)
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name       = var.name
  location   = var.location
  managed_by = var.managed_by
  tags       = local.merged_tags

  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      tags["CreatedDate"]
    ]
  }
}