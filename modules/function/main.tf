### Functions Storage ###
resource "azurerm_storage_account" "functions" {
  name                     = "stfuncs${var.workload}y1"
  resource_group_name      = var.group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

### Functions ###
resource "azurerm_service_plan" "databricks_servicebus" {
  name                = "plan-${var.workload}-function"
  resource_group_name = var.group
  location            = var.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "databricks_servicebus" {
  name                = "func-${var.workload}-dbwbus"
  resource_group_name = var.group
  location            = var.location

  storage_account_name       = azurerm_storage_account.functions.name
  storage_account_access_key = azurerm_storage_account.functions.primary_access_key
  service_plan_id            = azurerm_service_plan.databricks_servicebus.id

  # FIXME: Document this
  public_network_access_enabled = false

  # TODO: Application Insights
  # TODO: Logging

  site_config {
    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = {
    # "FUNCTIONS_WORKER_RUNTIME"               = "python"
    "AzureWebJobsServiceBusConnectionString" = "${var.servicebus_connection_string}"
  }
}


