#!/bin/bash

# MariaDB Docker Stop Script
# 停止MariaDB容器

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "================================"
echo "Stopping MariaDB Container..."
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

# Check if container is running
if ! docker ps | grep -q "lens-mariadb"; then
    echo "ℹ️  Containers are not running"
    exit 0
fi

echo "Stopping all services..."
docker-compose -f lens-db.yml stop

echo "Removing all containers..."
docker-compose -f lens-db.yml down

# Verify containers are stopped
if ! docker ps | grep -q "lens-mariadb"; then
    echo "✅ All containers stopped successfully"
    echo ""
    echo "Stopped Containers:"
    echo "  - lens-mariadb (MariaDB database)"
    echo "  - lens-mariadb-adminer (Web database UI)"
    echo "  - lens-redis (Redis cache)"
else
    echo "⚠️  Some containers still running, forcing removal..."
    docker-compose -f lens-db.yml down -f
fi

echo ""
echo "Summary:"
echo "  ✓ MariaDB container stopped"
echo "  ✓ Adminer container stopped"
echo "  ✓ Redis container stopped"
echo "  ✓ Data persisted in volumes"
echo ""
echo "To restart all services:"
echo "  ./start.sh"
echo ""
echo "To remove all data (WARNING: destructive):"
echo "  docker-compose -f lens-db.yml down -v"

echo "================================"
echo "MariaDB stopped successfully!"
echo "================================"
