import org.apache.spark.sql.DataFrame

var storageAccountName = sys.env("DLS_NAME")
var synapseSqlEndpoint = sys.env("SYNAPSE_SQL_ENDPOINT")

val storageAccountAccessKey = dbutils.secrets.get(scope = "keyvault-managed", key = "dlsaccesskey")
val synapseLogin = dbutils.secrets.get(scope = "keyvault-managed", key = "synapselogin")
val synapseLoginPassword = dbutils.secrets.get(scope = "keyvault-managed", key = "synapseloginpassword")

val synapseUrl = "jdbc:sqlserver://" + synapseSqlEndpoint + ":1433;database=pool1;user=" + synapseLogin + ";password=" + synapseLoginPassword + ";encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.sql.azuresynapse.net;loginTimeout=30;"

// Set up the storage account access key in the notebook session conf.
spark.conf.set(
  "fs.azure.account.key." + storageAccountName + ".dfs.core.windows.net",
  storageAccountAccessKey)

val synapseAddress = java.net.InetAddress.getByName(synapseSqlEndpoint)
val ipAddress = synapseAddress.getHostAddress()
println(s"Synapse SQL endpoint: $synapseSqlEndpoint")
println(s"Synapse IP address: $ipAddress")

// Get some data from an Azure Synapse table.
val df1: DataFrame = spark.read
  .format("com.databricks.spark.sqldw")
  .option("url", synapseUrl)
  .option("tempDir", "abfss://synapse@" + storageAccountName + ".dfs.core.windows.net/")
  .option("forwardSparkAzureStorageCredentials", "true")
  .option("dbTable", "TestTable")
  .load()

val df2: DataFrame = spark.read
  .format("com.databricks.spark.sqldw")
  .option("url", synapseUrl)
  .option("tempDir", "abfss://synapse@"+ storageAccountName + ".dfs.core.windows.net/")
  .option("forwardSparkAzureStorageCredentials", "true")
  .option("query", "select count(*) as cnt from TestTable")
  .load()

// println(df2.first().getInt(0))
