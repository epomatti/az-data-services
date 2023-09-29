terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.74.0"
    }
  }
}

locals {
  workload = "databoss"
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.workload}"
  location = var.location
}

module "vnet" {
  source   = "./modules/vnet"
  workload = local.workload
  group    = azurerm_resource_group.default.name
  location = azurerm_resource_group.default.location
}

module "lake" {
  source   = "./modules/datalake"
  workload = local.workload
  group    = azurerm_resource_group.default.name
  location = azurerm_resource_group.default.location

  vnet_id                       = module.vnet.vnet_id
  subnet_id                     = module.vnet.subnet
  public_ip_address_to_allow    = var.public_ip_address_to_allow
  public_network_access_enabled = var.datalake_public_network_access_enabled
}

module "adf" {
  source   = "./modules/adf"
  workload = local.workload
  group    = azurerm_resource_group.default.name
  location = azurerm_resource_group.default.location

  managed_virtual_network_enabled = var.adf_managed_virtual_network_enabled
  public_network_enabled          = var.adf_public_network_enabled
  datalake_primary_dfs_endpoint   = module.lake.primary_dfs_endpoint
  datalake_primary_access_key     = module.lake.primary_access_key
  ir_virtual_network_enabled      = var.adf_ir_virtual_network_enabled
}
