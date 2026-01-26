#!/bin/bash

# Keycloak Docker Start Script
# 启动Keycloak容器

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "================================"
echo "Starting Keycloak Container..."
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

# 检查环境配置文件
if [ ! -f "config/lens-keycloak.env" ]; then
    echo "⚠️  Warning: config/lens-keycloak.env not found. Using default configuration."
fi

# 检查导入数据目录
if [ ! -d "import/" ]; then
    echo "⚠️  Warning: import/ directory not found. Creating it..."
    mkdir -p import/
fi

# 检查网络是否存在
NETWORK_NAME="solution_backnet"
if ! docker network inspect "$NETWORK_NAME" > /dev/null 2>&1; then
    echo "Creating Docker network: $NETWORK_NAME"
    docker network create --driver bridge "$NETWORK_NAME" || {
        echo "⚠️  Network may already exist or failed to create, continuing..."
    }
fi

# 启动Keycloak容器
echo "Pulling latest Keycloak image..."
docker-compose -f lens-keycloak.yml pull

echo "Starting Keycloak service..."
docker-compose -f lens-keycloak.yml up -d

# 等待容器启动
echo "Waiting for Keycloak to start..."
sleep 3

# 检查容器状态
if docker ps | grep -q "lens-keycloak"; then
    echo "✅ Keycloak container is running"
    echo ""
    echo "Service Details:"
    echo "  Container ID: $(docker ps --filter "name=lens-keycloak" --format "{{.ID}}" | cut -c1-12)"
    echo "  Status: $(docker ps --filter "name=lens-keycloak" --format "{{.Status}}")"
    echo "  Ports: $(docker ps --filter "name=lens-keycloak" --format "{{.Ports}}")"
    echo ""
    echo "Access Keycloak:"
    echo "  - Admin Console: http://localhost:28080/admin"
    echo "  - Default Credentials: admin/admin (change after first login)"
    echo ""
    echo "View logs:"
    echo "  docker logs -f lens-keycloak"
else
    echo "❌ Failed to start Keycloak container"
    echo "Check logs:"
    docker logs lens-keycloak
    exit 1
fi

echo "================================"
echo "Keycloak started successfully!"
echo "================================"
