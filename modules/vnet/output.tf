output "vnet_id" {
  value = azurerm_virtual_network.default.id
}

output "default_subnet_id" {
  value = azurerm_subnet.default.id
}

output "databricks_public_subnet_id" {
  value = azurerm_subnet.databricks_public.id
}

output "databricks_private_subnet_id" {
  value = azurerm_subnet.databricks_private.id
}

### Databricks ###
output "databricks_public_subnet_name" {
  value = azurerm_subnet.databricks_public.name
}

output "databricks_private_subnet_name" {
  value = azurerm_subnet.databricks_private.name
}

output "databricks_public_subnet_nsg_association_id" {
  value = azurerm_subnet_network_security_group_association.databrics_public.id
}

output "databricks_private_subnet_nsg_association_id" {
  value = azurerm_subnet_network_security_group_association.databricks_private.id
}
