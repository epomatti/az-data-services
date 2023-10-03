output "primary_connection_string" {
  value = azurerm_servicebus_namespace.default.default_primary_connection_string
}
