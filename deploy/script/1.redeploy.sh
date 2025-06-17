#!/bin/bash

set -e

echo "===== [$(hostname)] 컨테이너 재 배포를 시작합니다. ====="
echo "시작 시간: $(date '+%Y-%m-%d %H:%M:%S')"

# 1. 기존 컨테이너 down
echo "[$(hostname)][nginx 컨테이너 종료] ===============>"
docker compose -f /config/env/jin-gateway/docker-compose.yml down
sleep 5

echo "[$(hostname)][usedmarket 컨테이너 종료] ===============>"
docker compose -f /srv/deploy/nginx-config/deploy/usedmarket/backup/docker-compose.yml down 
sleep 5

echo "===== [$(hostname)]기존 컨테이너 종료 완료 ====="

# 2. 교체할 이미지 로드
echo "[$(hostname)][교체할 이미지 로드] ===============>"
docker load < /srv/images/used-market-backend.tar
docker load < /srv/images/used-market-frontend.tar
#docker load < /srv/images/upload.tar

echo "===== [$(hostname)]이미지 로드 완료 ====="

# 3. 새 컨테이너 시작

echo "[$(hostname)][새 컨테이너 시작] ===============>"

docker compose -f /srv/deploy/nginx-config/deploy/usedmarket/backup/docker-compose.yml up -d --force-recreate
sleep 5

docker compose -f /config/env/jin-gateway/docker-compose.yml up -d --force-recreate
sleep 5

echo "================================="
docker ps -a
echo "===== [$(hostname)]컨테이너 재 배포가 종료 되었습니다. ====="
echo "종료 시간: $(date '+%Y-%m-%d %H:%M:%S')"