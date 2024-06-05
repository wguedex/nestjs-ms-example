#!/bin/bash

# Array con los nombres de los subdirectorios
directories=("clientGW-ms-example" "orders-ms-example" "payments-ms-example" "products-ms-example")

# Contenido del nuevo Dockerfile
new_dockerfile_content='FROM node:21-alpine3.19

WORKDIR /usr/src/app

COPY package*.json ./

# Actualizar npm y configurar opciones
RUN npm install -g npm@latest \
    && npm config set fetch-timeout 120000 \
    && npm config set fetch-retries 5 \
    && npm config set fetch-retry-mintimeout 20000 \
    && npm config set fetch-retry-maxtimeout 120000 \
    && npm cache clean --force \
    && rm -rf node_modules package-lock.json

# Usar --omit=optional para excluir dependencias opcionales
RUN npm install --omit=optional

COPY . .

EXPOSE 3000
'

# Función para reemplazar el Dockerfile
replace_dockerfile() {
  dockerfile_path="$1/dockerfile"
  if [[ -f "$dockerfile_path" ]]; then
    echo "Replacing $dockerfile_path"
    echo "$new_dockerfile_content" > "$dockerfile_path"
  else
    echo "Dockerfile not found in $1, creating a new one."
    echo "$new_dockerfile_content" > "$dockerfile_path"
  fi
}

for dir in "${directories[@]}"; do
  echo "Processing directory: $dir"
  replace_dockerfile "$dir"
done

echo "Done replacing Dockerfiles."
