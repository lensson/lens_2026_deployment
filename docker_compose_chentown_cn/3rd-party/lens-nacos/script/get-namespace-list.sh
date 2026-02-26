#!/bin/bash

# Nacos Namespace List Script
# Get namespace list from Nacos server using v3 API
# Author: @copilot
# Date: 2026-02-14

set -e

# Configuration
NACOS_HOST="${NACOS_HOST:-localhost}"
NACOS_PORT="${NACOS_PORT:-8848}"
NACOS_USER="${NACOS_USER:-nacos}"
NACOS_PASSWORD="${NACOS_PASSWORD:-nacos}"

NACOS_URL="http://${NACOS_HOST}:${NACOS_PORT}"

echo "================================"
echo "Nacos Namespace List"
echo "================================"
echo "Server: ${NACOS_URL}"
echo "User: ${NACOS_USER}"
echo ""

# Step 1: Get access token
echo "[1/2] Authenticating with Nacos..."
LOGIN_RESPONSE=$(curl -s -X POST "${NACOS_URL}/v3/auth/user/login" \
  -d "username=${NACOS_USER}" \
  -d "password=${NACOS_PASSWORD}")

# Extract token
TOKEN=$(echo "$LOGIN_RESPONSE" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('accessToken', ''))
except Exception as e:
    print('', file=sys.stderr)
" 2>/dev/null)

if [ -z "$TOKEN" ]; then
    echo "❌ Failed to authenticate with Nacos"
    echo "Response: $LOGIN_RESPONSE"
    exit 1
fi

echo "✅ Authentication successful"
echo "Token: ${TOKEN:0:40}..."
echo ""

# Step 2: Get namespace list
echo "[2/2] Fetching namespace list..."
NAMESPACE_RESPONSE=$(curl -s "${NACOS_URL}/v3/console/core/namespace/list?accessToken=${TOKEN}&pageNo=1&pageSize=100")

# Parse and display namespaces
echo "$NAMESPACE_RESPONSE" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    if data.get('code') == 0:
        namespaces = data.get('data', [])
        print('✅ Found {} namespace(s):\n'.format(len(namespaces)))
        print('{:<40} {:<25} {:<10} {:<10}'.format('Namespace ID', 'Name', 'Type', 'Configs'))
        print('-' * 90)
        for ns in namespaces:
            ns_id = ns.get('namespace', 'N/A')
            ns_name = ns.get('namespaceShowName', 'N/A')
            ns_type = 'Default' if ns.get('type') == 0 else 'Custom'
            config_count = ns.get('configCount', 0)
            print('{:<40} {:<25} {:<10} {:<10}'.format(ns_id, ns_name, ns_type, config_count))
        print('\nTotal: {} namespace(s)'.format(len(namespaces)))
    else:
        print('❌ Error:', data.get('message', 'Unknown error'))
except json.JSONDecodeError:
    print('❌ Failed to parse response')
    print('Response:', sys.stdin.read())
except Exception as e:
    print('❌ Error:', str(e))
"

echo ""
echo "================================"
echo "Script completed"
echo "================================"
