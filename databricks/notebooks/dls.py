import os

storage_name = os.getenv("DLS_NAME")
tenant_id = os.getenv("SP_TENANT_ID")
application_id = os.getenv("SP_APPLICATION_ID")

service_credential = dbutils.secrets.get(scope="keyvault-managed",key="dlsserviceprincipalsecret")

spark.conf.set(f"fs.azure.account.auth.type.{storage_name}.dfs.core.windows.net", "OAuth")
spark.conf.set(f"fs.azure.account.oauth.provider.type.{storage_name}.dfs.core.windows.net", "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider")
spark.conf.set(f"fs.azure.account.oauth2.client.id.{storage_name}.dfs.core.windows.net", application_id)
spark.conf.set(f"fs.azure.account.oauth2.client.secret.{storage_name}.dfs.core.windows.net", service_credential)
spark.conf.set(f"fs.azure.account.oauth2.client.endpoint.{storage_name}.dfs.core.windows.net", f"https://login.microsoftonline.com/{tenant_id}/oauth2/token")

csv = spark.read.load("abfss://myfilesystem001@dlsdataboss.dfs.core.windows.net/addresses.csv", format="CSV")
display(csv)
