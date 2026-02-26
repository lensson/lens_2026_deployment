#!/bin/bash

# Lens Platform Services Stop Script
# 停止 Lens Platform 服务（gateway + auth）

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "================================"
echo "Stopping Lens Platform Services..."
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

GATEWAY_NAME="lens-platform-gateway"
AUTH_NAME="lens-platform-auth"

# If neither container is running, exit gracefully
if ! docker ps | grep -q "$GATEWAY_NAME" && ! docker ps | grep -q "$AUTH_NAME"; then
    echo "ℹ️  Platform containers are not running"
    exit 0
fi

echo "Stopping platform services..."
docker-compose -f lens-platform.yml stop

echo "Removing platform containers..."
docker-compose -f lens-platform.yml down

# Verify containers are stopped
if ! docker ps | grep -q "$GATEWAY_NAME" && ! docker ps | grep -q "$AUTH_NAME"; then
    echo "✅ Platform containers stopped successfully"
else
    echo "⚠️  Some containers still running, forcing removal..."
    docker-compose -f lens-platform.yml down -f
fi

echo ""
echo "Summary:"
echo "  - Lens Platform services stopped"
echo "  - Containers removed"
echo "  - Data/logs preserved in Docker volumes (if configured)"
echo ""
echo "To restart:"
echo "  ./start.sh"
echo ""
echo "To inspect logs:"
echo "  docker-compose -f lens-platform.yml logs"
echo ""
echo "================================"
echo "Lens Platform stopped successfully!"
echo "================================"
