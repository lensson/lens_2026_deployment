#!/bin/bash

# Zipkin Service Start Script
# 启动 Zipkin 服务

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "================================"
echo "Starting Zipkin Service..."
echo "================================"

# Check if Docker is running
if ! docker ps > /dev/null 2>&1; then
    echo "❌ Error: Docker daemon is not running"
    exit 1
fi

# Check if lens-zipkin.yml exists
if [ ! -f "lens-zipkin.yml" ]; then
    echo "❌ Error: lens-zipkin.yml not found in current directory"
    exit 1
fi

# Check env file (optional)
if [ ! -f "lens-zipkin.env" ]; then
    echo "⚠️  Warning: lens-zipkin.env not found. Using default configuration."
fi

# Create network if it doesn't exist
NETWORK_NAME="solution_backnet"
if ! docker network inspect "$NETWORK_NAME" > /dev/null 2>&1; then
    echo "Creating Docker network: $NETWORK_NAME"
    docker network create --driver bridge "$NETWORK_NAME" || {
        echo "⚠️  Network may already exist, continuing..."
    }
fi

# Pull and start Zipkin container
echo "Pulling latest Zipkin image..."
docker-compose -f lens-zipkin.yml pull

echo "Starting Zipkin service..."
docker-compose -f lens-zipkin.yml up -d

# Wait for container to be ready
echo "Waiting for Zipkin to start..."
sleep 5

if docker ps | grep -q "lens-zipkin"; then
    echo "✅ Zipkin container is running"
    echo ""
    echo "Service Details:"
    echo "  Container ID: $(docker ps --filter "name=lens-zipkin" --format "{{.ID}}" | cut -c1-12)"
    echo "  Status: $(docker ps --filter "name=lens-zipkin" --format "{{.Status}}")"
    echo "  Ports: $(docker ps --filter "name=lens-zipkin" --format "{{.Ports}}")"
    echo ""
    echo "Network Configuration:"
    echo "  Network: solution_backnet"
    echo "  IP Address: 172.28.0.22"
    echo ""
    echo "Access Zipkin UI:"
    echo "  http://localhost:9411"
    echo "================================"
    echo "Zipkin started successfully!"
    echo "================================"
else
    echo "❌ Failed to start Zipkin container. Use:\n  docker-compose -f lens-zipkin.yml logs"
    exit 1
fi
