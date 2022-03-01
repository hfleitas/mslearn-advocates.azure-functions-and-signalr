STORAGE_CONNECTION_STRING=$(az storage account show-connection-string \
--name $(az storage account list \
  --resource-group hfserverless \
  --query [0].name -o tsv) \
--resource-group hfserverless \
--query "connectionString" -o tsv)

COSMOSDB_ACCOUNT_NAME=$(az cosmosdb list \
    --resource-group hfserverless \
    --query [0].name -o tsv)

COSMOSDB_CONNECTION_STRING=$(az cosmosdb list-connection-strings  \
  --name $COSMOSDB_ACCOUNT_NAME \
  --resource-group hfserverless \
  --query "connectionStrings[?description=='Primary SQL Connection String'].connectionString" -o tsv)

COSMOSDB_MASTER_KEY=$(az cosmosdb list-keys \
--name $COSMOSDB_ACCOUNT_NAME \
--resource-group hfserverless \
--query primaryMasterKey -o tsv)

printf "\n\nReplace <STORAGE_CONNECTION_STRING> with:\n$STORAGE_CONNECTION_STRING\n\nReplace <COSMOSDB_CONNECTION_STRING> with:\n$COSMOSDB_CONNECTION_STRING\n\nReplace <COSMOSDB_MASTER_KEY> with:\n$COSMOSDB_MASTER_KEY\n\n"


az resource update \
  --resource-type Microsoft.SignalRService/SignalR \
  --name $SIGNALR_SERVICE_NAME \
  --resource-group hfserverless \
  --set properties.features[flag=ServiceMode].value=Serverless





SIGNALR_SERVICE_NAME=msl-sigr-signalr$(openssl rand -hex 5)
az signalr create \
  --name $SIGNALR_SERVICE_NAME \
  --resource-group hfserverless \
  --sku Free_DS2 \
  --unit-count 1

az resource update \
  --resource-type Microsoft.SignalRService/SignalR \
  --name $SIGNALR_SERVICE_NAME \
  --resource-group hfserverless \
  --set properties.features[flag=ServiceMode].value=Serverless

SIGNALR_CONNECTION_STRING=$(az signalr key list \
  --name $(az signalr list \
    --resource-group hfserverless \
    --query [0].name -o tsv) \
  --resource-group hfserverless \
  --query primaryConnectionString -o tsv)

printf "\n\nReplace <SIGNALR_CONNECTION_STRING> with:\n$SIGNALR_CONNECTION_STRING\n\n"