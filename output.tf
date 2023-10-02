output "databricks_workspace_url" {
  value = module.databricks.workspace_url
}

output "mssql_fully_qualified_domain_name" {
  value = module.mssql.fully_qualified_domain_name
}

output "synapse_connectivity_endpoints" {
  value = module.synapse.connectivity_endpoints
}
