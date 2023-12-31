terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.79.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.45.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "1.10.0"
    }
  }
}

locals {
  workload = "databoss"
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.workload}"
  location = var.location
}

module "vnet" {
  source   = "./modules/vnet"
  workload = local.workload
  group    = azurerm_resource_group.default.name
  location = azurerm_resource_group.default.location
}

module "aad" {
  source = "./modules/aad"
}

module "datalake" {
  source   = "./modules/datalake"
  workload = local.workload
  group    = azurerm_resource_group.default.name
  location = azurerm_resource_group.default.location

  vnet_id                                = module.vnet.vnet_id
  default_subnet_id                      = module.vnet.default_subnet_id
  databricks_public_subnet_id            = module.vnet.databricks_public_subnet_id
  databricks_private_subnet_id           = module.vnet.databricks_private_subnet_id
  public_ip_address_to_allow             = var.public_ip_address_to_allow
  public_network_access_enabled          = var.datalake_public_network_access_enabled
  databricks_service_principal_object_id = module.aad.service_principal_object_id
}

module "external_storage" {
  source   = "./modules/storage/external"
  group    = azurerm_resource_group.default.name
  location = azurerm_resource_group.default.location
}

module "outbound_storage" {
  source   = "./modules/storage/outbound"
  workload = local.workload
  group    = azurerm_resource_group.default.name
  location = azurerm_resource_group.default.location

  vnet_id                       = module.vnet.vnet_id
  subnet_id                     = module.vnet.default_subnet_id
  public_ip_address_to_allow    = var.public_ip_address_to_allow
  public_network_access_enabled = var.outbound_storage_public_network_access_enabled
}

module "adf" {
  source   = "./modules/adf"
  workload = local.workload
  group    = azurerm_resource_group.default.name
  location = azurerm_resource_group.default.location

  managed_virtual_network_enabled = var.adf_managed_virtual_network_enabled
  public_network_enabled          = var.adf_public_network_enabled
  datalake_primary_dfs_endpoint   = module.datalake.primary_dfs_endpoint
  datalake_primary_access_key     = module.datalake.primary_access_key
  ir_virtual_network_enabled      = var.adf_ir_virtual_network_enabled
  storage_account_id              = module.datalake.storage_account_id

  # External Storage
  external_storage_connection_string = module.external_storage.primary_blob_connection_string
}

module "databricks" {
  source   = "./modules/databricks"
  workload = local.workload
  group    = azurerm_resource_group.default.name
  location = azurerm_resource_group.default.location

  sku                           = var.dbw_sku
  public_network_access_enabled = var.dbw_public_network_access_enabled

  vnet_id                                           = module.vnet.vnet_id
  vnet_no_public_ip                                 = var.dbw_vnet_no_public_ip
  databricks_vnet_public_subnet_name                = module.vnet.databricks_public_subnet_name
  databricks_vnet_private_subnet_name               = module.vnet.databricks_private_subnet_name
  databricks_vnet_public_subnet_nsg_association_id  = module.vnet.databricks_public_subnet_nsg_association_id
  databricks_vnet_private_subnet_nsg_association_id = module.vnet.databricks_private_subnet_nsg_association_id
}

module "mssql" {
  source   = "./modules/mssql"
  workload = local.workload
  group    = azurerm_resource_group.default.name
  location = azurerm_resource_group.default.location

  sku                           = var.mssql_sku
  max_size_gb                   = var.mssql_max_size_gb
  public_ip_address_to_allow    = var.public_ip_address_to_allow
  public_network_access_enabled = var.mssql_public_network_access_enabled
  admin_admin                   = var.mssql_admin_login
  admin_login_password          = var.mssql_admin_login_password
  default_subnet_id             = module.vnet.default_subnet_id
  databricks_public_subnet_id   = module.vnet.databricks_public_subnet_id
  databricks_private_subnet_id  = module.vnet.databricks_private_subnet_id
}

module "synapse" {
  source   = "./modules/synapse"
  workload = local.workload
  group    = azurerm_resource_group.default.name
  location = azurerm_resource_group.default.location

  sku_name                             = var.synapse_sku_name
  sql_administrator_login              = var.synapse_sql_administrator_login
  sql_administrator_login_password     = var.synapse_sql_administrator_login_password
  storage_data_lake_gen2_filesystem_id = module.datalake.synapse_filesystem_id
  public_ip_address_to_allow           = var.public_ip_address_to_allow
  public_network_access_enabled        = var.synapse_public_network_access_enabled
  vnet_id                              = module.vnet.vnet_id
  default_subnet_id                    = module.vnet.default_subnet_id
  datalake_storage_account_id          = module.datalake.storage_account_id
}

module "bus" {
  source   = "./modules/bus"
  workload = local.workload
  group    = azurerm_resource_group.default.name
  location = azurerm_resource_group.default.location
}

module "function" {
  source   = "./modules/function"
  workload = local.workload
  group    = azurerm_resource_group.default.name
  location = azurerm_resource_group.default.location

  servicebus_connection_string  = module.bus.primary_connection_string
  public_network_access_enabled = var.function_public_network_access_enabled
}

module "keyvault" {
  source   = "./modules/keyvault"
  workload = local.workload
  group    = azurerm_resource_group.default.name
  location = azurerm_resource_group.default.location

  mssql_admin_login                        = var.mssql_admin_login
  mssql_admin_login_password               = var.mssql_admin_login_password
  datalake_connection_string               = module.datalake.primary_connection_string
  datalake_access_key                      = module.datalake.primary_access_key
  databricks_sp_secret                     = module.aad.service_credential_secret_value
  synapse_sql_administrator_login          = var.synapse_sql_administrator_login
  synapse_sql_administrator_login_password = var.synapse_sql_administrator_login_password
  bus_connection_string                    = module.bus.primary_connection_string
}

resource "local_file" "databricks_tfvars" {
  content = <<EOF
workspace_url        = "${module.databricks.workspace_url}"
keyvault_resource_id = "${module.keyvault.id}"
keyvault_uri         = "${module.keyvault.vault_uri}"
mssql_fqdn           = "${module.mssql.fully_qualified_domain_name}"
dls_name             = "${module.datalake.storage_account_name}"
sp_tenant_id         = "${module.aad.tenant_id}"
sp_client_id         = "${module.aad.client_id}"
synapse_sql_endpoint = "${module.synapse.connectivity_endpoints.sql}"
EOF

  filename = "${path.module}/databricks/.auto.tfvars"
}
