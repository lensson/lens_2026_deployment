#!/bin/bash

# Lens Blog Services Stop Script
# 停止 Lens Blog 全套服务

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "================================"
echo "Stopping Lens Blog Services..."
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

# If no blog containers are running, exit gracefully
if ! docker ps | grep -q "lens-blog-"; then
    echo "ℹ️  Lens Blog containers are not running"
    exit 0
fi

echo "Stopping blog services..."
docker-compose -f lens-blog.yml stop

echo "Removing blog containers..."
docker-compose -f lens-blog.yml down

# Verify containers are stopped
if ! docker ps | grep -q "lens-blog-"; then
    echo "✅ Lens Blog containers stopped successfully"
else
    echo "⚠️  Some containers still running, forcing removal..."
    docker-compose -f lens-blog.yml down -f
fi

echo ""
echo "Summary:"
echo "  - Lens Blog services stopped"
    echo "  - Containers removed"
echo "  - Data/logs preserved in Docker volumes or host paths (see lens-blog.yml)"
echo ""
echo "To restart:"
echo "  ./start.sh"
echo ""
echo "To inspect logs:"
echo "  docker-compose -f lens-blog.yml logs"
echo ""
echo "================================"
echo "Lens Blog stopped successfully!"
echo "================================"

