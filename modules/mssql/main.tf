resource "azurerm_mssql_server" "default" {
  name                = "sqls-${var.workload}"
  resource_group_name = var.group
  location            = var.location
  version             = "12.0"
  minimum_tls_version = "1.2"

  administrator_login          = var.admin_admin
  administrator_login_password = var.admin_login_password

  public_network_access_enabled = var.public_network_access_enabled

  # azuread_administrator {
  #   login_username = "AzureAD Admin"
  #   object_id      = "00000000-0000-0000-0000-000000000000"
  # }
}

resource "azurerm_mssql_database" "default" {
  name                 = "sqldb-${var.workload}"
  server_id            = azurerm_mssql_server.default.id
  max_size_gb          = var.max_size_gb
  read_scale           = false
  sku_name             = var.sku
  zone_redundant       = false
  storage_account_type = "Local"
}

resource "azurerm_mssql_firewall_rule" "local" {
  name             = "FirewallRuleLocal"
  server_id        = azurerm_mssql_server.default.id
  start_ip_address = var.public_ip_address_to_allow
  end_ip_address   = var.public_ip_address_to_allow
}

resource "azurerm_mssql_virtual_network_rule" "default" {
  name      = "default-subnet"
  server_id = azurerm_mssql_server.default.id
  subnet_id = var.default_subnet_id
}

resource "azurerm_mssql_virtual_network_rule" "databricks_public" {
  name      = "databricks-public-subnet"
  server_id = azurerm_mssql_server.default.id
  subnet_id = var.databricks_public_subnet_id
}

resource "azurerm_mssql_virtual_network_rule" "databricks_private" {
  name      = "databricks-private-subnet"
  server_id = azurerm_mssql_server.default.id
  subnet_id = var.databricks_private_subnet_id
}
