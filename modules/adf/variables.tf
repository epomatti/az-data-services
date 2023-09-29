variable "group" {
  type = string
}

variable "location" {
  type = string
}

variable "workload" {
  type = string
}

variable "managed_virtual_network_enabled" {
  type = bool
}

variable "public_network_enabled" {
  type = bool
}

variable "ir_virtual_network_enabled" {
  type = bool
}

variable "storage_account_id" {
  type = string
}

# variable "subnet_id" {
#   type = string
# }

# variable "public_ip_address_to_allow" {
#   type = string
# }

variable "datalake_primary_dfs_endpoint" {
  type = string
}

variable "datalake_primary_access_key" {
  type      = string
  sensitive = true
}


### External Storage ###
variable "external_storage_connection_string" {
  type      = string
  sensitive = true
}
