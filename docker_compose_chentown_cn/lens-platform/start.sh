#!/bin/bash

# Lens Platform Services Start Script
# 启动 Lens Platform 服务（gateway + auth）

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "================================"
echo "Starting Lens Platform Services..."
echo "================================"

# Check if Docker is running
if ! docker ps > /dev/null 2>&1; then
    echo "❌ Error: Docker daemon is not running"
    exit 1
fi

# Check if lens-platform.yml exists
if [ ! -f "lens-platform.yml" ]; then
    echo "❌ Error: lens-platform.yml not found in current directory"
    exit 1
fi

# Create network if it doesn't exist (match docker-compose file)
NETWORK_NAME="solution_backnet"
if ! docker network inspect "$NETWORK_NAME" > /dev/null 2>&1; then
    echo "Creating Docker network: $NETWORK_NAME"
    docker network create --driver bridge "$NETWORK_NAME" || {
        echo "⚠️  Network may already exist, continuing..."
    }
fi

# Pull and start platform containers
echo "Pulling latest platform images..."
docker-compose -f lens-platform.yml pull

echo "Starting platform services..."
docker-compose -f lens-platform.yml up -d

# Wait for containers to be ready
echo "Waiting for platform services to start..."
sleep 5

GATEWAY_NAME="lens-platform-gateway"
AUTH_NAME="lens-platform-auth"

SUCCESS=true

if docker ps | grep -q "$GATEWAY_NAME"; then
    echo "✅ $GATEWAY_NAME is running"
else
    echo "❌ $GATEWAY_NAME failed to start"
    SUCCESS=false
fi

if docker ps | grep -q "$AUTH_NAME"; then
    echo "✅ $AUTH_NAME is running"
else
    echo "❌ $AUTH_NAME failed to start"
    SUCCESS=false
fi

if [ "$SUCCESS" = true ]; then
    echo ""
    echo "Service Details:"
    echo "--------------------------------"
    echo "Gateway:"
    echo "  Container ID: $(docker ps --filter "name=$GATEWAY_NAME" --format "{{.ID}}" | cut -c1-12)"
    echo "  Status: $(docker ps --filter "name=$GATEWAY_NAME" --format "{{.Status}}")"
    echo "  Ports: $(docker ps --filter "name=$GATEWAY_NAME" --format "{{.Ports}}")"
    echo ""
    echo "Auth:"
    echo "  Container ID: $(docker ps --filter "name=$AUTH_NAME" --format "{{.ID}}" | cut -c1-12)"
    echo "  Status: $(docker ps --filter "name=$AUTH_NAME" --format "{{.Status}}")"
    echo "  Ports: $(docker ps --filter "name=$AUTH_NAME" --format "{{.Ports}}")"
    echo ""
    echo "Network Configuration:"
    echo "  Network: solution_backnet"
    echo "  Gateway IP: 172.28.0.40"
    echo "  Auth IP:    172.28.0.41"
    echo ""
    echo "Access URLs:"
    echo "  Gateway: http://localhost:8840"
    echo "  Auth:    http://localhost:8841"
    echo "================================"
    echo "Lens Platform services started successfully!"
    echo "================================"
else
    echo "❌ One or more platform services failed to start. Use:\n  docker-compose -f lens-platform.yml logs"
    exit 1
fi
