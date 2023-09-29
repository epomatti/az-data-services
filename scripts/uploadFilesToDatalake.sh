#!/bin/bash

datalake="dlsdataboss"
datalakeAddress="https://$datalake.dfs.core.windows.net"

azcopy=".bin/azcopy"




Execute the copy:

```sh
azcopy login --tenant-id=<tenant-id>

./azcopy cp "./files/*" "https://dlsdataboss.dfs.core.windows.net/myfilesystem001" --recursive=true
```
