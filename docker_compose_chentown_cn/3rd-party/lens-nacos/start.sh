#!/bin/bash

# Nacos Service Start Script
# 启动Nacos服务

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "================================"
echo "Starting Nacos Service..."
echo "================================"

# Check if Docker is running
if ! docker ps > /dev/null 2>&1; then
    echo "❌ Error: Docker daemon is not running"
    exit 1
fi

# Check if lens-nacos.yml exists
if [ ! -f "lens-nacos.yml" ]; then
    echo "❌ Error: lens-nacos.yml not found in current directory"
    exit 1
fi

# Create network if it doesn't exist
NETWORK_NAME="solution_backnet"
if ! docker network inspect "$NETWORK_NAME" > /dev/null 2>&1; then
    echo "Creating Docker network: $NETWORK_NAME"
    docker network create --driver bridge "$NETWORK_NAME" || {
        echo "⚠️  Network may already exist, continuing..."
    }
fi

# Check if conf directory exists
if [ ! -d "conf" ]; then
    echo "⚠️  Creating conf directory..."
    mkdir -p conf
fi

# Check if init.d directory exists
if [ ! -d "init.d" ]; then
    echo "⚠️  Creating init.d directory..."
    mkdir -p init.d
fi

# Check if logs directory exists
if [ ! -d "$HOME/containers/lens-nacos/logs" ]; then
    echo "Creating logs directory..."
    mkdir -p "$HOME/containers/lens-nacos/logs"
fi

# Pull and start Nacos container
echo "Pulling latest Nacos image..."
docker-compose -f lens-nacos.yml pull

echo "Starting Nacos service..."
docker-compose -f lens-nacos.yml up -d

# Wait for container to be ready
echo "Waiting for Nacos to start..."
sleep 5

# Check container status
if docker ps | grep -q "lens-nacos"; then
    echo "✅ Nacos container is running"
    echo ""
    echo "Service Details:"
    echo "  Container ID: $(docker ps --filter "name=lens-nacos" --format "{{.ID}}" | cut -c1-12)"
    echo "  Status: $(docker ps --filter "name=lens-nacos" --format "{{.Status}}")"
    echo "  Ports: $(docker ps --filter "name=lens-nacos" --format "{{.Ports}}")"
    echo ""
    echo "Network Configuration:"
    echo "  Network: solution_backnet"
    echo "  IP Address: 172.28.0.21"
    echo ""
    echo "Nacos Services:"
    echo "  HTTP Port: 8848:8848 (Main Console & API)"
    echo "  Web Console Port: 8880:8080 (Alternative Web Access)"
    echo "  gRPC Port: 9848:9848 (Client gRPC Communication)"
    echo ""
    echo "Web Access:"
    echo "  Main Console: http://localhost:8848/nacos"
    echo "  Alternative: http://localhost:8880/nacos"
    echo "  Network: http://127.0.0.1:8848/nacos"
    echo "  Default User: nacos"
    echo "  Default Password: nacos"
    echo ""
    echo "Configuration:"
    echo "  Config File: ./conf/"
    echo "  Init.d: ./init.d/"
    echo "  Logs: $HOME/containers/lens-nacos/logs"
    echo ""
    echo "View logs:"
    echo "  docker-compose -f lens-nacos.yml logs -f"
    echo ""
else
    echo "❌ Failed to start Nacos container"
    echo "Showing logs:"
    docker-compose -f lens-nacos.yml logs
    exit 1
fi

echo "================================"
echo "Nacos started successfully!"
echo "================================"
