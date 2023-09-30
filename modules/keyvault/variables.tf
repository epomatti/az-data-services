variable "group" {
  type = string
}

variable "location" {
  type = string
}

variable "workload" {
  type = string
}

variable "mssql_admin_login" {
  type = string
}

variable "mssql_admin_login_password" {
  type      = string
  sensitive = true
}

variable "datalake_connection_string" {
  type      = string
  sensitive = true
}

variable "datalake_access_key" {
  type      = string
  sensitive = true
}

variable "databricks_sp_secret" {
  type      = string
  sensitive = true
}
