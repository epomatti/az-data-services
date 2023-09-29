variable "location" {
  type    = string
  default = "brazilsouth"
}

variable "public_ip_address_to_allow" {
  type = string
}

variable "adf_managed_virtual_network_enabled" {
  type = bool
}

variable "adf_public_network_enabled" {
  type = bool
}
