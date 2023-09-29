resource "azurerm_data_factory" "default" {
  name                = "adf-${var.workload}"
  location            = var.location
  resource_group_name = var.group

  managed_virtual_network_enabled = var.managed_virtual_network_enabled
  public_network_enabled          = var.public_network_enabled
}


### Data Lake ###
resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "lake" {
  name                     = "Lake"
  data_factory_id          = azurerm_data_factory.default.id
  url                      = var.datalake_primary_dfs_endpoint
  storage_account_key      = var.datalake_primary_access_key
  integration_runtime_name = azurerm_data_factory_integration_runtime_azure.default.name
}

resource "azurerm_data_factory_managed_private_endpoint" "lake" {
  name               = "datalake"
  data_factory_id    = azurerm_data_factory.default.id
  target_resource_id = var.storage_account_id
  subresource_name   = "dfs"
}

### External Storage ###
resource "azurerm_data_factory_linked_service_azure_blob_storage" "external" {
  name              = "external-storage"
  data_factory_id   = azurerm_data_factory.default.id
  connection_string = var.external_storage_connection_string
}


### Integration Runtime ###

resource "azurerm_data_factory_integration_runtime_azure" "default" {
  name                    = "Azure001"
  data_factory_id         = azurerm_data_factory.default.id
  location                = var.location
  virtual_network_enabled = var.ir_virtual_network_enabled
  time_to_live_min        = 60
}
