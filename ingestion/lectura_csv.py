import pandas as pd

def leer_datos_csv():
    source="Titanic.csv"
    df=pd.read_csv(source)
    print(f'total lineas importadas:  {len(df)}')
    return df