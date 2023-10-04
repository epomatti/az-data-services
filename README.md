# Azure data services big demo

In this demo a solution named Databoss will be used to connect and apply Azure data services.

> 🚧 Under construction

## Infrastructure

### 🚀 1 - Azure resources creation

Copy the `.auto.tfvars` template:

```sh
cp templates/template.tf .auto.tfvars
```

Check your public IP address to be added in the firewalls allow rules:

```sh
dig +short myip.opendns.com @resolver1.opendns.com
```

Add your public IP address to the `public_ip_address_to_allow` variable.

Apply and create the infrastructure:

```sh
terraform init
terraform apply -auto-approve
```

Pause the Synapse SQL pool to avoid costs while setting up the infrastructure:

```sh
az synapse sql pool pause -n pool1 --workspace-name synw-databoss -g rg-databoss
```

Once the `apply` phase is complete, approve the managed private endpoints for ADF:

```sh
bash scripts/approveManagedPrivateEndpoints.sh
```

💡 A single connection to Databricks is required to create the access policies on Azure Key Vault.

If everything is OK, proceed to the next section.

### 💾 2- Data setup

Upload some test data:

```sh
bash scripts/uploadFilesToDataLake.sh
bash scripts/uploadFilesToExternalStorage.sh
```

Create the Azure Data Factory objects:

```sh
bash scripts/createExternalPipeline.sh
```

Run the ADF pipeline import data from the external storage into the data lake:

```sh
az datafactory pipeline create-run \
    --resource-group rg-databoss \
    --name Adfv2CopyExternalFileToLake \
    --factory-name adf-databoss
```

### Synapse

If you've stopped the Synapse pool, `resume` it:

```sh
az synapse sql pool resume -n pool1 --workspace-name synw-databoss -g rg-databoss
```

Create the template scripts in Synapse:

```sh
bash scripts/createSynapseSQLScripts.sh
```

Now, connect to Synapse Web UI or directly to the SQL endpoint and and execute the scripts.


### 🧰 3 - Databricks cluster configuration

The previous Azure run should have created the `databricks/.auto.tfvars` file to configure Databricks.

Apply the Databricks configuration:

> 💡 If you haven't yet, you need to login to Databricks, which will create Key Vault policies.

```sh
terraform -chdir="databricks" init
terraform -chdir="databricks" apply -auto-approve
```

Check the workspace files and run the test notebooks and make sure that connectivity is complete.


### 🗲 4 - Function

#### Deployment

```
func azure functionapp publish <FunctionAppName>
```


### Local Development

```
python -m venv venv
. venv/bin/activate
pip install -r requirements.txt

deactivate
```


```sh
func start
```

Get the 

```sh
az servicebus namespace authorization-rule keys list -n RootManageSharedAccessKey --namespace-name bus-databoss -g rg-databoss
```

Create the 

```json
{
  "IsEncrypted": false,
  "Values": {
    "FUNCTIONS_WORKER_RUNTIME": "python",
    "AzureWebJobsFeatureFlags": "EnableWorkerIndexing",
    "AzureWebJobsStorage": "",
    "AzureWebJobsServiceBusConnectionString": ""
  }
}
```



- [] Private endpoints
- [] Managed private network
- [] Consume IP addresses
- [] Internal runtime
- [] Code repository
- [] AD permissions
- [] Azure Monitor (Logs, Insights)

Enable IR interactive authoring
Approve the private link


https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-use-databricks-spark
https://learn.microsoft.com/en-us/azure/data-factory/managed-virtual-network-private-endpoint#managed-private-endpoints
https://learn.microsoft.com/en-us/azure/data-factory/concepts-integration-runtime
https://learn.microsoft.com/en-us/azure/databricks/storage/azure-storage
https://learn.microsoft.com/en-us/azure/databricks/administration-guide/users-groups/service-principals
https://learn.microsoft.com/en-us/azure/databricks/external-data/synapse-analytics

https://learn.microsoft.com/en-us/azure/synapse-analytics/security/synapse-private-link-hubs


## 🧹 Clean-up

Delete the Databricks configuration:

```sh
terraform -chdir="databricks" destroy -auto-approve
```

Delete ADF objects:

```sh
bash scripts/deleteADFObjects.sh
```

Delete the Azure infrastructure:

```sh
terraform destroy -auto-approve
```
