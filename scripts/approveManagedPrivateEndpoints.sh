#!/bin/bash

# Approval for ADF and Synapse managed private endpoints on the Data Lake.

subscriptionId=$(az account show --query id -o tsv)

mpeId0=$(az network private-endpoint-connection list \
  --id /subscriptions/$subscriptionId/resourceGroups/rg-databoss/providers/Microsoft.Storage/storageAccounts/dlsdataboss \
  --query [0].id \
  -o tsv)

mpeId1=$(az network private-endpoint-connection list \
  --id /subscriptions/$subscriptionId/resourceGroups/rg-databoss/providers/Microsoft.Storage/storageAccounts/dlsdataboss \
  --query [1].id \
  -o tsv)

az network private-endpoint-connection approve --id  $mpeId0 --description "LGTM"
az network private-endpoint-connection approve --id  $mpeId1 --description "LGTM"
