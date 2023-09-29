resource "azurerm_data_factory" "default" {
  name                = "adf-${var.workload}"
  location            = var.location
  resource_group_name = var.group

  managed_virtual_network_enabled = var.managed_virtual_network_enabled
  public_network_enabled          = var.public_network_enabled
}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "lake" {
  name                = "Lake"
  data_factory_id     = azurerm_data_factory.default.id
  url                 = var.datalake_primary_dfs_endpoint
  storage_account_key = var.datalake_primary_access_key
}

resource "azurerm_data_factory_integration_runtime_azure" "default" {
  name                    = "Azure001"
  data_factory_id         = azurerm_data_factory.default.id
  location                = var.location
  virtual_network_enabled = var.ir_virtual_network_enabled
}
