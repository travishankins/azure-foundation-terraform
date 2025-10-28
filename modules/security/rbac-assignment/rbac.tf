locals {}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "main" {
  scope                            = var.scope
  role_definition_name             = var.role_definition_name
  principal_id                     = var.principal_id
  description                      = var.description
  skip_service_principal_aad_check = var.skip_service_principal_aad_check
}