#!/bin/bash

accountName="stextsys999"
container="external"
file="export.csv"

az storage container create --account-name $accountName --name $container --auth-mode login

cd data/external

az storage blob upload \
    --account-name $accountName \
    --container-name $container \
    --name $file \
    --file $file \
    --auth-mode login
