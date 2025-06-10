#!/usr/bin/env bash

# 에러 발생 시 즉시 종료
set -e

# jin-gateway
echo "Stopping jin-gateway..."
docker compose -f /srv/deploy/nginx-config/docker-compose.yml down 
echo "jin-gateway stopped."
sleep 5

# dockwatch
echo "Stopping dockwatch..."
docker compose -f /srv/deploy/nginx-config/dockwatch/docker-compose.yml down 
echo "dockwatch stopped."
sleep 5

# usedmarket
echo "Stopping usedmarket..."
docker compose -f /srv/deploy/nginx-config/usedmarket/docker-compose.yml down 
echo "usedmarket stopped."
sleep 5

# ray-auto-deploy-server
echo "Stopping ray-auto-deploy-server..."
docker compose -f /srv/deploy/nginx-config/ray-auto-deploy-server/docker-compose.yml down 
echo "ray-auto-deploy-server stopped."
sleep 5

echo "All services stopped successfully!"
