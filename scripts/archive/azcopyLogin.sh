#!/bin/bash

tenantId=$(az account show --query tenantId -o tsv)

cd .bin
keyctl workaround_session
./azcopy login --tenant-id=$tenantId