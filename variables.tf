variable "location" {
  type    = string
  default = "brazilsouth"
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
