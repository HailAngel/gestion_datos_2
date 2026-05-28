import pandas as pd
import re

def ejecutar_validaciones(almacen_datos):
    print("Validacion de registros de sobrevivientes")
    df = almacen_datos['Titanic'].copy()
    sobrevivientes=(df["2urvived"]==1) & (df["Pclass"].notna())
    df_sobrevivientes=df[sobrevivientes].copy()

    almacen_datos['registro sobrevivientes']=df_sobrevivientes
    print("Validacion exitosa de sobrevivientes")

    if 'Libros' in almacen_datos and not almacen_datos['Libros'].empty:
        df_libros = almacen_datos['Libros']
        
        # Función para detectar si un texto contiene solo caracteres latinos
        # Permite letras (a-z, A-Z), números, espacios y signos de puntuación comunes
        def es_latino(texto):
            if pd.isna(texto): return False
            # Regex que busca caracteres NO latinos/estándar
            return bool(re.match(r'^[a-zA-Z0-9\s\.,!\?\-\(\)áéíóúÁÉÍÓÚñÑ]+$', str(texto)))

        # Aplicamos el filtro a la columna de títulos
        col_titulo = 'title' if 'title' in df_libros.columns else df_libros.columns[0]
        
        mascara_latina = df_libros[col_titulo].apply(es_latino)
        df_libros_al = df_libros[mascara_latina].copy()
        
        almacen_datos['Libros AL'] = df_libros_al
        print(f"Validación Libros exitosa: {len(df_libros_al)} libros con alfabeto latino.")

    return(almacen_datos)