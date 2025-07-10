#!/bin/bash

echo "Pulling MBPTL Docker images..."
echo "================================"

echo "Pulling mbptl-main image..."
docker pull bayufedra/mbptl-main:latest

echo "Pulling mbptl-internal image..."
docker pull bayufedra/mbptl-internal:latest

echo "================================"
echo "Images pulled successfully!"
echo "You can now run: docker compose up -d" 