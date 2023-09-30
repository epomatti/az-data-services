# Azure data services big demo

In this demo a solution named Databoss will be used to connect and apply Azure data services.

## 🚀 1- Create the resources

Copy the '.auto.tfvars' template:

```
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

Once the `apply` phase is complete, approve the managed private endpoints for ADF:

```sh
bash scripts/approveManagedPrivateEndpoints.sh
```

## 💾 Setup the data

Upload some test data:

```sh
bash scripts/uploadFilesToDataLake.sh
bash scripts/uploadFilesToExternalStorage.sh
```

This will create the ADF objects:

```sh
bash scripts/createExternalPipeline.sh
```

Run the ADF pipeline import data from the external storage into the data lake:

```sh
az datafactory pipeline create-run --resource-group rg-databoss \
    --name Adfv2CopyExertnalFileToLake --factory-name adf-databoss
```

## 🧰 Configure the Databricks cluster

The previous Azure run should have created the `databricks/.auto.tfvars` file to configure Databricks.

Apply the Databricks configuration:

> 💡 You need to login to Databricks once before running this command.

```sh
terraform -chdir="databricks" init
terraform -chdir="databricks" apply -auto-approve
```

Check the workspace files and run the test notebooks and make sure that connectivity is complete.



- [] Private endpoints
- [] Managed private network
- [] Consume IP addresses
- [] Internal runtime
- [] Code repository
- [] AD permissions

Enable IR interactive authoring
Approve the private link


https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-use-databricks-spark
https://learn.microsoft.com/en-us/azure/data-factory/managed-virtual-network-private-endpoint#managed-private-endpoints
https://learn.microsoft.com/en-us/azure/data-factory/concepts-integration-runtime
https://learn.microsoft.com/en-us/azure/databricks/storage/azure-storage
https://learn.microsoft.com/en-us/azure/databricks/administration-guide/users-groups/service-principals


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
