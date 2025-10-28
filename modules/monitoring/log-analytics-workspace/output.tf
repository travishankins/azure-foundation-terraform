output "id" {
  value       = azurerm_log_analytics_workspace.main.id
  description = "The resource ID of the log analytics workspace."
  sensitive   = false
}

output "workspace_id" {
  value       = azurerm_log_analytics_workspace.main.workspace_id
  description = "The Workspace (or Customer) ID for the Log Analytics Workspace."
  sensitive   = false
}