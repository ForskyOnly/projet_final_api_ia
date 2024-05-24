#!/bin/bash

# Load environment variables from the parent directory's .env file
set -o allexport
source /home/utilisateur/Documents/dev/devia/projet_final_api_ia/.env
set +o allexport

# Print environment variables for debugging
echo "SUBSCRIPTION_ID: $SUBSCRIPTION_ID"
echo "WORKSPACE_NAME: $WORKSPACE_NAME"
echo "RESOURCE_GROUP: $RESOURCE_GROUP"
echo "LOCATION: $LOCATION"

# Log in to Azure (uncomment if needed)
# az login

# Set the Azure subscription
az account set --subscription $SUBSCRIPTION_ID

# Create the Azure ML workspace
az ml workspace create \
    --name $WORKSPACE_NAME \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION

# Set default values for workspace, resource group, and location
az configure --defaults workspace=$WORKSPACE_NAME group=$RESOURCE_GROUP location=$LOCATION 

# Show the MLflow tracking URI for the workspace
az ml workspace show --query mlflow_tracking_uri
