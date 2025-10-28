locals {
  namespace             = "${var.solution_name}-${var.resource_type_abbrv}-${var.environment}-${var.resource_instance_count}"
  hostname              = replace(local.namespace, "-", "")
  vm_hostname           = coalesce(var.custom_computer_name, local.hostname)
  vm_os_disk_name       = "${local.namespace}-osdisk"
  vm_nic_name           = "${local.namespace}-nic"
  ip_configuration_name = "${local.namespace}-nic-ipconfig"
  vm_pub_ip_name        = "${local.namespace}-pub-ip"
}

# Use this data source to access the configuration of the azurerm provider
data "azurerm_client_config" "current" {}

# networking resources
## netwowrk interface
resource "azurerm_network_interface" "main" {
  name                = local.vm_nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = local.ip_configuration_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.static_private_ip == null ? "Dynamic" : "Static"
    private_ip_address            = var.static_private_ip
    public_ip_address_id          = one(azurerm_public_ip.main[*].id)
  }

  tags = merge(var.tags,
    {
      "vm_name" = local.namespace
    }
  )
}

## public IP
resource "azurerm_public_ip" "main" {
  count = var.public_ip_sku == null ? 0 : 1

  name                = local.vm_pub_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  domain_name_label   = coalesce(var.custom_dns_label, local.namespace)
  sku                 = var.public_ip_sku
  zones               = var.public_ip_zones

  tags = merge(var.tags,
    {
      "vm_name" = local.namespace
    }
  )
}


# windows virtual machine resource block
resource "azurerm_windows_virtual_machine" "main" {
  # required attributes
  name                = local.namespace
  location            = var.location
  resource_group_name = var.resource_group_name

  network_interface_ids = [azurerm_network_interface.main.id]
  size                  = var.vm_size
  license_type          = var.license_type
  admin_username        = var.admin_username
  admin_password        = var.admin_password

  # optional attributes
  source_image_id                                        = var.vm_image_id
  availability_set_id                                    = var.availability_set_id
  computer_name                                          = local.vm_hostname
  priority                                               = var.spot_instance ? "Spot" : "Regular"
  max_bid_price                                          = var.spot_instance ? var.spot_instance_max_bid_price : null
  eviction_policy                                        = var.spot_instance ? var.spot_instance_eviction_policy : null
  custom_data                                            = var.custom_data
  user_data                                              = var.user_data
  zone                                                   = var.zone_id
  provision_vm_agent                                     = true
  enable_automatic_updates                               = true
  patch_mode                                             = var.patch_mode
  patch_assessment_mode                                  = var.patch_mode == "AutomaticByPlatform" ? var.patch_mode : "ImageDefault"
  hotpatching_enabled                                    = var.hotpatching_enabled
  bypass_platform_safety_checks_on_user_schedule_enabled = var.patch_mode == "AutomaticByPlatform"
  reboot_setting                                         = var.patch_mode == "AutomaticByPlatform" ? var.patching_reboot_setting : null


  # blocks
  dynamic "source_image_reference" {
    for_each = var.vm_image_id == null ? ["enabled"] : []
    content {
      offer     = lookup(var.vm_image, "offer", null)
      publisher = lookup(var.vm_image, "publisher", null)
      sku       = lookup(var.vm_image, "sku", null)
      version   = lookup(var.vm_image, "version", null)
    }
  }

  dynamic "plan" {
    for_each = var.vm_plan[*]
    content {
      name      = var.vm_plan.name
      product   = var.vm_plan.product
      publisher = var.vm_plan.publisher
    }
  }

  boot_diagnostics {
    storage_account_uri = var.diagnostics_storage_account_key != null ? null : var.diagnostics_storage_account_uri
  }

  os_disk {
    name                 = local.vm_os_disk_name
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }

  dynamic "identity" {
    for_each = var.identity != null ? ["enabled"] : []
    content {
      type         = var.identity.type
      identity_ids = var.identity.identity_ids
    }
  }

  tags = var.tags
}

# vm managed disk
resource "azurerm_managed_disk" "main" {
  for_each = var.storage_data_disk_config

  location            = var.location
  resource_group_name = var.resource_group_name

  name = coalesce(each.value.name, format("%s-datadisk%s", local.namespace, each.key))

  zone                 = can(regex("_zrs$", lower(each.value.storage_account_type))) ? null : var.zone_id
  storage_account_type = each.value.storage_account_type
  create_option        = each.value.create_option
  disk_size_gb         = each.value.disk_size_gb
  source_resource_id   = contains(["Copy", "Restore"], each.value.create_option) ? each.value.source_resource_id : null

  tags = merge(var.tags, each.value.extra_tags)
}

resource "azurerm_virtual_machine_data_disk_attachment" "main" {
  for_each = var.storage_data_disk_config

  managed_disk_id    = azurerm_managed_disk.main[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.main.id

  lun     = coalesce(each.value.lun, index(keys(var.storage_data_disk_config), each.key))
  caching = each.value.caching
}

# vm extensions
resource "azurerm_virtual_machine_extension" "main" {
  for_each = var.vm_extensions

  name                       = each.value.name
  virtual_machine_id         = azurerm_windows_virtual_machine.main.id
  publisher                  = each.value.publisher
  type                       = each.value.type
  type_handler_version       = each.value.type_handler_version
  auto_upgrade_minor_version = each.value.auto_upgrade_minor_version
  automatic_upgrade_enabled  = each.value.automatic_upgrade_enabled

  settings = each.value.settings


  tags = var.tags
}

# data Collection rule for diagnostic settings
# resource "azurerm_monitor_data_collection_rule" "main" {
#   count = var.enable_data_collection_rule == true ? 1 : 0

#   name                = "${local.namespace}-DCR"
#   resource_group_name = var.resource_group_name
#   location            = var.location

#   data_sources {

#     performance_counter {
#       counter_specifiers            = ["\\VmInsights\\DetailedMetrics"]
#       name                          = "VMInsightsPerfCounters"
#       sampling_frequency_in_seconds = 60
#       streams                       = ["Microsoft-InsightsMetrics"]
#     }

#     windows_event_log {
#       streams = ["Microsoft-Event"]
#       name    = "eventLogsDataSource"
#       x_path_queries = [
#         "Application!*[System[(Level=1 or Level=2 or Level=3)]]",
#         "Security!*[System[(band(Keywords,13510798882111488))]]",
#         "System!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]"
#       ]
#     }

#     extension {
#       extension_name = "DependencyAgent"
#       name           = "DependencyAgentDataSource"
#       streams        = ["Microsoft-ServiceMap"]
#     }

#   }

#   destinations {

#     log_analytics {
#       name                  = "VMInsightsPerf-Logs-Dest"
#       workspace_resource_id = var.log_analytics_workspace
#     }
#   }

#   data_flow {
#     destinations  = ["VMInsightsPerf-Logs-Dest"]
#     streams       = ["Microsoft-Perf"]
#     output_stream = "Microsoft-Perf"
#   }

#   data_flow {
#     destinations  = ["VMInsightsPerf-Logs-Dest"]
#     streams       = ["Microsoft-Event"]
#     output_stream = "Microsoft-Event"
#   }

# }

# # associate to a Data Collection Rule
# resource "azurerm_monitor_data_collection_rule_association" "main" {
#   count = var.enable_data_collection_rule == true ? 1 : 0

#   name                    = "${local.namespace}-DCRA"
#   target_resource_id      = azurerm_windows_virtual_machine.main.id
#   data_collection_rule_id = azurerm_monitor_data_collection_rule.main[count.index].id
#   description             = "associating data collection rule with virtual machine."
# }
