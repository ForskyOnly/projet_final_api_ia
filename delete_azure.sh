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

# Créer le workspace ML
az ml workspace create \
    --name $WORKSPACE_NAME \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION

# Configurer les valeurs par défaut pour les commandes az ml
az configure --defaults workspace=$WORKSPACE_NAME group=$RESOURCE_GROUP location=$LOCATION 

# Afficher l'URI de suivi de mlflow
az ml workspace show --query mlflow_tracking_uri
