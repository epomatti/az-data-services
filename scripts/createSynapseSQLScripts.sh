#!/bin/bash

az synapse sql-script create -f scripts/synapse/init.sql -n Init --workspace-name synw-databoss --sql-pool-name pool1 --sql-database-name pool1