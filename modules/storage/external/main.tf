data "azuread_client_config" "current" {}

resource "azurerm_storage_account" "external" {
  name                          = "stextsys999"
  resource_group_name           = var.group
  location                      = var.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  account_kind                  = "StorageV2"
  enable_https_traffic_only     = true
  min_tls_version               = "TLS1_2"
  public_network_access_enabled = true
}

resource "azurerm_role_assignment" "external" {
  scope                = azurerm_storage_account.external.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_client_config.current.object_id
}
