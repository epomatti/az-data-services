#!/bin/bash

tenantId=$(az account show --query tenantId -o tsv)

cd .bin
./azcopy login --tenant-id=$tenantId