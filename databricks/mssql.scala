import java.sql.DriverManager
import java.sql.Connection

val jdbcUsername = dbutils.secrets.get(scope = "keyvault-managed", key = "mssqlusername")
val jdbcPassword = dbutils.secrets.get(scope = "keyvault-managed", key = "mssqlpassword")

Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver")

val connectionUrl = "jdbc:sqlserver://sqls-databoss.database.windows.net:1433;database=sqldb-databoss;user=" + jdbcUsername + "@sqls-databoss;password=" + jdbcPassword + ";encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"
val conn = DriverManager.getConnection(connectionUrl);

// val ds = new SQLServerDataSource()
// ds.setUser(jdbcUsername+"@sqls-databoss")
// ds.setPassword(jdbcPassword)
// ds.setServerName("sqls-databoss.database.windows.net")
// ds.setPortNumber(1433)
// ds.setDatabaseName("sqldb-databoss");

// val conn = ds.getConnection()
val sta = conn.createStatement();