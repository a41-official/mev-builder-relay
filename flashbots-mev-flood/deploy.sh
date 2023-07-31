#!/bin/bash

IMAGE_NAME="mevflood"

if [[ "$(docker images -q $IMAGE_NAME 2>/dev/null)" == "" ]]; then
    echo "Image '$IMAGE_NAME' not found. Building the image..."
    
    git clone https://github.com/darron1217/mev-flood.git
    cd mev-flood/ && git checkout devnet
    docker build -t $IMAGE_NAME:latest .
    cd ..
    rm -rf mev-flood/
fi

if [ -f "deployments/local.json" ]; then
    echo "Local deployment already exists. Removing..."
    sudo rm deployments/local.json
else

docker run -v ${PWD}/deployments:/app/cli/deployments --network flashbots-devnet_default $IMAGE_NAME init -r http://geth:8545 -s local.json