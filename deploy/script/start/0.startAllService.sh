#!/usr/bin/env bash

# 에러 발생 시 즉시 종료
set -e

# jin-gateway
echo "Starting jin-gateway..."
docker compose -f /srv/deploy/nginx-config/docker-compose.yml up -d --force-recreate
echo "jin-gateway started."
sleep 5

# dockwatch
echo "Starting dockwatch..."
docker compose -f /srv/deploy/nginx-config/deploy/dockwatch/docker-compose.yml up -d --force-recreate
echo "dockwatch started."
sleep 5

# usedmarket
echo "Starting usedmarket..."
docker compose -f /srv/deploy/nginx-config/deploy/usedmarket/docker-compose.yml up -d --force-recreate
echo "usedmarket started."
sleep 5

# ray-auto-deploy-server
echo "Starting ray-auto-deploy-server..."
docker compose -f /srv/deploy/nginx-config/deploy/ray-auto-deploy-server/docker-compose.yml up -d --force-recreate
echo "ray-auto-deploy-server started."
sleep 5

echo "========================================"
docker ps -a
echo "All services deployed successfully!"
