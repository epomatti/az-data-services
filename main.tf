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

### Group ###

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.workload}"
  location = var.location
}

### Data Lake ###
module "lake" {
  source   = "./modules/datalake"
  workload = local.workload
  group    = azurerm_resource_group.default.name
  location = azurerm_resource_group.default.location
}
