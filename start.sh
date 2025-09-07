#!/usr/bin/env bash
set -e

# Nombre de la imagen y contenedor
IMAGE_NAME="prcrv-tea"
CONTAINER_NAME="prcrv-tea-cont"

# 1️⃣ Construir la imagen Docker
echo "Imagen Docker: $IMAGE_NAME ..."
docker build -t $IMAGE_NAME .

# 2️⃣ Eliminar contenedor anterior si existe
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "🗑 Eliminando contenedor previo: $CONTAINER_NAME ..."
    docker rm -f $CONTAINER_NAME
fi

# 3️⃣ Crear y entrar al contenedor, montando el proyecto
echo "Contenedor $CONTAINER_NAME ..."
docker run -it --name $CONTAINER_NAME -v $(pwd):/home/rvqemu-dev/workspace $IMAGE_NAME /bin/bash
