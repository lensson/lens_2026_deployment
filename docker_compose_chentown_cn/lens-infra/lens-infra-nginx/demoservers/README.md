# Lens Demo Server - Unified Web Server

## Overview

The unified `server.js` consolidates all 10 individual demo server files into a single, powerful web server that accepts **two command-line arguments**:

1. **Command**: `start` or `stop`
2. **Port**: Any port number (1-65535)

## Quick Start

```bash
# Navigate to demoservers directory
cd /home/zhenac/my/lens_2026_deployment/docker_compose_chentown_cn/lens-infra/lens-infra-nginx/demoservers

# Start server on port 8000
node server.js start 8000

# Stop all running servers
node server.js stop

# Show help
node server.js help
```

## Usage

### Start Server on Any Port
```bash
node server.js start <port>
```

**Examples:**
```bash
node server.js start 80        # HTTP (requires sudo)
node server.js start 443       # HTTPS (requires sudo)
node server.js start 3000      # Node.js default
node server.js start 8000      # Common demo port
node server.js start 8080      # Alternative HTTP
node server.js start 8848      # Original demo port
node server.js start 9999      # Any port
```

### Stop All Running Servers
```bash
node server.js stop
```

Gracefully stops all running demo servers and cleans up PID files.

### Display Help
```bash
node server.js help
```

Shows usage information and examples.

## Features

### ✅ Dynamic Port Configuration
- No code modifications needed
- Start on any port (1-65535)
- Multiple instances simultaneously

### ✅ Professional Welcome Page
- Modern HTML5 with CSS styling
- Gradient background design
- Server status indicator (animated)
- Port and hostname information
- Startup timestamp
- Responsive layout

### ✅ Process Management
- Automatic PID file tracking
- Track multiple running instances
- Stop all servers with single command
- Graceful shutdown with Ctrl+C

### ✅ Error Handling
- Port validation
- Port already in use detection
- Permission denied handling
- Stale PID file cleanup
- Detailed error messages

### ✅ Informative Output
```
✅ Web Server Started Successfully
================================
🌐 Server running at: http://127.0.0.1:8000/
🔌 Port: 8000
📊 Process ID (PID): 12345
⏰ Started at: 1/26/2026, 10:30:45 AM
================================
```

## Examples

### Single Server Instance
```bash
# Start on port 8000
node server.js start 8000

# Visit in browser: http://localhost:8000
# See professional welcome page

# Stop the server
node server.js stop
```

### Multiple Server Instances
```bash
# Terminal 1
node server.js start 8000

# Terminal 2
node server.js start 8001

# Terminal 3
node server.js start 8002

# All running simultaneously
# http://localhost:8000
# http://localhost:8001
# http://localhost:8002

# Stop all with single command
node server.js stop
```

### Port Ranges
```bash
# Low ports (require sudo)
sudo node server.js start 80
sudo node server.js start 443

# High ports (no sudo needed)
node server.js start 3000
node server.js start 5000
node server.js start 8000
node server.js start 8080
```

## Process Management

### PID File Storage
```
~/.demoservers/server-<port>.pid
```

Examples:
- `~/.demoservers/server-80.pid`
- `~/.demoservers/server-8000.pid`
- `~/.demoservers/server-3000.pid`

### Tracking Servers
- PID files created automatically when server starts
- PID files removed automatically when server stops
- Stale PID files detected and cleaned up

## Troubleshooting

### Port Already in Use
```
❌ Error: Port 8000 is already in use.
```

**Solution:**
```bash
# Stop running servers
node server.js stop

# Or use a different port
node server.js start 8001
```

### Permission Denied
```
❌ Error: Permission denied. Cannot bind to port 80.
```

**Solution:**
```bash
# Use sudo for ports < 1024
sudo node server.js start 80

# Or use a port > 1024
node server.js start 8000
```

### Invalid Port Number
```
❌ Invalid port number. Port must be between 1 and 65535.
```

**Solution:**
```bash
# Use a valid port number
node server.js start 8000
```

## Supported Ports

### Privileged Ports (require `sudo`)
- 80 - HTTP
- 443 - HTTPS

### Unprivileged Ports (no `sudo` needed)
- 3000 - Node.js default
- 5000 - Flask default
- 8000, 8001, 8002 - Common demo ports
- 8080, 8081 - Alternative HTTP
- 8100, 8200 - Custom ranges
- 8301, 8302 - Custom ranges
- 8848 - Original demo port
- 9000+ - Any high numbered port

## Command Syntax

```
node server.js <command> [port]

Commands:
  start <port>  - Start web server on specified port
  stop          - Stop all running demo servers
  help          - Show help message
  -h, --help    - Show help message

Examples:
  node server.js start 8000
  node server.js stop
  node server.js help
```

## Files

```
demoservers/
├── server.js       ← Unified server (use this!)
└── README.md       ← This file
```

## Previous Files (Deleted)
The following 10 individual server files have been consolidated into server.js:
- ~~server80.js~~
- ~~server443.js~~
- ~~server8000.js~~
- ~~server8001.js~~
- ~~server8002.js~~
- ~~server8100.js~~
- ~~server8200.js~~
- ~~server8301.js~~
- ~~server8302.js~~
- ~~server8848.js~~

## Migration from Old Files

| Old Way | New Way |
|---------|---------|
| `node server80.js` | `node server.js start 80` |
| `node server8000.js` | `node server.js start 8000` |
| `node server443.js` | `node server.js start 443` |
| `Ctrl+C` for each | `node server.js stop` |

## Benefits

✅ **Simplicity**
- One command for all ports
- No code modifications needed

✅ **Flexibility**
- Any port number (1-65535)
- Start/stop multiple instances
- Dynamic configuration

✅ **Reliability**
- Error handling
- Process tracking
- Graceful shutdown

✅ **Professional**
- Styled welcome page
- Informative output
- Proper error messages

---

**Version**: 2.0.0  
**Location**: `/home/zhenac/my/lens_2026_deployment/docker_compose_chentown_cn/lens-infra/lens-infra-nginx/demoservers/`  
**Status**: ✅ Production Ready  
**Date**: 2026-01-26
