#!/bin/bash

# Lens Infra Nginx & Demo Server Start Script
# 启动Nginx容器或Demo服务器

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# PID directory for demo servers
PID_DIR="$HOME/.demoservers"
mkdir -p "$PID_DIR"

# Demo server directory
DEMOSERVERS_DIR="$SCRIPT_DIR/demoservers"

#
# Generate welcome HTML page for demo server
#
generate_welcome_html() {
    local port=$1
    cat << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lens Demo Server - Port PORT</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center; }
        .container { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3); max-width: 600px; text-align: center; }
        h1 { color: #333; margin-bottom: 10px; font-size: 2.5em; }
        .port-badge { display: inline-block; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 8px 16px; border-radius: 20px; font-size: 1.2em; margin-bottom: 20px; font-weight: bold; }
        p { color: #666; line-height: 1.6; margin-bottom: 15px; font-size: 1.1em; }
        .info-box { background: #f5f5f5; border-left: 4px solid #667eea; padding: 15px; margin: 20px 0; text-align: left; border-radius: 4px; }
        .info-box h3 { color: #667eea; margin-bottom: 10px; }
        .info-box p { margin: 5px 0; font-family: 'Courier New', monospace; color: #333; }
        .status { display: inline-block; width: 12px; height: 12px; background: #4CAF50; border-radius: 50%; margin-right: 8px; animation: pulse 2s infinite; }
        @keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.5; } }
        .footer { margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; color: #999; font-size: 0.9em; }
        .timestamp { color: #999; font-size: 0.9em; margin-top: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Lens Demo Server</h1>
        <div class="port-badge">Port PORT</div>
        <p><span class="status"></span><strong>Server is running successfully</strong></p>
        <div class="info-box">
            <h3>Server Information</h3>
            <p>📍 Hostname: 127.0.0.1</p>
            <p>🔌 Port: PORT</p>
            <p>🕐 Started: TIMESTAMP</p>
        </div>
        <div class="info-box">
            <h3>Usage Instructions</h3>
            <p>Stop server: <code>./stop.sh server</code></p>
        </div>
        <p>Welcome to the Lens Demo Server! This is a simple HTTP server running on port PORT.</p>
        <div class="footer">
            <p>Lens 2026 Demo Environment</p>
            <div class="timestamp">Page generated at: ISOTIMESTAMP</div>
        </div>
    </div>
</body>
</html>
EOF
}

#
# Start demo server on specified port
#
start_demo_server() {
    local port=$1

    # Validate port
    if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        echo "❌ Error: Invalid port number. Port must be between 1 and 65535."
        exit 1
    fi

    echo ""
    echo "================================"
    echo "Starting Demo Server on Port $port..."
    echo "================================"

    # Check if server already running
    PID_FILE="$PID_DIR/server-$port.pid"
    if [ -f "$PID_FILE" ]; then
        OLD_PID=$(cat "$PID_FILE")
        if kill -0 "$OLD_PID" 2>/dev/null; then
            echo "⚠️  A server is already running on port $port (PID: $OLD_PID)"
            echo "   Stop it first with: ./stop.sh server"
            exit 1
        else
            echo "Removing stale PID file..."
            rm -f "$PID_FILE"
        fi
    fi

    # Create simple Node.js HTTP server and run in background
    local temp_dir=$(mktemp -d)
    local server_file="$temp_dir/server-$port.js"

    cat > "$server_file" << 'NODEJS'
const http = require('http');
const port = parseInt(process.argv[2]);
const hostname = '0.0.0.0';

const server = http.createServer((req, res) => {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/html; charset=utf-8');

    const html = `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lens Demo Server - Port ${port}</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center; }
        .container { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3); max-width: 600px; text-align: center; }
        h1 { color: #333; margin-bottom: 10px; font-size: 2.5em; }
        .port-badge { display: inline-block; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 8px 16px; border-radius: 20px; font-size: 1.2em; margin-bottom: 20px; font-weight: bold; }
        p { color: #666; line-height: 1.6; margin-bottom: 15px; font-size: 1.1em; }
        .info-box { background: #f5f5f5; border-left: 4px solid #667eea; padding: 15px; margin: 20px 0; text-align: left; border-radius: 4px; }
        .info-box h3 { color: #667eea; margin-bottom: 10px; }
        .info-box p { margin: 5px 0; font-family: 'Courier New', monospace; color: #333; }
        .status { display: inline-block; width: 12px; height: 12px; background: #4CAF50; border-radius: 50%; margin-right: 8px; animation: pulse 2s infinite; }
        @keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.5; } }
        .footer { margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; color: #999; font-size: 0.9em; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Lens Demo Server</h1>
        <div class="port-badge">Port ${port}</div>
        <p><span class="status"></span><strong>Server is running successfully</strong></p>
        <div class="info-box">
            <h3>Server Information</h3>
            <p>🌐 Network Access:</p>
            <p>Local: <code>http://127.0.0.1:${port}</code></p>
            <p>External: <code>http://YOUR_IP:${port}</code></p>
            <p>🔌 Port: ${port}</p>
            <p>🕐 Started: ${new Date().toLocaleString()}</p>
        </div>
        <div class="info-box">
            <h3>Usage Instructions</h3>
            <p>Stop server: <code>./stop.sh server</code></p>
            <p>Access from external clients using your IP address and port ${port}</p>
        </div>
        <p>Welcome to the Lens Demo Server! This is a simple HTTP server running on port ${port}.</p>
        <div class="footer">
            <p>Lens 2026 Demo Environment</p>
        </div>
    </div>
</body>
</html>`;

    res.end(html);
});

server.on('error', (err) => {
    if (err.code === 'EADDRINUSE') {
        console.error(`❌ Port ${port} is already in use`);
    } else if (err.code === 'EACCES') {
        console.error(`❌ Permission denied for port ${port}`);
    } else {
        console.error(`❌ Server error: ${err.message}`);
    }
    process.exit(1);
});

server.listen(port, hostname, () => {
    console.log(`✅ Demo server started on http://0.0.0.0:${port}/`);
    console.log(`   Accessible at http://${hostname}:${port}/`);
});

process.on('SIGTERM', () => {
    console.log('Shutting down...');
    server.close(() => process.exit(0));
});
NODEJS

    # Start the demo server in background
    node "$server_file" "$port" > "$PID_DIR/server-$port.log" 2>&1 &
    local pid=$!

    # Save PID
    echo "$pid" > "$PID_FILE"

    # Wait a moment for server to start
    sleep 1

    # Check if it's still running
    if ! kill -0 "$pid" 2>/dev/null; then
        echo "❌ Failed to start demo server"
        cat "$PID_DIR/server-$port.log"
        rm -f "$PID_FILE"
        exit 1
    fi

    echo "✅ Demo Server Started Successfully"
    echo "================================"
    echo "🌐 Server running at:"
    echo "   Local:    http://127.0.0.1:$port/"
    echo "   External: http://0.0.0.0:$port/ (or use your IP address)"
    echo "🔌 Port: $port"
    echo "📊 Process ID (PID): $pid"
    echo "⏰ Started at: $(date)"
    echo "================================"
    echo ""
    echo "View logs:"
    echo "  tail -f $PID_DIR/server-$port.log"
    echo ""
    echo "To stop the server:"
    echo "  ./stop.sh server"
    echo ""
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
    echo "   ./start.sh              Start Nginx container"
    echo "   ./start.sh server <port>  Start demo server on specified port"
    echo ""
    echo "📋 EXAMPLES:"
    echo "   ./start.sh              Start Nginx"
    echo "   ./start.sh server 8000  Start demo server on port 8000"
    echo "   ./start.sh server 80    Start demo server on port 80 (needs sudo)"
    echo ""
}

# Main logic
if [ $# -eq 0 ]; then
    # No arguments - start Nginx
    echo "================================"
    echo "Starting Nginx Container..."
    echo "================================"

    # ...existing nginx startup code...
    if ! docker ps > /dev/null 2>&1; then
        echo "❌ Error: Docker daemon is not running"
        exit 1
    fi

    if [ ! -f "lens-infra-nginx.yml" ]; then
        echo "❌ Error: lens-infra-nginx.yml not found in current directory"
        exit 1
    fi

    NETWORK_NAME="solution_backnet"
    if ! docker network inspect "$NETWORK_NAME" > /dev/null 2>&1; then
        echo "Creating Docker network: $NETWORK_NAME"
        docker network create --driver bridge "$NETWORK_NAME" || {
            echo "⚠️  Network may already exist, continuing..."
        }
    fi

    if [ ! -d "conf/conf.d" ]; then
        echo "⚠️  Creating conf/conf.d directory..."
        mkdir -p conf/conf.d
    fi

    if [ ! -f "conf/nginx.conf" ]; then
        echo "⚠️  Warning: conf/nginx.conf not found. Nginx may not start properly."
    fi

    if [ ! -d "$HOME/containers/lens-infra-nginx/logs" ]; then
        echo "Creating logs directory..."
        mkdir -p "$HOME/containers/lens-infra-nginx/logs"
    fi

    echo "Pulling latest Nginx image..."
    docker-compose -f lens-infra-nginx.yml pull

    echo "Starting Nginx service..."
    docker-compose -f lens-infra-nginx.yml up -d

    echo "Waiting for Nginx to start..."
    sleep 3

    if docker ps | grep -q "lens-infra-nginx"; then
        echo "✅ Nginx container is running"
        echo ""
        echo "Service Details:"
        echo "  Container ID: $(docker ps --filter "name=lens-infra-nginx" --format "{{.ID}}" | cut -c1-12)"
        echo "  Status: $(docker ps --filter "name=lens-infra-nginx" --format "{{.Status}}")"
        echo "  Ports: $(docker ps --filter "name=lens-infra-nginx" --format "{{.Ports}}")"
        echo ""
        echo "Network Configuration:"
        echo "  Network: solution_backnet"
        echo "  IP Address: 172.28.0.80"
        echo ""
        echo "Web Services:"
        echo "  HTTP: http://localhost:80"
        echo "  HTTPS: https://localhost:443"
        echo "  Domain: chentown.cn"
        echo ""
        echo "Configuration:"
        echo "  Nginx Config: ./conf/nginx.conf"
        echo "  Sites Config: ./conf/conf.d/"
        echo "  Logs: $HOME/containers/lens-infra-nginx/logs"
        echo ""
        echo "View logs:"
        echo "  docker-compose -f lens-infra-nginx.yml logs -f"
        echo ""
    else
        echo "❌ Failed to start Nginx container"
        echo "Showing logs:"
        docker-compose -f lens-infra-nginx.yml logs
        exit 1
    fi

    echo "================================"
    echo "Nginx started successfully!"
    echo "================================"

elif [ "$1" = "server" ]; then
    # Start demo server
    if [ -z "$2" ]; then
        echo "❌ Error: Port number required for demo server"
        echo ""
        show_usage
        exit 1
    fi
    start_demo_server "$2"

elif [ "$1" = "help" ]; then
    show_usage
    exit 0

else
    echo "❌ Unknown command: $1"
    echo ""
    show_usage
    exit 1
fi

