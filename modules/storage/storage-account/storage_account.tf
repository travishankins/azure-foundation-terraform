# Storage Account
locals {
  storage_account_name = lower("${var.solution_name}${var.resource_type_abbrv}${random_string.random.result}${var.environment}${var.resource_instance_count}")

  ace_per_filesystem = flatten([
    for fs in var.datalake_filesystems : [
      for ace in fs.aces : merge({ container_name = fs.name }, ace)
    ]
  ])
}

# Use this data source to access the configuration of the azurerm provider
data "azurerm_client_config" "current" {}

# random string generator for key vault name
resource "random_string" "random" {
  length    = 3
  special   = false
  min_lower = 3
}

resource "azurerm_storage_account" "main" {
  # Required Attributes
  name                = local.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.location

  account_tier             = var.account_kind == "BlockBlobStorage" || var.account_kind == "FileStorage" ? "Premium" : var.account_tier
  account_replication_type = var.account_replication_type

  # Optional Attributes
  account_kind                      = var.account_kind
  access_tier                       = var.access_tier
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public
  default_to_oauth_authentication   = var.default_to_oauth_authentication
  https_traffic_only_enabled        = var.enable_https_traffic_only
  infrastructure_encryption_enabled = var.account_kind == "StorageV2" || (var.account_kind == "BlockBlobStorage" && var.account_tier == "Premium") ? var.infrastructure_encryption_enabled : false
  is_hns_enabled                    = var.account_tier == "Standard" || var.account_kind == "BlockBlobStorage" ? var.is_hns_enabled : false
  min_tls_version                   = var.min_tls_version
  nfsv3_enabled                     = var.nfsv3_enabled
  public_network_access_enabled     = var.public_network_access_enabled
  queue_encryption_key_type         = var.account_kind == "StorageV2" ? var.queue_encryption_key_type : "Service"
  sftp_enabled                      = var.is_hns_enabled == true ? var.sftp_enabled : false
  shared_access_key_enabled         = var.shared_access_key_enabled
  table_encryption_key_type         = var.account_kind == "StorageV2" ? var.table_encryption_key_type : "Service"
  large_file_share_enabled          = var.large_file_share_enabled

  # Blocks

  identity {
    type         = var.identity.type
    identity_ids = var.identity.identity_ids
  }

  dynamic "blob_properties" {
    for_each = (
    var.account_kind != "FileStorage" ? ["enabled"] : [])

    content {
      # Optional Attributes
      versioning_enabled       = var.storage_blob_properties.versioning_enabled
      change_feed_enabled      = var.storage_blob_properties.change_feed_enabled
      default_service_version  = var.storage_blob_properties.default_service_version
      last_access_time_enabled = var.storage_blob_properties.last_access_time_enabled

      # Optional Attributes
      change_feed_retention_in_days = var.storage_blob_properties.change_feed_retention_in_days

      dynamic "cors_rule" {
        for_each = var.storage_blob_cors_rule == null ? [] : ["enabled"]
        content {
          # Requred Attributes
          allowed_headers    = var.storage_blob_cors_rule.allowed_headers
          allowed_methods    = var.storage_blob_cors_rule.allowed_methods
          allowed_origins    = var.storage_blob_cors_rule.allowed_origins
          exposed_headers    = var.storage_blob_cors_rule.exposed_headers
          max_age_in_seconds = var.storage_blob_cors_rule.max_age_in_seconds
        }
      }

      delete_retention_policy {
        days = var.blob_delete_retention_days
      }

      dynamic "restore_policy" {
        for_each = var.storage_blob_properties.versioning_enabled == true && var.blob_delete_retention_days != null ? ["enabled"] : []
        content {
          days = var.restore_policy_days
        }
      }

      container_delete_retention_policy {
        days = var.container_delete_retention_policy_days
      }
    }
  }

  dynamic "queue_properties" {
    for_each = var.queue_cors_rule == null || var.queue_logging == null ? [] : ["enabled"]
    content {
      dynamic "cors_rule" {
        for_each = var.queue_cors_rule == null ? [] : ["enabled"]
        content {
          # Requred Attributes
          allowed_headers    = var.queue_cors_rule.allowed_headers
          allowed_methods    = var.queue_cors_rule.allowed_methods
          allowed_origins    = var.queue_cors_rule.allowed_origins
          exposed_headers    = var.queue_cors_rule.exposed_headers
          max_age_in_seconds = var.queue_cors_rule.max_age_in_seconds
        }
      }

      dynamic "logging" {
        for_each = var.queue_logging == null ? [] : ["enabled"]
        content {
          delete                = var.queue_logging.delete
          read                  = var.queue_logging.read
          version               = var.queue_logging.version
          write                 = var.queue_logging.write
          retention_policy_days = var.queue_logging.retention_policy_days
        }
      }

      dynamic "minute_metrics" {
        for_each = var.queue_metrics.enabled == false ? [] : ["enabled"]
        content {
          enabled               = true
          version               = var.queue_metrics.minute_version
          include_apis          = var.queue_metrics.minute_include_apis
          retention_policy_days = var.queue_metrics.minute_retention_policy_days
        }
      }
      dynamic "hour_metrics" {
        for_each = var.queue_metrics.enabled == false ? [] : ["enabled"]
        content {
          enabled               = true
          version               = var.queue_metrics.hour_version
          include_apis          = var.queue_metrics.hour_include_apis
          retention_policy_days = var.queue_metrics.hour_retention_policy_days
        }
      }
    }
  }

  dynamic "share_properties" {
    for_each = var.share_cors_rule == null || var.share_smb == null ? [] : ["enabled"]
    content {
      dynamic "cors_rule" {
        for_each = var.share_cors_rule == {} ? [] : ["enabled"]
        content {
          # Requred Attributes
          allowed_headers    = var.share_cors_rule.allowed_headers
          allowed_methods    = var.share_cors_rule.allowed_methods
          allowed_origins    = var.share_cors_rule.allowed_origins
          exposed_headers    = var.share_cors_rule.exposed_headers
          max_age_in_seconds = var.share_cors_rule.max_age_in_seconds
        }
      }

      retention_policy {
        days = var.share_retention_days
      }

      dynamic "smb" {
        for_each = var.share_smb == null ? [] : ["enabled"]
        content {
          versions                        = var.share_smb.versions
          authentication_types            = var.share_smb.authentication_types
          kerberos_ticket_encryption_type = var.share_smb.kerberos_ticket_encryption_type
          channel_encryption_type         = var.share_smb.channel_encryption_type
          multichannel_enabled            = var.share_smb.multichannel_enabled
        }
      }
    }
  }

  routing {
    publish_internet_endpoints  = var.routing.publish_internet_endpoints
    publish_microsoft_endpoints = var.routing.publish_microsoft_endpoints
    choice                      = var.routing.choice
  }

  tags = var.tags
}

# Storage Account Network Rules
resource "azurerm_storage_account_network_rules" "main" {
  count = var.network_rules_default_action == null ? 0 : 1

  storage_account_id = azurerm_storage_account.main.id

  default_action             = var.network_rules_default_action
  bypass                     = var.network_rules_bypass
  ip_rules                   = var.network_rules_ip_rules
  virtual_network_subnet_ids = var.network_rules_subnet_ids

  dynamic "private_link_access" {
    for_each = var.network_rules_private_link_access == null ? [] : ["enabled"]

    content {
      endpoint_resource_id = var.network_rules_private_link_access.endpoint_resource_id
      endpoint_tenant_id   = var.network_rules_private_link_access.endpoint_tenant_id
    }
  }

  depends_on = [
    azurerm_storage_container.main,
    azurerm_storage_data_lake_gen2_filesystem.main
  ]
}

# Storage Account Containers
resource "azurerm_storage_container" "main" {
  for_each = { for container in var.containers : container.name => container }

  name                  = each.value.name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = each.value.access_types
}

# Storage Account Data Lake Gen 2 File System
resource "azurerm_storage_data_lake_gen2_filesystem" "main" {
  # for_each = var.is_hns_enabled == true && var.account_kind == "StorageV2" ? [var.filesystem_names]: []
  for_each = var.is_hns_enabled == true && var.account_kind == "StorageV2" ? { for fs in local.ace_per_filesystem : fs.container_name => fs } : {}

  name               = each.value.container_name
  storage_account_id = azurerm_storage_account.main.id

  ace {
    id          = each.value.id
    permissions = each.value.permissions
    scope       = each.value.scope
    type        = each.value.type
  }
  ace {
    id          = null
    permissions = "rwx"
    scope       = "access"
    type        = "other"
  }
  ace {
    id          = null
    permissions = "rwx"
    scope       = "access"
    type        = "group"
  }
  ace {
    id          = null
    permissions = "rwx"
    scope       = "access"
    type        = "user"
  }

  depends_on = [time_sleep.role_assignment_sleep]
}

# Storage account Data Lake Gen 2 File System Path'
resource "azurerm_storage_data_lake_gen2_path" "main" {
  for_each = { for path in var.data_lake_file_paths : path.path => path }

  path               = each.value.path
  filesystem_name    = var.is_hns_enabled == true && var.account_kind == "StorageV2" ? each.value.filesystem_name : null
  storage_account_id = azurerm_storage_account.main.id
  resource           = "directory"

  depends_on = [azurerm_storage_data_lake_gen2_filesystem.main]
}

# Role assignment is needed to apply adls gen2 filesystem changes
resource "azurerm_role_assignment" "role_assignment" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Sleep is needed to wait for role assignment to propagate
resource "time_sleep" "role_assignment_sleep" {
  create_duration = "60s"

  triggers = {
    role_assignment = azurerm_role_assignment.role_assignment.id
  }
}