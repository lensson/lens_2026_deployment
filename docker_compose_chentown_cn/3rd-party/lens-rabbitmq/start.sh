#!/bin/bash

# RabbitMQ Service Start Script
# 启动 RabbitMQ 服务

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "================================"
echo "Starting RabbitMQ Service..."
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

# Create network if it doesn't exist (match docker-compose file)
NETWORK_NAME="solution_backnet"
if ! docker network inspect "$NETWORK_NAME" > /dev/null 2>&1; then
    echo "Creating Docker network: $NETWORK_NAME"
    docker network create --driver bridge "$NETWORK_NAME" || {
        echo "⚠️  Network may already exist, continuing..."
    }
fi

# Ensure data and logs directories exist (match volume mounts)
if [ ! -d "$HOME/containers/lens-rabbitmq/data" ]; then
    echo "Creating data directory..."
    mkdir -p "$HOME/containers/lens-rabbitmq/data"
fi

if [ ! -d "$HOME/containers/lens-rabbitmq/logs" ]; then
    echo "Creating logs directory..."
    mkdir -p "$HOME/containers/lens-rabbitmq/logs"
fi

# Pull and start RabbitMQ container
echo "Pulling latest RabbitMQ image..."
docker-compose -f lens-rabbitmq.yml pull

echo "Starting RabbitMQ service..."
docker-compose -f lens-rabbitmq.yml up -d

# Wait for container to be ready
echo "Waiting for RabbitMQ to start..."
sleep 5

# Check container status
if docker ps | grep -q "lens-rabbitmq"; then
    echo "✅ RabbitMQ container is running"
    echo ""
    echo "Service Details:"
    echo "  Container ID: $(docker ps --filter "name=lens-rabbitmq" --format "{{.ID}}" | cut -c1-12)"
    echo "  Status: $(docker ps --filter "name=lens-rabbitmq" --format "{{.Status}}")"
    echo "  Ports: $(docker ps --filter "name=lens-rabbitmq" --format "{{.Ports}}")"
    echo ""
    echo "Network Configuration:"
    echo "  Network: solution_backnet"
    echo "  IP Address: 172.28.0.23"
    echo ""
    echo "RabbitMQ Services:"
    echo "  AMQP Port: 5672"
    echo "  Management UI Port: 15672"
    echo "================================"
    echo "RabbitMQ started successfully!"
    echo "================================"
else
    echo "❌ RabbitMQ container failed to start. Please check docker-compose logs."
    exit 1
fi
