#!/bin/bash

datalake="dlsdataboss"
datalakeAddress="https://$datalake.dfs.core.windows.net"

directory=".bin"

mkdir -p $directory
curl -L https://aka.ms/downloadazcopy-v10-linux -o azcopylinux10.tar.gz
tar -xf azcopylinux10.tar.gz


Execute the copy:

```sh
azcopy login --tenant-id=<tenant-id>

./azcopy cp "./files/*" "https://dlsdataboss.dfs.core.windows.net/myfilesystem001" --recursive=true
```
