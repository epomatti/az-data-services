data "azuread_client_config" "current" {}

resource "azurerm_storage_account" "lake" {
  name                      = "dls${var.workload}"
  resource_group_name       = var.group
  location                  = var.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  account_kind              = "StorageV2"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"

  # Hierarchical namespace
  is_hns_enabled = true

  # Networking
  public_network_access_enabled = var.public_network_access_enabled

  network_rules {
    default_action             = "Deny"
    ip_rules                   = [var.public_ip_address_to_allow]
    virtual_network_subnet_ids = [var.default_subnet_id, var.databricks_public_subnet_id, var.databricks_private_subnet_id]
    bypass                     = ["AzureServices"]
  }
}

resource "azurerm_role_assignment" "adlsv2" {
  scope                = azurerm_storage_account.lake.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_client_config.current.object_id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "default" {
  name               = "myfilesystem001"
  storage_account_id = azurerm_storage_account.lake.id

  depends_on = [
    azurerm_role_assignment.adlsv2,
  ]
}

resource "azurerm_storage_data_lake_gen2_filesystem" "external" {
  name               = "external"
  storage_account_id = azurerm_storage_account.lake.id

  depends_on = [
    azurerm_role_assignment.adlsv2,
  ]
}

# Allow Databricks AAD SP to connect
resource "azurerm_role_assignment" "databricks" {
  scope                = azurerm_storage_account.lake.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.databricks_service_principal_object_id
}

# ### Private Endpoint ###
# resource "azurerm_private_dns_zone" "default" {
#   name                = "privatelink.dfs.core.windows.net"
#   resource_group_name = var.group
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "default" {
#   name                  = "datalake-link"
#   resource_group_name   = var.group
#   private_dns_zone_name = azurerm_private_dns_zone.default.name
#   virtual_network_id    = var.vnet_id
#   registration_enabled  = true
# }

# resource "azurerm_private_endpoint" "default" {
#   name                = "pe-datalake"
#   location            = var.location
#   resource_group_name = var.group
#   subnet_id           = var.subnet_id

#   private_dns_zone_group {
#     name = azurerm_private_dns_zone.default.name
#     private_dns_zone_ids = [
#       azurerm_private_dns_zone.default.id
#     ]
#   }

#   private_service_connection {
#     name                           = "datalake"
#     private_connection_resource_id = azurerm_storage_account.lake.id
#     is_manual_connection           = false
#     subresource_names              = ["dfs"]
#   }
# }
