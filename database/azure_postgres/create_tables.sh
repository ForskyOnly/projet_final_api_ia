#!/bin/bash

# Load environment variables from .env file
set -o allexport
source ../../.env
set +o allexport

# Path to your SQL script file
sqlScript="/home/utilisateur/Documents/dev/devia/projet_final_api_ia/database/azure_postgres/create_table_postgres.sql"

# Connect to Azure SQL Server and execute the SQL script
export PGPASSWORD=$PASSWORD 
psql -h $SERVER -d $DATABASE -U $POSTGRES_USER -f $sqlScript