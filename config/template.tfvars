location = "eastus"

public_ip_address_to_allow = ""

# Data Lake
datalake_public_network_access_enabled = true

# Data Factory
adf_managed_virtual_network_enabled = true
adf_public_network_enabled          = true
adf_ir_virtual_network_enabled      = true

# Databricks
dbw_public_network_access_enabled = true
dbw_sku                           = "trial"
dbw_vnet_no_public_ip             = false

# SQL Database
mssql_sku                  = "Basic"
mssql_max_size_gb          = 2
mssql_admin_login_password = "p4ssw0rd"
