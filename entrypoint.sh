#!/bin/sh
set -e

echo "📦 Collecte des fichiers statiques..."
python manage.py collectstatic --noinput

echo "☁️  Upload des assets vers Azure Blob Storage..."
python backend/initialize_azure.py

echo "🗄️  Exécution des migrations..."
python manage.py migrate

echo "🚀 Démarrage de Gunicorn..."
exec gunicorn job_board.wsgi:application --bind 0.0.0.0:8000 --workers 2
