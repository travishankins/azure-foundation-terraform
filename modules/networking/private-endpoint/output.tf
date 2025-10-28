output "private_endpoint" {
  value       = azurerm_private_endpoint.main
  description = "All metadata outputs for the created private endpoint."
  sensitive   = false
}

output "private_dns_a_record" {
  value       = azurerm_private_dns_a_record.main
  description = "All metadata outputs for the created private dns a record."
}