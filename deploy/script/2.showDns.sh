#!/bin/bash

# 환경 변수 확인
: "${CF_API_TOKEN:? CF_API_TOKEN 누락}"
: "${CF_ZONE_ID:? CF_ZONE_ID 누락}"
: "${CF_RECORD_ID:? CF_RECORD_ID 누락}"

# 현재 Cloudflare에 등록된 CNAME 조회
CURRENT_CNAME=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records/$CF_RECORD_ID" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json" | jq -r '.result.content')

echo "===== DNS 조회 ====="
echo "현재 DNS: $CURRENT_CNAME"

# 주/예비 서버 판단
if [ "$CURRENT_CNAME" = "jfree.iptime.org" ]; then
  echo "현재 이 서버는 주 서버 입니다."
else
  echo "현재 이 서버는 예비 서버 입니다."
fi
