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
  type = string
}

variable "sku" {
  type = string
}

variable "vnet_id" {
  type = string
}

variable "vnet_no_public_ip" {
  type = bool
}

variable "databricks_vnet_public_subnet_name" {
  type = string
}

variable "databricks_vnet_private_subnet_name" {
  type = string
}

variable "databricks_vnet_public_subnet_nsg_association_id" {
  type = string
}

variable "databricks_vnet_private_subnet_nsg_association_id" {
  type = string
}
