#!/bin/bash
set -x  # Activer le mode de débogage

# Définir le chemin du fichier .env
ENV_FILE="../.env"

# Afficher le répertoire courant
echo "Répertoire courant: $(pwd)"

# Vérifier la présence du fichier .env
if [ ! -f "$ENV_FILE" ]; then
    echo "$ENV_FILE file not found in $(pwd)"
    exit 1
fi

# Charger les variables d'environnement depuis le fichier .env
set -o allexport
source "$ENV_FILE"
set +o allexport

# Vérifier si l'extension Azure ML est installée
if ! az extension show --name ml > /dev/null 2>&1; then
    echo "Installing Azure ML extension..."
    az extension add --name ml
fi

# Vérifier si l'utilisateur est connecté à Azure
if ! az account show > /dev/null 2>&1; then
    echo "Veuillez vous connecter à Azure en utilisant 'az login'"
    az login
fi

# Définir l'abonnement Azure
if [ -z "$SUBSCRIPTION_ID" ]; then
    echo "SUBSCRIPTION_ID not set in .env"
    exit 1
fi
az account set --subscription $SUBSCRIPTION_ID

# Vérifier et créer le groupe de ressources si nécessaire
if ! az group show --name $RESSOURCE_GROUP > /dev/null 2>&1; then
    echo "Creating resource group $RESSOURCE_GROUP..."
    az group create --name $RESSOURCE_GROUP --location $LOCATION
fi

# Créer un compte de stockage
STORAGE_ACCOUNT_NAME="${WORKSPACE_NAME}storage$(date +%s)"
az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RESSOURCE_GROUP --location $LOCATION --sku Standard_LRS

# Obtenir l'ID ARM du compte de stockage
STORAGE_ACCOUNT_ID=$(az storage account show --name $STORAGE_ACCOUNT_NAME --resource-group $RESSOURCE_GROUP --query "id" -o tsv)

# Créer un Key Vault
KEY_VAULT_NAME="${WORKSPACE_NAME}keyvault$(date +%s)"
az keyvault create --name $KEY_VAULT_NAME --resource-group $RESSOURCE_GROUP --location $LOCATION

# Obtenir l'ID ARM du Key Vault
KEY_VAULT_ID=$(az keyvault show --name $KEY_VAULT_NAME --resource-group $RESSOURCE_GROUP --query "id" -o tsv)

# Créer un container registry
CONTAINER_REGISTRY_NAME="${WORKSPACE_NAME}acr$(date +%s)"
az acr create --name $CONTAINER_REGISTRY_NAME --resource-group $RESSOURCE_GROUP --location $LOCATION --sku Basic

# Obtenir l'ID ARM du container registry
CONTAINER_REGISTRY_ID=$(az acr show --name $CONTAINER_REGISTRY_NAME --resource-group $RESSOURCE_GROUP --query "id" -o tsv)

# Créer un workspace Azure ML
if [ -z "$WORKSPACE_NAME" ] || [ -z "$RESSOURCE_GROUP" ] || [ -z "$LOCATION" ]; then
    echo "One or more environment variables not set in .env"
    exit 1
fi

az ml workspace create \
    --name $WORKSPACE_NAME \
    --resource-group $RESSOURCE_GROUP \
    --location $LOCATION \
    --storage-account $STORAGE_ACCOUNT_ID \
    --key-vault $KEY_VAULT_ID \
    --container-registry $CONTAINER_REGISTRY_ID

# Configurer les valeurs par défaut pour les commandes az ml
az configure --defaults workspace=$WORKSPACE_NAME group=$RESSOURCE_GROUP location=$LOCATION

# Afficher l'URI de suivi de MLflow
az ml workspace show --resource-group $RESSOURCE_GROUP --name $WORKSPACE_NAME --query mlflow_tracking_uri

echo "Fin de l'exécution du script"

set +x  # Désactiver le mode de débogage
