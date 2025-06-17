#!/bin/bash

: "${CF_API_TOKEN:? CF_API_TOKEN 누락}"
: "${CF_ZONE_ID:? CF_ZONE_ID 누락}"
: "${CF_RECORD_ID:? CF_RECORD_ID 누락}"
: "${RECORD_NAME:? RECORD_NAME 누락}"
: "${MY_CNAME:? MY_CNAME 누락}"

# 현재 등록된 CNAME
CURRENT_CNAME=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records/$CF_RECORD_ID" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json" | jq -r '.result.content')

echo "===== 주/예비 전환을 시작합니다. ====="
echo "현재 DNS: $CURRENT_CNAME"
echo "이 서버가 등록하려는 CNAME: $MY_CNAME"

# 내가 원하는 CNAME과 다르면 갱신
if [ "$CURRENT_CNAME" != "$MY_CNAME" ]; then
  echo "CNAME을 $MY_CNAME 으로 변경합니다."

  RESPONSE=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records/$CF_RECORD_ID" \
    -H "Authorization: Bearer $CF_API_TOKEN" \
    -H "Content-Type: application/json" \
    --data "{
      \"type\": \"CNAME\",
      \"name\": \"$RECORD_NAME\",
      \"content\": \"$MY_CNAME\",
      \"ttl\": 120,
      \"proxied\": false
    }")

  SUCCESS=$(echo "$RESPONSE" | jq -r '.success')

  if [ "$SUCCESS" = "true" ]; then
    echo "===== 전환 완료: $MY_CNAME ====="
  else
    echo "전환 실패"
    echo "$RESPONSE"
    exit 1
  fi
else
  echo "변경 불필요: 이미 $MY_CNAME 로 설정되어 있음"
fi
