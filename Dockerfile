# --- ETAPA 1: Builder ---
FROM registry.local:5443/oficial-images/python:3.12-slim AS builder

# Evita que Python genere archivos .pyc y permite ver logs en tiempo real
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
# Instalamos gunicorn aquí también para que se incluya en el prefijo
RUN pip install --upgrade pip && \
    pip install --no-cache-dir --prefix=/install -r requirements.txt gunicorn


# --- ETAPA 2: Final ---
FROM registry.local:5443/oficial-images/python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

# Copiamos las librerías y el binario de gunicorn
COPY --from=builder /install /usr/local
COPY . .

# Recopilar archivos estáticos (importante para producción)
# Asegúrate de tener STATIC_ROOT configurado en settings.py
RUN python manage.py collectstatic --noinput

RUN adduser --disabled-password admbas

RUN chown -R admbas:admbas /app /home/admbas

RUN mkdir -p /app/staticfiles && chown -R admbas:admbas /app/staticfiles

USER admbas

EXPOSE 8000

# Usamos Gunicorn para levantar la app
# --bind: dirección y puerto
# --workers: número de procesos (regla general: 2 * núcleos + 1)
# backend.wsgi: reemplaza 'backend' por el nombre de tu carpeta de proyecto
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--timeout","90" ,"--workers", "2", "django_crud_api.wsgi:application"]