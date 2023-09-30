#!/bin/bash

subscriptionId=$(az account show --query id -o tsv)

mpeId=$(az network private-endpoint-connection list \
  --id /subscriptions/$subscriptionId/resourceGroups/rg-databoss/providers/Microsoft.Storage/storageAccounts/dlsdataboss \
  --query [0].id \
  -o tsv)

az network private-endpoint-connection approve --id  $mpeId --description "LGTM"
