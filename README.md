Gestión de Datos 

Notebooks (.ipynb) con código y explicaciones.

Requisitos

Python 3 (recomendado 3.8 o superior).
Jupyter Notebook o JupyterLab.

Cómo usar

Clona el repositorio: git clone https://github.com/HailAngel/gestion_datos_2.git
Entra en la carpeta del proyecto: cd gestion_datos_2
Abre Jupyter: jupyter notebook o jupyter lab
Abre el primer  archivo .ipynb y seguir en orden.
Debe tener estas variables de entorno en .env

DB_HOST=localhost

DB_PORT=5432

DB_NAME=telco_db

DB_USER=telco_user

DB_PASSWORD=telco_pass

# 1. Instalar dependencias
curl -sS https://bootstrap.pypa.io/get-pip.py | python3

pip install -r requirements.txt

# 2. Verificar conexión a PostgreSQL (opcional)
psql -h localhost -U telco_user -d telco_db -c "\dt"
