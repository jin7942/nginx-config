#!/bin/bash

# 환경 변수 확인
: "${CF_API_TOKEN:? CF_API_TOKEN 누락}"
: "${CF_ZONE_ID:? CF_ZONE_ID 누락}"
: "${CF_RECORD_ID:? CF_RECORD_ID 누락}"
: "${RECORD_NAME:? RECORD_NAME 누락}"
: "${TARGET_CNAME:? TARGET_CNAME 누락}"

# 현재 Cloudflare에 등록된 CNAME 조회
CURRENT_CNAME=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records/$CF_RECORD_ID" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json" | jq -r '.result.content')

echo "===== 주/예비 전환을 시작합니다. ====="
echo "현재 DNS: $CURRENT_CNAME"
echo "목표 DNS: $TARGET_CNAME"

# 변경 필요 여부 확인
if [ "$CURRENT_CNAME" == "$TARGET_CNAME" ]; then
  echo "변경 불필요."
  exit 0
fi

# CNAME 업데이트
RESPONSE=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records/$CF_RECORD_ID" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json" \
  --data "{
    \"type\": \"CNAME\",
    \"name\": \"$RECORD_NAME\",
    \"content\": \"$TARGET_CNAME\",
    \"ttl\": 120,
    \"proxied\": false
  }")

SUCCESS=$(echo "$RESPONSE" | jq -r '.success')

if [ "$SUCCESS" == "true" ]; then
  echo "===== 주/예비 전환 완료: $TARGET_CNAME ====="
else
  echo "주/예비 전환 실패"
  echo "$RESPONSE"
  exit 1
fi
