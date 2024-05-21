import sqlite3
import pandas as pd 


df = pd.read_csv('cleaned_data.csv')

conn = sqlite3.connect('cars.db')

conn.execute("""
    CREATE TABLE IF NOT EXISTS cars (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        CarName TEXT,
        carbody TEXT,
        drivewheel TEXT,
        wheelbase REAL,
        carlength REAL,
        carwidth REAL,
        curbweight REAL,
        enginetype TEXT,
        cylindernumber INTEGER,
        enginesize INTEGER,
        fuelsystem TEXT,
        boreratio REAL,
        horsepower INTEGER,
        citympg INTEGER,
        highwaympg INTEGER,
        price REAL
    )
""")


df.to_sql('cars', conn, if_exists='append', index=False)

conn.commit()
conn.close()