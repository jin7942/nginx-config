#!/bin/bash

echo "====== 백업 서버와 동기화를 시작합니다. ======"
echo "대상    : jin-backup"
echo "도메인  : ${BACKUP_DOMAIN:-N/A}"
echo "시작 시간: $(date '+%Y-%m-%d %H:%M:%S')"

# rsync 실행
rsync -avz --delete --rsync-path="sudo rsync" /srv/ jin-backup:/srv/
rsync_exit_code=$?

if [ $rsync_exit_code -ne 0 ]; then
    echo "rsync 동기화 실패 (코드: $rsync_exit_code)"
    exit 1
fi

# 도커 이미지 전송
echo "[도커 이미지 전송] usedmarket ====="

docker save used-market-backend > /tmp/used-market-backend.tar
docker save used-market-frontend > /tmp/used-market-frontend.tar
docker save upload > /tmp/upload.tar

scp /tmp/used-market-backend.tar jin-backup:/srv/images/
scp /tmp/used-market-frontend.tar jin-backup:/srv/images/
scp /tmp/upload.tar jin-backup:/srv/images/

rm /tmp/used-market-backend.tar
rm /tmp/used-market-frontend.tar
rm /tmp/upload.tar

echo "===== 동기화가 완료되었습니다. ====="
echo "종료 시간: $(date '+%Y-%m-%d %H:%M:%S')"

echo "===== 백업 서버에서 컨테이너 재 배포를 시작합니다. ====="
ssh jin-backup "/srv/deploy/nginx-config/deploy/script/1.redeploy.sh"