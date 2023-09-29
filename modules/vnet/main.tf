resource "azurerm_virtual_network" "default" {
  name                = "vnet-${var.workload}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.group
}

resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = var.group
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.2.0/24"]
  # service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage"]
  service_endpoints = ["Microsoft.Storage"]
}
