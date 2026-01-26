#!/usr/bin/env node

/**
 * Unified Web Server
 * 
 * Usage:
 *   node server.js start <port>    - Start web server on specified port
 *   node server.js stop             - Stop the running web server
 * 
 * Examples:
 *   node server.js start 80
 *   node server.js start 8000
 *   node server.js start 3000
 */

const http = require('http');
const fs = require('fs');
const path = require('path');
const os = require('os');

// Configuration
const HOSTNAME = '127.0.0.1';
const PID_DIR = path.join(os.homedir(), '.demoservers');
const PID_FILE = (port) => path.join(PID_DIR, `server-${port}.pid`);

// Ensure PID directory exists
if (!fs.existsSync(PID_DIR)) {
    fs.mkdirSync(PID_DIR, { recursive: true });
}

/**
 * Generate welcome HTML page
 */
function getWelcomeHTML(port) {
    return `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lens Demo Server - Port ${port}</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            max-width: 600px;
            text-align: center;
        }
        
        h1 {
            color: #333;
            margin-bottom: 10px;
            font-size: 2.5em;
        }
        
        .port-badge {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 1.2em;
            margin-bottom: 20px;
            font-weight: bold;
        }
        
        p {
            color: #666;
            line-height: 1.6;
            margin-bottom: 15px;
            font-size: 1.1em;
        }
        
        .info-box {
            background: #f5f5f5;
            border-left: 4px solid #667eea;
            padding: 15px;
            margin: 20px 0;
            text-align: left;
            border-radius: 4px;
        }
        
        .info-box h3 {
            color: #667eea;
            margin-bottom: 10px;
        }
        
        .info-box p {
            margin: 5px 0;
            font-family: 'Courier New', monospace;
            color: #333;
        }
        
        .status {
            display: inline-block;
            width: 12px;
            height: 12px;
            background: #4CAF50;
            border-radius: 50%;
            margin-right: 8px;
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0%, 100% {
                opacity: 1;
            }
            50% {
                opacity: 0.5;
            }
        }
        
        .footer {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
            color: #999;
            font-size: 0.9em;
        }
        
        .timestamp {
            color: #999;
            font-size: 0.9em;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Lens Demo Server</h1>
        <div class="port-badge">Port ${port}</div>
        
        <p><span class="status"></span><strong>Server is running successfully</strong></p>
        
        <div class="info-box">
            <h3>Server Information</h3>
            <p>📍 Hostname: 127.0.0.1</p>
            <p>🔌 Port: ${port}</p>
            <p>🕐 Started: ${new Date().toLocaleString()}</p>
        </div>
        
        <div class="info-box">
            <h3>Usage Instructions</h3>
            <p>Start server: <code>node server.js start ${port}</code></p>
            <p>Stop server: <code>node server.js stop</code></p>
        </div>
        
        <p>Welcome to the Lens Demo Server! This is a simple HTTP server running on port ${port}.</p>
        
        <div class="footer">
            <p>Lens 2026 Demo Environment</p>
            <div class="timestamp">Page generated at: ${new Date().toISOString()}</div>
        </div>
    </div>
</body>
</html>`;
}

/**
 * Start the web server
 */
function startServer(port) {
    // Validate port
    if (!port || isNaN(port) || port < 1 || port > 65535) {
        console.error('❌ Invalid port number. Port must be between 1 and 65535.');
        process.exit(1);
    }

    port = parseInt(port);

    // Check if server is already running
    const pidFile = PID_FILE(port);
    if (fs.existsSync(pidFile)) {
        try {
            const existingPid = fs.readFileSync(pidFile, 'utf-8').trim();
            console.warn(`⚠️  A server might already be running on port ${port} (PID: ${existingPid})`);
            console.log('   Proceeding to start new server (old PID file may be stale)...');
        } catch (err) {
            console.log('   Old PID file found, removing it...');
            fs.unlinkSync(pidFile);
        }
    }

    // Create HTTP server
    const server = http.createServer((req, res) => {
        res.statusCode = 200;
        res.setHeader('Content-Type', 'text/html; charset=utf-8');
        res.end(getWelcomeHTML(port));
    });

    // Handle server errors
    server.on('error', (err) => {
        if (err.code === 'EADDRINUSE') {
            console.error(`❌ Error: Port ${port} is already in use.`);
            console.error('   Please choose a different port or stop the process using that port.');
            process.exit(1);
        } else if (err.code === 'EACCES') {
            console.error(`❌ Error: Permission denied. Cannot bind to port ${port}.`);
            console.error('   You may need elevated privileges (try with sudo) or choose a port > 1024.');
            process.exit(1);
        } else {
            console.error('❌ Server error:', err.message);
            process.exit(1);
        }
    });

    // Start listening
    server.listen(port, HOSTNAME, () => {
        // Save PID
        fs.writeFileSync(pidFile, process.pid.toString(), 'utf-8');

        console.log('');
        console.log('✅ Web Server Started Successfully');
        console.log('================================');
        console.log(`🌐 Server running at: http://${HOSTNAME}:${port}/`);
        console.log(`🔌 Port: ${port}`);
        console.log(`📊 Process ID (PID): ${process.pid}`);
        console.log(`⏰ Started at: ${new Date().toLocaleString()}`);
        console.log('================================');
        console.log('');
        console.log('📖 To stop the server, run:');
        console.log('   node server.js stop');
        console.log('');
        console.log('Press Ctrl+C to terminate the server.');
        console.log('');
    });

    // Handle graceful shutdown
    process.on('SIGINT', () => {
        console.log('');
        console.log('⏹  Shutting down server...');
        
        // Clean up PID file
        try {
            if (fs.existsSync(pidFile)) {
                fs.unlinkSync(pidFile);
            }
        } catch (err) {
            console.error('Warning: Could not remove PID file:', err.message);
        }

        server.close(() => {
            console.log('✅ Server stopped successfully');
            process.exit(0);
        });

        // Force shutdown after 5 seconds
        setTimeout(() => {
            console.error('❌ Forced shutdown after timeout');
            process.exit(1);
        }, 5000);
    });

    process.on('SIGTERM', () => {
        // Clean up PID file
        try {
            if (fs.existsSync(pidFile)) {
                fs.unlinkSync(pidFile);
            }
        } catch (err) {
            // Silently ignore
        }
        process.exit(0);
    });
}

/**
 * Stop the web server
 */
function stopServer() {
    console.log('');
    console.log('🔍 Looking for running servers...');
    console.log('');

    let foundServers = false;

    try {
        const files = fs.readdirSync(PID_DIR);
        
        for (const file of files) {
            if (file.startsWith('server-') && file.endsWith('.pid')) {
                const port = file.match(/server-(\d+)\.pid/)[1];
                const pidFile = path.join(PID_DIR, file);
                
                try {
                    const pid = parseInt(fs.readFileSync(pidFile, 'utf-8').trim());
                    
                    // Try to kill the process
                    try {
                        process.kill(pid, 'SIGTERM');
                        console.log(`✅ Stopped server on port ${port} (PID: ${pid})`);
                        foundServers = true;
                        
                        // Remove PID file
                        fs.unlinkSync(pidFile);
                    } catch (err) {
                        if (err.code === 'ESRCH') {
                            // Process doesn't exist
                            console.log(`⚠️  No process found for port ${port} (PID file was stale)`);
                            fs.unlinkSync(pidFile);
                        } else {
                            console.error(`❌ Error stopping server on port ${port}:`, err.message);
                        }
                    }
                } catch (err) {
                    console.error(`⚠️  Error reading PID file for port ${port}:`, err.message);
                }
            }
        }
    } catch (err) {
        if (err.code !== 'ENOENT') {
            console.error('Error reading PID directory:', err.message);
        }
    }

    if (!foundServers) {
        console.log('ℹ️  No running demo servers found.');
    }

    console.log('');
    process.exit(0);
}

/**
 * Display usage information
 */
function showUsage() {
    console.log('');
    console.log('╔════════════════════════════════════════════════════════════╗');
    console.log('║          Lens Demo Server - Unified Web Server             ║');
    console.log('╚════════════════════════════════════════════════════════════╝');
    console.log('');
    console.log('📖 USAGE:');
    console.log('   node server.js start <port>    Start web server on specified port');
    console.log('   node server.js stop             Stop all running demo servers');
    console.log('   node server.js help             Show this help message');
    console.log('');
    console.log('📋 EXAMPLES:');
    console.log('   node server.js start 80         Start server on port 80');
    console.log('   node server.js start 8000       Start server on port 8000');
    console.log('   node server.js start 3000       Start server on port 3000');
    console.log('   node server.js stop             Stop all running servers');
    console.log('');
    console.log('🔌 AVAILABLE PORTS (examples):');
    console.log('   80, 443, 3000, 8000, 8001, 8002, 8100, 8200, 8301, 8302, 8848');
    console.log('');
    console.log('💡 TIPS:');
    console.log('   - Port numbers < 1024 require elevated privileges (sudo)');
    console.log('   - The server displays a welcome page with current status');
    console.log('   - PID files are stored in ~/.demoservers/');
    console.log('');
}

/**
 * Main entry point
 */
function main() {
    const args = process.argv.slice(2);

    if (args.length === 0) {
        showUsage();
        process.exit(0);
    }

    const command = args[0].toLowerCase();

    switch (command) {
        case 'start':
            if (args.length < 2) {
                console.error('❌ Error: Port number is required for start command');
                console.error('');
                console.error('Usage: node server.js start <port>');
                console.error('');
                console.error('Examples:');
                console.error('  node server.js start 80');
                console.error('  node server.js start 8000');
                process.exit(1);
            }
            startServer(args[1]);
            break;

        case 'stop':
            stopServer();
            break;

        case 'help':
        case '-h':
        case '--help':
            showUsage();
            process.exit(0);
            break;

        default:
            console.error(`❌ Unknown command: "${command}"`);
            console.error('');
            showUsage();
            process.exit(1);
    }
}

// Run main
main();
