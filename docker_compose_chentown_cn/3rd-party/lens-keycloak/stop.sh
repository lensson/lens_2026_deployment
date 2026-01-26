#!/bin/bash

# Keycloak Docker Stop Script
# 停止Keycloak容器

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "================================"
echo "Stopping Keycloak Container..."
echo "================================"

# 检查Docker是否运行
if ! docker ps > /dev/null 2>&1; then
    echo "❌ Error: Docker daemon is not running"
    exit 1
fi

# 检查Docker Compose文件是否存在
if [ ! -f "lens-keycloak.yml" ]; then
    echo "❌ Error: lens-keycloak.yml not found in current directory"
    exit 1
fi

# 检查容器是否正在运行
if ! docker ps | grep -q "lens-keycloak"; then
    echo "ℹ️  Keycloak container is not running"
    exit 0
fi

echo "Stopping Keycloak service..."
docker-compose -f lens-keycloak.yml stop

echo "Removing Keycloak container..."
docker-compose -f lens-keycloak.yml down

# 验证容器已停止
if ! docker ps | grep -q "lens-keycloak"; then
    echo "✅ Keycloak container stopped successfully"
else
    echo "⚠️  Container still running, forcing removal..."
    docker-compose -f lens-keycloak.yml down -f
fi

echo ""
echo "Summary:"
echo "  - Keycloak service stopped"
echo "  - Container removed"
echo "  - Data persisted (if volumes configured)"
echo ""
echo "To restart:"
echo "  ./start.sh"
echo ""
echo "To remove all data:"
echo "  docker-compose -f lens-keycloak.yml down -v"

echo "================================"
echo "Keycloak stopped successfully!"
echo "================================"
