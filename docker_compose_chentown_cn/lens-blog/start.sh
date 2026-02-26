#!/bin/bash

# Lens Blog Services Start Script
# 启动 Lens Blog 全套服务

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "================================"
echo "Starting Lens Blog Services..."
echo "================================"

# Check if Docker is running
if ! docker ps > /dev/null 2>&1; then
    echo "❌ Error: Docker daemon is not running"
    exit 1
fi

# Check if lens-blog.yml exists
if [ ! -f "lens-blog.yml" ]; then
    echo "❌ Error: lens-blog.yml not found in current directory"
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

# Pull and start blog containers
echo "Pulling latest blog images..."
docker-compose -f lens-blog.yml pull

echo "Starting blog services..."
docker-compose -f lens-blog.yml up -d

# Wait for containers to be ready
echo "Waiting for blog services to start..."
sleep 5

SERVICES=(
  "lens-blog-monitor"
  "lens-blog-picture"
  "lens-blog-admin-backend"
  "lens-blog-backend"
  "lens-blog-admin-vue-frontend"
  "lens-blog-vue-frontend"
)

ALL_OK=true

for svc in "${SERVICES[@]}"; do
  if docker ps | grep -q "$svc"; then
    echo "✅ $svc is running"
  else
    echo "❌ $svc failed to start"
    ALL_OK=false
  fi
done

if [ "$ALL_OK" = true ]; then
  echo ""
  echo "Service Details (short):"
  echo "--------------------------------"
  docker ps --filter "name=lens-blog-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
  echo ""
  echo "Network Configuration:"
  echo "  Network: solution_backnet"
  echo "  Monitor IP: 172.28.0.120 (port 9020)"
  echo "  Picture IP: 172.28.0.112 (port 9012)"
  echo "  Admin Backend IP: 172.28.0.102 (port 9002)"
  echo "  Backend IP: 172.28.0.101 (port 9001)"
  echo "  Admin FE IP: 172.28.0.182 (port 8002->80)"
  echo "  FE IP: 172.28.0.181 (port 8001->80)"
  echo ""
  echo "Access URLs:"
  echo "  Blog Backend:          http://localhost:9001"
  echo "  Admin Backend:        http://localhost:9002"
  echo "  Blog Frontend:        http://localhost:8001"
  echo "  Blog Admin Frontend:  http://localhost:8002"
  echo "  Monitor:              http://localhost:9020"
  echo "================================"
  echo "Lens Blog services started successfully!"
  echo "================================"
else
  echo "❌ One or more blog services failed to start. Use:\n  docker-compose -f lens-blog.yml logs"
  exit 1
fi
