# --- ETAPA 1: Builder ---
FROM registry.local:5443/oficial-images/python:3.12-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Caché para los paquetes de desarrollo
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev

RUN pip install --upgrade pip

COPY requirements.txt .

# Caché para las dependencias de Python
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --prefix=/install -r requirements.txt gunicorn


# --- ETAPA 2: Final ---
FROM registry.local:5443/oficial-images/python:3.12-slim

WORKDIR /app

# Caché para las librerías de ejecución en producción
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    libpq5

# Copiamos las librerías limpias desde el builder
COPY --from=builder /install /usr/local

RUN adduser --disabled-password --gecos "" admbas && \
    mkdir -p /app/staticfiles && \
    chown -R admbas:admbas /app

COPY . .

RUN chown -R admbas:admbas /app

RUN python manage.py collectstatic --noinput

USER admbas

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--timeout","90" ,"--workers", "2", "django_crud_api.wsgi:application"]