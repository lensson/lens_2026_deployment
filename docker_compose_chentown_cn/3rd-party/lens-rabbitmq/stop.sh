#!/bin/bash

# RabbitMQ Service Stop Script
# 停止 RabbitMQ 服务

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "================================"
echo "Stopping RabbitMQ Service..."
echo "================================"

# Check if Docker is running
if ! docker ps > /dev/null 2>&1; then
    echo "❌ Error: Docker daemon is not running"
    exit 1
fi

# Check if lens-rabbitmq.yml exists
if [ ! -f "lens-rabbitmq.yml" ]; then
    echo "❌ Error: lens-rabbitmq.yml not found in current directory"
    exit 1
fi

# Check if container is running
if ! docker ps | grep -q "lens-rabbitmq"; then
    echo "ℹ️  RabbitMQ container is not running"
    exit 0
fi

echo "Stopping RabbitMQ service..."
docker-compose -f lens-rabbitmq.yml stop

echo "Removing RabbitMQ container..."
docker-compose -f lens-rabbitmq.yml down

# Verify container is stopped
if ! docker ps | grep -q "lens-rabbitmq"; then
    echo "✅ RabbitMQ container stopped successfully"
else
    echo "⚠️  Container still running, forcing removal..."
    docker-compose -f lens-rabbitmq.yml down -f
fi

echo ""
echo "Summary:"
echo "  - RabbitMQ service stopped"
    echo "  - Container removed"
echo "  - Data preserved at $HOME/containers/lens-rabbitmq/data/"
echo "  - Logs preserved at $HOME/containers/lens-rabbitmq/logs/"
echo ""
echo "To restart:"
echo "  ./start.sh"
echo ""
echo "To remove logs:"
echo "  rm -rf $HOME/containers/lens-rabbitmq/logs/*"
echo ""
echo "================================"
echo "RabbitMQ stopped successfully!"
echo "================================"
