import pickle
from fastapi import FastAPI
from pydantic import BaseModel
import uvicorn
import pandas as pd
import sqlite3

class Car(BaseModel):
    CarName: str
    carbody: str
    drivewheel: str
    wheelbase: float
    carlength: float
    carwidth: float
    curbweight: float
    enginetype: str
    cylindernumber: int
    enginesize: int
    fuelsystem: str
    boreratio: float
    horsepower: int
    citympg: int
    highwaympg: int
    price: float = None


app = FastAPI()

with open('/home/utilisateur/Documents/dev/devia/projet_final_api_ia/model/model_predict_car.pkl', 'rb') as f:
    model = pickle.load(f)


@app.post('/predict')
async def predict(car: Car)-> dict:
    """
        Endpoint pour prédire le prix d'une voiture en fonction de ses caractéristiques.
        Args:
            - car: objet de type Car contenant les caractéristiques de la voiture à prédire.
        Returns:
            - Dictionnaire contenant la prédiction de prix pour la voiture fournie.
    """
    X = pd.DataFrame(car.dict(), index=[0])
    return {'price': model.predict(X)[0]}


@app.post('/cars')
async def create_car(car: Car)->dict:
    """
        Endpoint pour ajouter une nouvelle voiture à la base de données SQLite.
        Args:
            - car: objet de type Car contenant les caractéristiques de la voiture à ajouter.
        Returns:
            - Dictionnaire contenant le statut de l'opération.
    """
    conn = sqlite3.connect('cars.db')
    c = conn.cursor()
    c.execute("INSERT INTO cars (CarName, carbody, drivewheel, wheelbase, carlength, carwidth, curbweight, enginetype, cylindernumber, enginesize, fuelsystem, boreratio, horsepower, citympg, highwaympg, price) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", (car.CarName, car.carbody, car.drivewheel, car.wheelbase, car.carlength, car.carwidth, car.curbweight, car.enginetype, car.cylindernumber, car.enginesize, car.fuelsystem, car.boreratio, car.horsepower, car.citympg, car.highwaympg, car.price))
    conn.commit()
    c.close()
    return {"status": "Voiture ajoutée avec succès"}


@app.put('/cars/{car_id}')
async def update_car(car_id: int, car: Car)-> dict:
    """
        Endpoint pour mettre à jour une voiture existante dans la base de données SQLite.
        Args:
            - car_id: identifiant de la voiture à mettre à jour.
            - car: objet de type Car contenant les nouvelles caractéristiques de la voiture.
        Returns:
            - Dictionnaire contenant le statut de l'opération.
    """
    conn = sqlite3.connect('cars.db')
    c = conn.cursor()
    c.execute("UPDATE cars SET CarName=?, carbody=?, drivewheel=?, wheelbase=?, carlength=?, carwidth=?, curbweight=?, enginetype=?, cylindernumber=?, enginesize=?, fuelsystem=?, boreratio=?, horsepower=?, citympg=?, highwaympg=?, price=? WHERE id=?", (car.CarName, car.carbody, car.drivewheel, car.wheelbase, car.carlength, car.carwidth, car.curbweight, car.enginetype, car.cylindernumber, car.enginesize, car.fuelsystem, car.boreratio, car.horsepower, car.citympg, car.highwaympg, car.price, car_id))
    conn.commit()
    c.close()
    return {"status": "Voiture modifié avec succès"}


@app.delete('/cars/{car_id}')
async def delete_car(car_id: int)-> dict:
    """
        Endpoint pour supprimer une voiture existante de la base de données SQLite.
        Args:
            - car_id: identifiant de la voiture à supprimer.
        Returns:
            - Dictionnaire contenant le statut de l'opération.
    """
    conn = sqlite3.connect('cars.db')
    c = conn.cursor()
    c.execute("DELETE FROM cars WHERE id=?", (car_id,))
    conn.commit()
    c.close()
    return {"status": "Voiture supprimée avec succès"}



if __name__ == '__main__':
    uvicorn.run(app, host='0.0.0.0', port=8000)