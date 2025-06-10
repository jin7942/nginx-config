#!/usr/bin/env bash

# 에러 발생 시 즉시 종료
set -e

# jin-gateway
echo "Starting jin-gateway..."
docker compose -f /srv/deploy/nginx-config/docker-compose.yml down 
echo "jin-gateway started."
sleep 5

# dockwatch
echo "Starting dockwatch..."
docker compose -f /srv/deploy/nginx-config/dockwatch/docker-compose.yml down 
echo "dockwatch started."
sleep 5

# usedmarket
echo "Starting usedmarket..."
docker compose -f /srv/deploy/nginx-config/usedmarket/docker-compose.yml down 
echo "usedmarket started."
sleep 5

# ray-auto-deploy-server
echo "Starting ray-auto-deploy-server..."
docker compose -f /srv/deploy/nginx-config/ray-auto-deploy-server/docker-compose.yml down 
echo "ray-auto-deploy-server started."
sleep 5

echo "All services deployed successfully!"
