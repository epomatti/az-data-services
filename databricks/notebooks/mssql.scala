import java.sql.DriverManager
import java.sql.Connection

var server = sys.env("MSSQL_FQDN")
val jdbcUsername = dbutils.secrets.get(scope = "keyvault-managed", key = "mssqlusername")
val jdbcPassword = dbutils.secrets.get(scope = "keyvault-managed", key = "mssqlpassword")

Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver")

val connectionUrl = "jdbc:sqlserver://" + server + ":1433;database=sqldb-databoss;user=" + jdbcUsername + "@sqls-databoss;password=" + jdbcPassword + ";encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"

val conn = DriverManager.getConnection(connectionUrl)
val stmt = conn.createStatement()

val rs = stmt.executeQuery("SELECT 1;")

stmt.close()
conn.close()
