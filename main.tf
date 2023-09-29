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
  source    = "./modules/datalake"
  workload  = local.workload
  group     = azurerm_resource_group.default.name
  location  = azurerm_resource_group.default.location
  subnet_id = module.vnet.subnet
}
