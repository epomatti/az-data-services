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

  spark_env_vars = {
    MSSQL_FQDN        = "${var.mssql_fqdn}"
    DLS_NAME          = "${var.dls_name}"
    SP_TENANT_ID      = "${var.sp_tenant_id}"
    SP_APPLICATION_ID = "${var.sp_application_id}"
  }
}

resource "databricks_library" "mssql_jdbc" {
  cluster_id = databricks_cluster.shared_autoscaling.id
  maven {
    coordinates = "com.microsoft.sqlserver:mssql-jdbc:12.4.1.jre11"
  }
}

# TODO: initial_manage_principal

# TODO: Implement service principal
resource "databricks_secret_scope" "kv" {
  name = "keyvault-managed"

  keyvault_metadata {
    resource_id = var.keyvault_resource_id
    dns_name    = var.keyvault_uri
  }
}

data "databricks_current_user" "me" {
}

resource "databricks_notebook" "keyvault_scala" {
  source = "${path.module}/notebooks/mssql.scala"
  path   = "${data.databricks_current_user.me.home}/kv-scala"
}

resource "databricks_notebook" "lake" {
  source = "${path.module}/notebooks/dls.py"
  path   = "${data.databricks_current_user.me.home}/datalake"
}
