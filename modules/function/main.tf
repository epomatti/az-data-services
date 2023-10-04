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
  name                = "func-${var.workload}-dbwbus" # TODO: databricks
  resource_group_name = var.group
  location            = var.location

  storage_account_name       = azurerm_storage_account.functions.name
  storage_account_access_key = azurerm_storage_account.functions.primary_access_key
  service_plan_id            = azurerm_service_plan.databricks_servicebus.id

  # FIXME: Document this
  public_network_access_enabled = var.public_network_access_enabled

  # TODO: Application Insights
  # TODO: Logging

  site_config {
    application_insights_key               = azurerm_application_insights.default.instrumentation_key
    application_insights_connection_string = azurerm_application_insights.default.connection_string

    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = {
    "AzureWebJobsFeatureFlags"               = "EnableWorkerIndexing"
    "AzureWebJobsServiceBusConnectionString" = "${var.servicebus_connection_string}"
  }
}

### Application Insights ###

resource "azurerm_log_analytics_workspace" "appi" {
  name                = "logs-${var.workload}-functions-appi"
  resource_group_name = var.group
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "default" {
  name                = "appi-${var.workload}-functions"
  resource_group_name = var.group
  location            = var.location
  workspace_id        = azurerm_log_analytics_workspace.appi.id
  application_type    = "other"
}

### Diagnostic ###

resource "azurerm_log_analytics_workspace" "logs" {
  name                = "logs-${var.workload}-functions-logs"
  resource_group_name = var.group
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "function" {
  name                       = "Logs"
  target_resource_id         = azurerm_linux_function_app.databricks_servicebus.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id

  enabled_log {
    category = "FunctionAppLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
