output "vnet_id" {
  value = azurerm_virtual_network.default.id
}

output "subnet" {
  value = azurerm_subnet.default.id
}
