#!/bin/bash

basedir="data/files"
filesystem="myfilesystem001"
accountName="dlsdataboss"

az storage fs file upload -s "$basedir/addresses.csv" -p addresses.csv  -f $filesystem --account-name $accountName  --auth-mode login -o none
az storage fs file upload -s "$basedir/contact.xml" -p contact.xml -f $filesystem --account-name $accountName  --auth-mode login -o none
az storage fs file upload -s "$basedir/product.json" -p product.json  -f $filesystem --account-name $accountName  --auth-mode login -o none
