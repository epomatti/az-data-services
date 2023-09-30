#!/bin/bash

basedir="data/files"
filesystem="myfilesystem001"
accountName="dlsdataboss"

list=("addresses.csv" "contact.xml" "product.json")
for file in "${list[@]}"; do
   echo $file
   az storage fs file upload -s "$basedir/$file" -p $file  -f $filesystem --account-name $accountName --auth-mode login -o none
done
