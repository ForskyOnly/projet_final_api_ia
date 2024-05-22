import sqlite3
import pandas as pd 


df = pd.read_csv('/home/utilisateur/Documents/dev/devia/projet_final_api_ia/database/data/cleaned_data.csv')

conn = sqlite3.connect('cars.db')

conn.execute('''
CREATE TABLE IF NOT EXISTS cars (
    symboling INTEGER,
    CarName TEXT,
    fueltype TEXT,
    aspiration TEXT,
    doornumber INTEGER,
    carbody TEXT,
    drivewheel TEXT,
    enginelocation TEXT,
    wheelbase REAL,
    carlength REAL,
    carwidth REAL,
    carheight REAL,
    curbweight REAL,
    enginetype TEXT,
    cylindernumber INTEGER,
    enginesize INTEGER,
    fuelsystem TEXT,
    boreratio REAL,
    stroke REAL,
    compressionratio REAL,
    horsepower INTEGER,
    peakrpm INTEGER,
    citympg INTEGER,
    highwaympg INTEGER,
    price REAL,
    model TEXT
);
''')


df.to_sql('cars', conn, if_exists='append', index=False)

conn.commit()
conn.close()