#!/bin/bash

IMAGE_NAME="mevflood"

if [[ "$(docker images -q $IMAGE_NAME 2>/dev/null)" == "" ]]; then
    echo "Image '$IMAGE_NAME' not found. Building the image..."
    
    git clone https://github.com/darron1217/mev-flood.git
    cd mev-flood/
    docker build -t $IMAGE_NAME:latest .
    cd ..
    rm -rf mev-flood/
fi

running="$(docker compose ps --services --filter "status=running")"
if [ -n "$running" ]; then
    docker compose down
    sleep 5
fi

docker compose up -d