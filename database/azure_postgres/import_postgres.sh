# Load environment variables from .env file
set -o allexport
source .env
set +o allexport

carscsv="/home/utilisateur/Documents/dev/devia/projet_final_api_ia/database/data/cleaned_data.csv"


# Connect to Azure SQL Server and execute the SQL script
export PGPASSWORD=$PASSWORD 
psql -h $SERVER -d $DATABASE -U $POSTGRES_USER -c"\copy Cars FROM '$carscsv' DELIMITER ',' CSV HEADER;"
