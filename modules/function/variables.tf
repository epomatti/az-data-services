variable "workload" {
  type = string
}

variable "location" {
  type = string
}

variable "group" {
  type = string
}

variable "servicebus_connection_string" {
  type      = string
  sensitive = true
}

variable "public_network_access_enabled" {
  type = bool
}
