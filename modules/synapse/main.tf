data "azuread_client_config" "current" {}

resource "azurerm_synapse_workspace" "default" {
  name                                 = "synw-${var.workload}"
  resource_group_name                  = var.group
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = var.storage_data_lake_gen2_filesystem_id
  sql_administrator_login              = var.sql_administrator_login
  sql_administrator_login_password     = var.sql_administrator_login_password

  managed_resource_group_name     = "rg-${var.workload}-synapse"
  public_network_access_enabled   = var.public_network_access_enabled
  managed_virtual_network_enabled = true

  aad_admin {
    login     = "AzureAD Admin"
    object_id = data.azuread_client_config.current.object_id
    tenant_id = data.azuread_client_config.current.tenant_id
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_synapse_sql_pool" "pool1" {
  name                      = "pool1"
  synapse_workspace_id      = azurerm_synapse_workspace.default.id
  sku_name                  = var.sku_name
  create_mode               = "Default"
  geo_backup_policy_enabled = false
  storage_account_type      = "LRS"
  collation                 = "SQL_LATIN1_GENERAL_CP1_CI_AS"
}

resource "azurerm_synapse_managed_private_endpoint" "datalake" {
  name                 = "datalake"
  synapse_workspace_id = azurerm_synapse_workspace.default.id
  target_resource_id   = var.datalake_storage_account_id
  subresource_name     = "dfs"

  # depends_on = [azurerm_synapse_firewall_rule.allow_all]
}

resource "azurerm_synapse_firewall_rule" "allow_all" {
  name                 = "AllowAll"
  synapse_workspace_id = azurerm_synapse_workspace.default.id
  start_ip_address     = var.public_ip_address_to_allow # "0.0.0.0"
  end_ip_address       = var.public_ip_address_to_allow # "255.255.255.255"
}

resource "azurerm_synapse_firewall_rule" "allow_access_to_azure_services" {
  name                 = "AllowAllWindowsAzureIps"
  synapse_workspace_id = azurerm_synapse_workspace.default.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "0.0.0.0"
}

### Private Endpoint ###
resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.sql.azuresynapse.net"
  resource_group_name = var.group
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql" {
  name                  = "synapse-sql-link"
  resource_group_name   = var.group
  private_dns_zone_name = azurerm_private_dns_zone.sql.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = true
}

resource "azurerm_private_endpoint" "sql" {
  name                = "pe-synapse-sql"
  location            = var.location
  resource_group_name = var.group
  subnet_id           = var.default_subnet_id

  private_dns_zone_group {
    name = azurerm_private_dns_zone.sql.name
    private_dns_zone_ids = [
      azurerm_private_dns_zone.sql.id
    ]
  }

  private_service_connection {
    name                           = "synapse"
    private_connection_resource_id = azurerm_synapse_workspace.default.id
    is_manual_connection           = false
    subresource_names              = ["Sql"]
  }
}
