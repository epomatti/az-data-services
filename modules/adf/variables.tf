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
