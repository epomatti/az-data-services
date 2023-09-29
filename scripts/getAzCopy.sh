#!/bin/bash

directory=".bin"

mkdir -p $directory
cd $directory
curl -L https://aka.ms/downloadazcopy-v10-linux -o azcopylinux10.tar.gz
tar -xf azcopylinux10.tar.gz

cp azcopy_linux_amd64_*/azcopy .
