# Lens Infra Nginx Docker Container Management

## Overview

These scripts manage the Lens Infra Nginx Docker container for the Lens 2026 deployment. Nginx acts as a reverse proxy and web server, handling HTTP/HTTPS traffic for the platform.

## Service Details

### Container Information
- **Container Name**: lens-infra-nginx
- **Image**: lensson/lens-infra-nginx:latest
- **Network**: solution_backnet (IP: 172.28.0.80)
- **Restart Policy**: unless-stopped
- **Debug Mode**: Enabled (nginx-debug)

### Network Ports
- **HTTP**: 80:80 (localhost:80)
- **HTTPS**: 443:443 (localhost:443)
- **Domain**: chentown.cn

### Mounted Volumes
- **Config Directory**: `./conf/conf.d/` → `/etc/nginx/conf.d` (Nginx site configurations)
- **Nginx Config**: `./conf/nginx.conf` → `/etc/nginx/nginx.conf` (Main Nginx configuration)
- **Logs Directory**: `~/containers/lens-infra-nginx/logs` → `/var/log/nginx` (Access and error logs)

### Environment Variables
- **DOMAIN_NAME**: chentown.cn (Domain for SSL/TLS certificates)
- **PUSH_NODE_ID**: push-xlpm40gv3jq05n9g (Push notification node identifier)
- **PUSH_NODE_TOKEN**: 81f6a759f4dce1e972055696416dec9e (Authentication token for push notifications)

## Scripts

### start.sh
Starts the Nginx container with comprehensive initialization:
- ✅ Checks if Docker daemon is running
- ✅ Verifies lens-infra-nginx.yml configuration exists
- ✅ Creates Docker network (solution_backnet) if needed
- ✅ Creates configuration directories if missing
- ✅ Creates logs directory structure
- ✅ Pulls latest Nginx image
- ✅ Starts container in detached mode
- ✅ Waits for container to be ready
- ✅ Displays detailed service information and connection details
- ✅ Shows helpful log viewing commands

### stop.sh
Stops the Nginx container gracefully:
- ✅ Checks if Docker is running
- ✅ Verifies lens-infra-nginx.yml exists
- ✅ Checks if container is running
- ✅ Stops container gracefully
- ✅ Removes container
- ✅ Preserves configuration files and logs
- ✅ Confirms successful shutdown

## Usage

### Start Nginx
```bash
cd /home/zhenac/my/lens_2026_deployment/docker_compose_chentown_cn/lens-infra/lens-infra-nginx
./start.sh
```

Expected output:
```
================================
Starting Nginx Container...
================================
Creating Docker network: solution_backnet
Creating conf/conf.d directory...
Creating logs directory...
Pulling latest Nginx image...
Starting Nginx service...
Waiting for Nginx to start...
✅ Nginx container is running

Service Details:
  Container ID: abc123def456
  Status: Up 3 seconds
  Ports: 0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp

Network Configuration:
  Network: solution_backnet
  IP Address: 172.28.0.80

Web Services:
  HTTP: http://localhost:80
  HTTPS: https://localhost:443
  Domain: chentown.cn

Configuration:
  Nginx Config: ./conf/nginx.conf
  Sites Config: ./conf/conf.d/
  Logs: /home/user/containers/lens-infra-nginx/logs

View logs:
  docker-compose -f lens-infra-nginx.yml logs -f
  or
  docker logs -f lens-infra-nginx

================================
Nginx started successfully!
================================
```

### Stop Nginx
```bash
./stop.sh
```

Expected output:
```
================================
Stopping Nginx Container...
================================
Stopping Nginx service...
Removing Nginx container...
✅ Nginx container stopped successfully

Summary:
  - Nginx service stopped
  - Container removed
  - Configuration files preserved at ./conf/
  - Logs preserved at /home/user/containers/lens-infra-nginx/logs/

To restart:
  ./start.sh

To remove logs:
  rm -rf /home/user/containers/lens-infra-nginx/logs/*

================================
Nginx stopped successfully!
================================
```

## Common Operations

### View Nginx Logs
```bash
# Real-time logs
docker-compose -f lens-infra-nginx.yml logs -f

# Or using docker directly
docker logs -f lens-infra-nginx

# View logs since specific time
docker logs --since 10m lens-infra-nginx
```

### Access Nginx Container
```bash
# Interactive shell
docker exec -it lens-infra-nginx /bin/bash

# View running processes
docker exec lens-infra-nginx ps aux

# Check Nginx version
docker exec lens-infra-nginx nginx -v
```

### Test Nginx Configuration
```bash
# Validate Nginx configuration
docker exec lens-infra-nginx nginx -t

# Check configuration with verbose output
docker exec lens-infra-nginx nginx -T
```

### Reload Nginx Configuration
```bash
# Reload Nginx without stopping
docker exec lens-infra-nginx nginx -s reload

# Graceful shutdown and restart
docker-compose -f lens-infra-nginx.yml restart
```

### Check Container Status
```bash
# Show container status
docker ps | grep lens-infra-nginx

# Detailed container info
docker inspect lens-infra-nginx
```

### View Network Information
```bash
# Check network configuration
docker network inspect solution_backnet

# Show container network settings
docker inspect lens-infra-nginx --format='{{json .NetworkSettings.Networks}}' | jq
```

### Test HTTP/HTTPS Connectivity
```bash
# Test HTTP
curl -I http://localhost

# Test HTTPS (ignore self-signed cert warnings)
curl -I -k https://localhost

# Test with specific domain
curl -I -H "Host: chentown.cn" http://localhost
```

### View Nginx Configuration
```bash
# Show main config
docker exec lens-infra-nginx cat /etc/nginx/nginx.conf

# Show all loaded configs
docker exec lens-infra-nginx nginx -T
```

## Directory Structure

```
lens-infra-nginx/
├── start.sh                          (Startup script)
├── stop.sh                           (Stop script)
├── README.md                         (This file)
├── lens-infra-nginx.yml              (Docker Compose config)
├── conf/
│   ├── nginx.conf                   (Main Nginx configuration)
│   └── conf.d/                      (Site-specific configurations)
└── (logs are stored at ~/containers/lens-infra-nginx/logs)
```

## Troubleshooting

### Container Won't Start
1. Check if Docker is running: `docker ps`
2. Check logs: `docker-compose -f lens-infra-nginx.yml logs`
3. Verify lens-infra-nginx.yml exists in current directory
4. Check if ports 80/443 are already in use:
   ```bash
   netstat -an | grep -E ':80|:443'
   ```
5. Verify Docker network exists:
   ```bash
   docker network inspect solution_backnet
   ```

### Permission Denied
1. Ensure scripts have execute permission:
   ```bash
   chmod +x start.sh stop.sh
   ```
2. Run with sudo if needed:
   ```bash
   sudo ./start.sh
   ```

### Nginx Configuration Error
1. Check logs for specific error:
   ```bash
   docker-compose -f lens-infra-nginx.yml logs
   ```
2. Validate configuration in container:
   ```bash
   docker exec lens-infra-nginx nginx -t
   ```
3. Verify config files exist:
   ```bash
   ls -la conf/
   ```

### Port Already in Use
```bash
# Find process using port 80
lsof -i :80

# Find process using port 443
lsof -i :443

# Kill process (replace PID with actual process ID)
kill -9 PID
```

### Connection Refused
1. Verify Nginx container is running:
   ```bash
   docker ps | grep lens-infra-nginx
   ```
2. Check logs for errors:
   ```bash
   docker logs lens-infra-nginx
   ```
3. Verify port mapping:
   ```bash
   docker ps --filter "name=lens-infra-nginx"
   ```

## Performance & Monitoring

### Check Resource Usage
```bash
docker stats lens-infra-nginx
```

### Monitor Access Logs
```bash
tail -f ~/containers/lens-infra-nginx/logs/access.log
```

### Monitor Error Logs
```bash
tail -f ~/containers/lens-infra-nginx/logs/error.log
```

## Configuration Management

### Add New Site Configuration
1. Create configuration file: `conf/conf.d/mysite.conf`
2. Add Nginx server block configuration
3. Reload Nginx:
   ```bash
   docker exec lens-infra-nginx nginx -s reload
   ```

### Update Main Configuration
1. Edit `conf/nginx.conf`
2. Reload Nginx:
   ```bash
   docker exec lens-infra-nginx nginx -s reload
   ```

### Backup Configuration
```bash
# Backup entire config directory
tar -czf nginx-config-backup.tar.gz conf/

# Backup logs
tar -czf nginx-logs-backup.tar.gz ~/containers/lens-infra-nginx/logs/
```

## Advanced Operations

### Restart Container
```bash
./stop.sh
./start.sh
```

### Remove Container (Keep Data)
```bash
./stop.sh
```

### Remove Container and Logs (DESTRUCTIVE)
```bash
docker-compose -f lens-infra-nginx.yml down -v
```

### Update Nginx Image
```bash
# Pull latest image
docker-compose -f lens-infra-nginx.yml pull

# Restart with new image
./stop.sh
./start.sh
```

## Service Dependencies

Nginx may proxy requests to other services. Common backend services:
- Lens Blog Backend (Blog API)
- Lens Platform Services (Authentication, System, etc.)
- Lens Admin Backends
- Other microservices

Ensure backend services are running before accessing through Nginx.

---

**Location**: `/home/zhenac/my/lens_2026_deployment/docker_compose_chentown_cn/lens-infra/lens-infra-nginx`

**Configuration File**: `lens-infra-nginx.yml`

**Managed Service**: Nginx Reverse Proxy & Web Server

**Last Updated**: 2026-01-26
