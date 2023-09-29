variable "location" {
  type    = string
  default = "eastus"
}

variable "public_ip_address_to_allow" {
  type = string
}

variable "datalake_public_network_access_enabled" {
  type = bool
}

variable "adf_managed_virtual_network_enabled" {
  type = bool
}

variable "adf_public_network_enabled" {
  type = bool
}

variable "adf_ir_virtual_network_enabled" {
  type = bool
}

### Databricks ###
variable "dbw_public_network_access_enabled" {
  type = string
}

variable "dbw_sku" {
  type = string
}

variable "dbw_vnet_no_public_ip" {
  type = bool
}

### SQL Database ###
variable "mssql_sku" {
  type = string
}

variable "mssql_admin_login" {
  type = string
}

variable "mssql_admin_login_password" {
  type      = string
  sensitive = true
}

variable "mssql_public_network_access_enabled" {
  type = bool
}

### Outbound Storage ###
variable "outbound_storage_public_network_access_enabled" {
  type = bool
}
