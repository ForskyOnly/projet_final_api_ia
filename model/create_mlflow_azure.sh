#!/bin/bash

# Charger les variables d'environnement depuis le fichier .env
set -o allexport
source /home/utilisateur/Documents/dev/devia/projet_final_api_ia/.env
set +o allexport

# Connexion à Azure
# az login  # Uncomment this if you need to login manually

# Sélectionner l'abonnement
az account set --subscription $SUBSCRIPTION_ID

# Créer le groupe de ressources s'il n'existe pas déjà
az group create --name $RESOURCE_GROUP --location $LOCATION

# Créer un compte de stockage s'il n'existe pas déjà
STORAGE_ACCOUNT_NAME="${WORKSPACE_NAME,,}storage"  # Nom en minuscule et unique
az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP --location $LOCATION --sku Standard_LRS

# Créer un registre de conteneurs s'il n'existe pas déjà
CONTAINER_REGISTRY_NAME="${WORKSPACE_NAME,,}acr"
az acr create --resource-group $RESOURCE_GROUP --name $CONTAINER_REGISTRY_NAME --sku Basic --location $LOCATION

# Créer un key vault s'il n'existe pas déjà
KEY_VAULT_NAME="${WORKSPACE_NAME,,}kv"
az keyvault create --name $KEY_VAULT_NAME --resource-group $RESOURCE_GROUP --location $LOCATION

# Créer un Application Insights s'il n'existe pas déjà
APP_INSIGHTS_NAME="${WORKSPACE_NAME,,}ai"
az monitor app-insights component create --app $APP_INSIGHTS_NAME --location $LOCATION --resource-group $RESOURCE_GROUP

# Créer le workspace ML
az ml workspace create \
    --name $WORKSPACE_NAME \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --storage-account $STORAGE_ACCOUNT_NAME \
    --key-vault $KEY_VAULT_NAME \
    --app-insights $APP_INSIGHTS_NAME \
    --container-registry $CONTAINER_REGISTRY_NAME

# Configurer les valeurs par défaut pour les commandes az ml
az configure --defaults workspace=$WORKSPACE_NAME group=$RESOURCE_GROUP location=$LOCATION 

# Afficher l'URI de suivi de mlflow
az ml workspace show --query mlflow_tracking_uri
