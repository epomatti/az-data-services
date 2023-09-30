terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.27.0"
    }
  }
}

provider "databricks" {
  host = var.workspace_url
}

data "databricks_node_type" "smallest" {
  local_disk = true
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

resource "databricks_cluster" "shared_autoscaling" {
  cluster_name            = "Shared Autoscaling"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 20

  autoscale {
    min_workers = 1
    max_workers = 50
  }
}

resource "databricks_secret_scope" "kv" {
  name = "keyvault-managed"
  # initial_manage_principal = ""

  keyvault_metadata {
    resource_id = var.keyvault_resource_id
    dns_name    = var.keyvault_uri
  }
}

data "databricks_current_user" "me" {
}

resource "databricks_notebook" "keyvault_scala" {
  source = "${path.module}/mssql.scala"
  path   = "${data.databricks_current_user.me.home}/kv-scala"
}
