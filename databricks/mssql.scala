val driverClass = "com.microsoft.sqlserver.jdbc.SQLServerDriver"
val connectionProperties = new java.util.Properties()
connectionProperties.setProperty("Driver", driverClass)

val jdbcUsername = dbutils.secrets.get(scope = "keyvault-managed", key = "mssqlusername")
val jdbcPassword = dbutils.secrets.get(scope = "keyvault-managed", key = "mssqlpassword")
connectionProperties.put("user", s"${jdbcUsername}")
connectionProperties.put("password", s"${jdbcPassword}")
