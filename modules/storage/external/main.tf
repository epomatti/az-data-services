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
