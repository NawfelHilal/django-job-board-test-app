FROM node:20-alpine AS tailwind-builder

WORKDIR /app

COPY package*.json .

RUN npm ci

COPY . .

RUN npm run build:css

FROM python:3.11

WORKDIR /app

# Upgrade pip
RUN pip install --upgrade pip

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

# Copie le CSS compilé depuis le stage tailwind-builder
COPY --from=tailwind-builder /app/static/dist/output.css ./static/dist/output.css

# Copie et rend exécutable le script d'entrée
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

EXPOSE 8000

CMD ["./entrypoint.sh"]
