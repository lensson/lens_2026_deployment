#!/bin/bash
# Nacos Namespace List - Get all namespaces from Nacos v3 API
# Usage: ./get-namespace-list.sh [host] [port]
# Example: ./get-namespace-list.sh localhost 8848

NACOS_HOST="${1:-localhost}"
NACOS_PORT="${2:-8848}"
NACOS_USER="nacos"
NACOS_PASSWORD="nacos"

echo "Connecting to Nacos at ${NACOS_HOST}:${NACOS_PORT}..."

# Get token
TOKEN=$(curl -s -X POST "http://${NACOS_HOST}:${NACOS_PORT}/v3/auth/user/login" \
  -d "username=${NACOS_USER}" \
  -d "password=${NACOS_PASSWORD}" | \
  python3 -c "import sys,json; print(json.load(sys.stdin).get('accessToken',''))" 2>/dev/null)

if [ -z "$TOKEN" ]; then
  echo "Failed to get token"
  exit 1
fi

echo "Token: ${TOKEN:0:40}..."

# Get namespace list
echo ""
echo "Fetching namespace list..."
curl -s "http://${NACOS_HOST}:${NACOS_PORT}/v3/console/core/namespace/list?accessToken=${TOKEN}&pageNo=1&pageSize=100" | python3 -m json.tool

echo ""
echo "Done."
