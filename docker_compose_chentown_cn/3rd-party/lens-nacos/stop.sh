#!/bin/bash

# Nacos Service Stop Script
# 停止Nacos服务

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "================================"
echo "Stopping Nacos Service..."
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

# Check if container is running
if ! docker ps | grep -q "lens-nacos"; then
    echo "ℹ️  Nacos container is not running"
    exit 0
fi

echo "Stopping Nacos service..."
docker-compose -f lens-nacos.yml stop

echo "Removing Nacos container..."
docker-compose -f lens-nacos.yml down

# Verify container is stopped
if ! docker ps | grep -q "lens-nacos"; then
    echo "✅ Nacos container stopped successfully"
else
    echo "⚠️  Container still running, forcing removal..."
    docker-compose -f lens-nacos.yml down -f
fi

echo ""
echo "Summary:"
echo "  - Nacos service stopped"
echo "  - Container removed"
echo "  - Configuration files preserved at ./conf/"
echo "  - Init.d files preserved at ./init.d/"
echo "  - Logs preserved at $HOME/containers/lens-nacos/logs/"
echo ""
echo "To restart:"
echo "  ./start.sh"
echo ""
echo "To remove logs:"
echo "  rm -rf $HOME/containers/lens-nacos/logs/*"
echo ""

echo "================================"
echo "Nacos stopped successfully!"
echo "================================"
