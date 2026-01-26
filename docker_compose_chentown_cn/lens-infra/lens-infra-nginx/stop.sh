#!/bin/bash

# Lens Infra Nginx & Demo Server Stop Script
# 停止Nginx容器或Demo服务器

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# PID directory for demo servers
PID_DIR="$HOME/.demoservers"

#
# Stop all demo servers
#
stop_demo_servers() {
    echo ""
    echo "================================"
    echo "Stopping Demo Servers..."
    echo "================================"
    echo ""

    local found_servers=0

    if [ -d "$PID_DIR" ]; then
        for pid_file in "$PID_DIR"/server-*.pid; do
            if [ -f "$pid_file" ]; then
                local port=$(basename "$pid_file" | sed 's/server-\([0-9]*\)\.pid/\1/')
                local pid=$(cat "$pid_file")

                # Check if process exists
                if kill -0 "$pid" 2>/dev/null; then
                    echo "Stopping server on port $port (PID: $pid)..."
                    kill -TERM "$pid" 2>/dev/null || true
                    found_servers=1

                    # Wait for graceful shutdown
                    sleep 1

                    # Force kill if still running
                    if kill -0 "$pid" 2>/dev/null; then
                        echo "Force killing process $pid..."
                        kill -9 "$pid" 2>/dev/null || true
                    fi

                    # Remove PID file
                    rm -f "$pid_file"
                    echo "✅ Stopped server on port $port"
                else
                    echo "⚠️  No process found for port $port (removing stale PID file)"
                    rm -f "$pid_file"
                fi
            fi
        done
    fi

    if [ $found_servers -eq 0 ]; then
        echo "ℹ️  No running demo servers found"
    fi

    echo ""
    echo "================================"
    echo "Demo servers stopped!"
    echo "================================"
}

#
# Display usage information
#
show_usage() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║   Lens Infra - Nginx Container & Demo Server Manager         ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    echo "📖 USAGE:"
    echo "   ./stop.sh              Stop Nginx container"
    echo "   ./stop.sh server       Stop all demo servers"
    echo ""
    echo "📋 EXAMPLES:"
    echo "   ./stop.sh              Stop Nginx"
    echo "   ./stop.sh server       Stop all demo servers"
    echo "   ./stop.sh help         Show this help message"
    echo ""
}

# Main logic
if [ $# -eq 0 ]; then
    # No arguments - stop Nginx
    echo "================================"
    echo "Stopping Nginx Container..."
    echo "================================"

    # Check if Docker is running
    if ! docker ps > /dev/null 2>&1; then
        echo "❌ Error: Docker daemon is not running"
        exit 1
    fi

    # Check if lens-infra-nginx.yml exists
    if [ ! -f "lens-infra-nginx.yml" ]; then
        echo "❌ Error: lens-infra-nginx.yml not found in current directory"
        exit 1
    fi

    # Check if container is running
    if ! docker ps | grep -q "lens-infra-nginx"; then
        echo "ℹ️  Nginx container is not running"
        exit 0
    fi

    echo "Stopping Nginx service..."
    docker-compose -f lens-infra-nginx.yml stop

    echo "Removing Nginx container..."
    docker-compose -f lens-infra-nginx.yml down

    # Verify container is stopped
    if ! docker ps | grep -q "lens-infra-nginx"; then
        echo "✅ Nginx container stopped successfully"
    else
        echo "⚠️  Container still running, forcing removal..."
        docker-compose -f lens-infra-nginx.yml down -f
    fi

    echo ""
    echo "Summary:"
    echo "  - Nginx service stopped"
    echo "  - Container removed"
    echo "  - Configuration files preserved at ./conf/"
    echo "  - Logs preserved at $HOME/containers/lens-infra-nginx/logs/"
    echo ""
    echo "To restart:"
    echo "  ./start.sh"
    echo ""
    echo "To remove logs:"
    echo "  rm -rf $HOME/containers/lens-infra-nginx/logs/*"
    echo ""

    echo "================================"
    echo "Nginx stopped successfully!"
    echo "================================"

elif [ "$1" = "server" ]; then
    # Stop demo servers
    stop_demo_servers

elif [ "$1" = "help" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_usage
    exit 0

else
    echo "❌ Unknown command: $1"
    echo ""
    show_usage
    exit 1
fi

