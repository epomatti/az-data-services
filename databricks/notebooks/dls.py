import os

import datetime
print(str(datetime.datetime.now()))

storage = os.getenv("DLS_NAME")

# spark.conf.set("fs.azure.account.auth.type", "SharedKey")
# spark.conf.set(
#     f"fs.azure.account.key.{storage}.dfs.core.windows.net",
#     dbutils.secrets.get(scope="keyvault-managed", key="dlsaccesskey"))

# spark.conf.set(
#     "fs.azure.account.key.<storage-account>.dfs.core.windows.net",
#     dbutils.secrets.get(scope="<scope>", key="<storage-account-access-key>"))\

# spark.read.load("abfss://<container-name>@<storage-account-name>.dfs.core.windows.net/<path-to-data>")

# dbutils.fs.ls("abfss://<container-name>@<storage-account-name>.dfs.core.windows.net/<path-to-data>")

# spark.conf.set("fs.azure.account.key.dlsdataboss.dfs.core.windows.net", "xomuibey0KKTGKJY5oJ0E6jNGNcZvXeXKZ7EqV09F4jJuswCL+G0SA9OzFX6jwKrWomnJhhFozUt+ASt64SAKQ==")

# spark.conf.set(
#     "fs.azure.account.key.<storage-account>.dfs.core.windows.net",
#     dbutils.secrets.get(scope="<scope>", key="<storage-account-access-key>"))

# df2 = spark.read.load("abfss://myfilesystem001@dlsdataboss.dfs.core.windows.net/addresses.csv")
# display(df2)

# dbutils.fs.ls(f"abfss://external@{storage}.dfs.core.windows.net/")a