```sh
curl -L https://aka.ms/downloadazcopy-v10-linux -o azcopylinux10.tar.gz
tar -xf azcopylinux10.tar.gz
```

Execute the copy:

```sh
azcopy login --tenant-id=<tenant-id>

./azcopy cp "./files/*" "https://dlsmydatalake789.dfs.core.windows.net/myfilesystem001" --recursive=true
```
