data "azuread_client_config" "current" {}

resource "azurerm_storage_account" "lake" {
  name                     = "dls${var.workload}"
  resource_group_name      = var.group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  # Private-only data lake
  public_network_access_enabled = false

  # Hierarchical namespace
  is_hns_enabled = true

  network_rules {
    default_action             = "Allow"
    ip_rules                   = ["10.0.0.0/16"]
    virtual_network_subnet_ids = [var.subnet_id]
  }
}

resource "azurerm_role_assignment" "adlsv2" {
  scope                = azurerm_storage_account.lake.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_client_config.current.object_id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "default" {
  name               = "myfilesystem001"
  storage_account_id = azurerm_storage_account.lake.id

  depends_on = [
    azurerm_role_assignment.adlsv2
  ]
}
