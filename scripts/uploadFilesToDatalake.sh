#!/bin/bash

datalake="dlsdataboss"
datalakeAddress="https://$datalake.dfs.core.windows.net"

cd .bin

./azcopy cp "data/files/*" "$datalakeAddress/myfilesystem001" --recursive=true
