variable "group" {
  type = string
}

variable "location" {
  type = string
}

variable "workload" {
  type = string
}

variable "public_network_access_enabled" {
  type = bool
}

variable "vnet_id" {
  type = string
}

variable "default_subnet_id" {
  type = string
}

variable "databricks_private_subnet_id" {
  type = string
}

variable "databricks_public_subnet_id" {
  type = string
}

variable "public_ip_address_to_allow" {
  type = string
}

variable "databricks_service_principal_object_id" {
  type = string
}
