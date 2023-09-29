resource "azurerm_databricks_workspace" "default" {
  name                          = "dbw-${var.workload}"
  resource_group_name           = var.group
  location                      = var.location
  managed_resource_group_name   = "rg-${var.workload}-databricks"
  sku                           = var.sku
  public_network_access_enabled = var.public_network_access_enabled

  # Only valid for Premium
  infrastructure_encryption_enabled = false

  network_security_group_rules_required = "AllRules"

  custom_parameters {
    virtual_network_id                                   = var.vnet_id
    no_public_ip                                         = var.vnet_no_public_ip
    public_subnet_name                                   = var.databricks_vnet_public_subnet_name
    private_subnet_name                                  = var.databricks_vnet_private_subnet_name
    public_subnet_network_security_group_association_id  = var.databricks_vnet_public_subnet_nsg_association_id
    private_subnet_network_security_group_association_id = var.databricks_vnet_private_subnet_nsg_association_id
  }
}
