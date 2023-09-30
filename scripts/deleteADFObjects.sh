#!/bin/bash

az datafactory pipeline delete -g rg-databoss --factory-name adf-databoss --name Adfv2CopyExertnalFileToLake -y
az datafactory dataset delete -g rg-databoss --factory-name adf-databoss --name ExportalCSVOutputDataset -y
az datafactory dataset delete -g rg-databoss --factory-name adf-databoss --name ExternalCSVInputDataset -y
