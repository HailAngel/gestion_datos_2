import pandas as pd
import numpy as np
from sklearn.preprocessing import MinMaxScaler, KBinsDiscretizer

def generar_transformaciones(almacen_datos):

    print("\n--- Ejecutando transformaciones en procesamiento/transformacion.py")

    df = almacen_datos['Titanic'].copy()
    
    try:
        resumen_supervivencia = df.groupby("2urvived").size()
        almacen_datos['Resumen_Supervivencia'] = resumen_supervivencia
        print("Entrada 'Resumen_Supervivencia' agregada correctamente.")
    except KeyError:
        print("Error: No se encontró la columna '2urvived' en los datos del Titanic.")

    if 'Age' in df.columns:
        scaler = MinMaxScaler()
        df['Age'] = df['Age'].fillna(df['Age'].median()) # Imputación básica
        # Reshape es necesario porque el scaler espera un array 2D
        df['Age'] = scaler.fit_transform(df[['Age']])
        print("Columna 'Age' normalizada (0-1).")
    
    if 'Fare' in df.columns:
        df['Fare'] = df['Fare'].fillna(df['Fare'].median())
        
        # Aunque KBins suele ser automático, podemos usarlo con estrategia 'ordinal'
        # Para rangos fijos específicos, convertimos los límites a una matriz
        bins = np.array([0, 51, 101, df['Fare'].max() + 1])
        
        # Aplicamos la lógica de categorías
        # Usamos una función para mapear según los requerimientos exactos:
        def categorizar_fare(valor):
            if valor <= 50: return "0-50 dolares"
            elif valor <= 100: return "51-100 dolares"
            else: return "más de 100 dolares"
        
        df['Fare_Category'] = df['Fare'].apply(categorizar_fare)
        print("Columna 'Fare_Category' creada.")
    
    # Actualizar el dataframe en el almacén
    almacen_datos['Titanic'] = df

    return almacen_datos
