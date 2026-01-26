#!/bin/bash

# MariaDB Docker Start Script
# 启动MariaDB容器

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "================================"
echo "Starting MariaDB Container..."
echo "================================"

# Check if Docker is running
if ! docker ps > /dev/null 2>&1; then
    echo "❌ Error: Docker daemon is not running"
    exit 1
fi

# Check if lens-db.yml exists
if [ ! -f "lens-db.yml" ]; then
    echo "❌ Error: lens-db.yml not found in current directory"
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

# Pull and start MariaDB container
echo "Pulling latest MariaDB image..."
docker-compose -f lens-db.yml pull

echo "Starting MariaDB service..."
docker-compose -f lens-db.yml up -d

# Wait for containers to be ready
echo "Waiting for services to start..."
sleep 5

# Check all containers status
if docker ps | grep -q "lens-mariadb"; then
    echo "✅ All containers started successfully"
    echo ""
    echo "Running Containers:"
    echo "================================"
    docker ps --filter "label=com.docker.compose.project=3rd-party" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || {
        echo "  lens-mariadb:"
        echo "    Status: $(docker ps --filter "name=lens-mariadb" --format "{{.Status}}")"
        echo "    Ports: $(docker ps --filter "name=lens-mariadb" --format "{{.Ports}}")"
        echo ""
        echo "  lens-mariadb-adminer:"
        echo "    Status: $(docker ps --filter "name=lens-mariadb-adminer" --format "{{.Status}}")"
        echo "    Ports: $(docker ps --filter "name=lens-mariadb-adminer" --format "{{.Ports}}")"
        echo ""
        echo "  lens-redis:"
        echo "    Status: $(docker ps --filter "name=lens-redis" --format "{{.Status}}")"
        echo "    Ports: $(docker ps --filter "name=lens-redis" --format "{{.Ports}}")"
    }
    echo ""
    echo "Database Access:"
    echo "  MariaDB Host: localhost:33306"
    echo "  MariaDB User: root"
    echo "  MariaDB Password: mysql"
    echo ""
    echo "Admin Tools:"
    echo "  Adminer Web UI: http://localhost:38080"
    echo "  Redis Port: localhost:6379"
    echo ""
    echo "View logs:"
    echo "  docker-compose -f lens-db.yml logs -f"
    echo ""
else
    echo "❌ Failed to start all containers"
    echo "Showing logs:"
    docker-compose -f lens-db.yml logs
    exit 1
fi

echo "================================"
echo "MariaDB started successfully!"
echo "================================"
