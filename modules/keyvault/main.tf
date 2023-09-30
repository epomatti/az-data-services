data "azurerm_client_config" "current" {
}

resource "azurerm_key_vault" "databricks" {
  name                     = "kv-${var.workload}789"
  location                 = var.location
  resource_group_name      = var.group
  tenant_id                = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled = false
  sku_name                 = "standard"

  # TODO: Network
}

resource "azurerm_key_vault_access_policy" "databricks" {
  key_vault_id       = azurerm_key_vault.databricks.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azurerm_client_config.current.object_id
  secret_permissions = ["Delete", "Get", "List", "Set"]
}

resource "azurerm_key_vault_secret" "sql_database_admin_username" {
  name         = "mssqlusername"
  value        = var.mssql_admin_login
  key_vault_id = azurerm_key_vault.databricks.id
}

resource "azurerm_key_vault_secret" "sql_database_admin_password" {
  name         = "mssqlpassword"
  value        = var.mssql_admin_login_password
  key_vault_id = azurerm_key_vault.databricks.id
}

resource "azurerm_key_vault_secret" "datalake_connection_string" {
  name         = "dlsconnectionstring"
  value        = var.datalake_connection_string
  key_vault_id = azurerm_key_vault.databricks.id
}

resource "azurerm_key_vault_secret" "datalake_access_key" {
  name         = "dlsaccesskey"
  value        = var.datalake_access_key
  key_vault_id = azurerm_key_vault.databricks.id
}
