resource "azurerm_servicebus_namespace" "default" {
  name                = "bus-${var.workload}"
  location            = var.location
  resource_group_name = var.group
  sku                 = "Basic"
}

resource "azurerm_servicebus_queue" "databricks" {
  name                = "databricks"
  namespace_id        = azurerm_servicebus_namespace.default.id
  enable_partitioning = true
}
