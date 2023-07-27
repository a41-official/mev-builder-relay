#!/bin/bash

running="$(docker compose ps --services --filter "status=running")"
if [ -n "$running" ]; then
    docker compose down
    sleep 5
fi

docker compose up -d