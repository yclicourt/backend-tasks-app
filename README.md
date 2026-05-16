### ⚙️ Backend TodoApp - Django and DjangoRestFramework


# ⚙️ TodoApp - Backend API

API REST para la aplicación de tareas, construida con **Django** y **Django REST Framework (DRF)**.

## 🛠️ Tecnologías utilizadas

* Python
* Django & Django REST Framework
* PostgreSQL


## 🚀 Configuración en Local

Sigue estos pasos para levantar el entorno de desarrollo:

1. **Clona el repositorio:**

   ```bash
    git clone https://github.com/yclicourt/ecommerce-frontend.git
    cd ecommerce-frontend
   ```

2. **Crear y activar el entorno virtual**:

   ```bash
    python -m venv venv
    source venv/bin/activate  # En Linux/Mac
    # venv\Scripts\activate   # En Windows
   ```

3. **Instalar dependencias**:

   ```bash
    pip install -r requirements.txt
   ```

4. **Variables de Entorno**:
    ```bash
     DB_NAME=
     DB_USER=
     DB_PASSWORD=
     POSTGRES_USER=
     POSTGRES_PASSWORD=
     POSTGRES_DB=
     DB_HOST=
     DB_PORT=
     CORS_ALLOWED_ORIGINS=
     ALLOWED_HOSTS=
     DEBUG=
     SECRET_KEY=
    ``` 
    
5. **Ejecutar migraciones y arrancar el servidor**
    ```bash
     python manage.py migrate
     python manage.py runserver
   ```