group="rg-databoss"
adfName="adf-databoss"

cd setup/adf/external-storage

az datafactory dataset create --resource-group $group \
    --dataset-name ExternalCSVInputDataset --factory-name $adfName \
    --properties @InputDataset.json

az datafactory dataset create --resource-group $group \
    --dataset-name ExportalCSVOutputDataset --factory-name $adfName \
    --properties @OutputDataset.json

az datafactory pipeline create --resource-group $group \
    --factory-name $adfName --name Adfv2CopyExertnalFileToLake \
    --pipeline @Adfv2QuickStartPipeline.json
