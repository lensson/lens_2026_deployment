# Database & Cache Services Docker Container Management

## Overview

These scripts manage multiple Docker containers defined in `lens-db.yml`:
- **MariaDB** - Relational database server
- **Adminer** - Web-based database management UI
- **Redis** - In-memory data structure store for caching

All containers are deployed together using Docker Compose for the Lens 2026 deployment.

## Scripts

### start.sh
Starts all containers defined in lens-db.yml:
- ✅ Checks if Docker daemon is running
- ✅ Verifies lens-db.yml configuration file exists
- ✅ Creates Docker network if needed
- ✅ Pulls latest images for all services
- ✅ Starts MariaDB, Adminer, and Redis containers
- ✅ Waits for all containers to be ready
- ✅ Displays status of all running containers
- ✅ Shows connection details for each service
- ✅ Shows logs in case of failure

### stop.sh
Stops all containers gracefully:
- ✅ Checks if Docker daemon is running
- ✅ Verifies lens-db.yml exists
- ✅ Checks if any containers are running
- ✅ Stops all containers gracefully
- ✅ Removes all containers (preserves data)
- ✅ Confirms all containers are stopped
- ✅ Provides information on data cleanup options
- ✅ Lists all stopped services

## Usage

### Start All Services
```bash
cd /home/zhenac/my/lens_2026_deployment/docker_compose_chentown_cn/3rd-party/lens-db
./start.sh
```

This starts:
- MariaDB database server (port 33306)
- Adminer web UI (port 38080)
- Redis cache server (port 6379)

Expected output:
```
================================
Starting Database & Cache Services...
================================
Creating Docker network: solution_backnet
Pulling latest images...
Starting services...
Waiting for services to start...
✅ All containers started successfully

Running Containers:
================================
  lens-mariadb:
    Status: Up 3 seconds
    Ports: 0.0.0.0:33306->3306/tcp

  lens-mariadb-adminer:
    Status: Up 2 seconds
    Ports: 0.0.0.0:38080->8080/tcp

  lens-redis:
    Status: Up 3 seconds
    Ports: 0.0.0.0:6379->6379/tcp

Database Access:
  MariaDB Host: localhost:33306
  MariaDB User: root
  MariaDB Password: mysql

Admin Tools:
  Adminer Web UI: http://localhost:38080
  Redis Port: localhost:6379

View logs:
  docker-compose -f lens-db.yml logs -f

================================
All services started successfully!
================================
```

### Stop All Services
```bash
cd /home/zhenac/my/lens_2026_deployment/docker_compose_chentown_cn/3rd-party/lens-db
./stop.sh
```

This stops and removes:
- MariaDB container
- Adminer container
- Redis container

Expected output:
```
================================
Stopping Database & Cache Services...
================================
Stopping all services...
Removing all containers...
✅ All containers stopped successfully

Stopped Containers:
  - lens-mariadb (MariaDB database)
  - lens-mariadb-adminer (Web database UI)
  - lens-redis (Redis cache)

Summary:
  ✓ MariaDB container stopped
  ✓ Adminer container stopped
  ✓ Redis container stopped
  ✓ Data persisted in volumes

To restart all services:
  ./start.sh

To remove all data (WARNING: destructive):
  docker-compose -f lens-db.yml down -v

================================
All services stopped successfully!
================================
```

## Service Connection Details

### MariaDB Database
Connection parameters:
- **Host**: localhost
- **Port**: 33306
- **Username**: root
- **Password**: mysql

Command line access:
```bash
mysql -h localhost -P 33306 -u root -pmysql
```

### Adminer Web UI
Web-based database management interface:
- **URL**: http://localhost:38080
- **Server**: lens-mariadb (or localhost:33306)
- **Username**: root
- **Password**: mysql

### Redis Cache
In-memory data structure store:
- **Host**: localhost
- **Port**: 6379

Command line access:
```bash
redis-cli -h localhost -p 6379
```

## Common Operations

### View All Container Logs
```bash
docker-compose -f lens-db.yml logs -f
```

### View Logs for Specific Service
```bash
# MariaDB logs
docker-compose -f lens-db.yml logs -f lens-mariadb

# Adminer logs
docker-compose -f lens-db.yml logs -f lens-mariadb-adminer

# Redis logs
docker-compose -f lens-db.yml logs -f lens-redis
```

### Check All Container Status
```bash
docker ps | grep lens-
```

### Execute SQL Commands in MariaDB
```bash
docker exec -it lens-mariadb mysql -u root -pmysql
```

### Access Redis CLI
```bash
docker exec -it lens-redis redis-cli
```

### Access Adminer Web UI
Open browser and navigate to:
```
http://localhost:38080
```

### Backup MariaDB Database
```bash
docker exec lens-mariadb mysqldump -u root -pmysql --all-databases > backup.sql
```

### Restore MariaDB Database
```bash
docker exec -i lens-mariadb mysql -u root -pmysql < backup.sql
```

### Check Redis Memory Usage
```bash
docker exec lens-redis redis-cli info memory
```

### List All Redis Keys
```bash
docker exec lens-redis redis-cli keys '*'
```

## Troubleshooting

### Containers Won't Start
1. Check if Docker is running: `docker ps`
2. Check logs: `docker-compose -f lens-db.yml logs`
3. Verify lens-db.yml exists in the current directory
4. Check if required ports are not already in use:
   ```bash
   netstat -an | grep 33306  # MariaDB
   netstat -an | grep 38080  # Adminer
   netstat -an | grep 6379   # Redis
   ```
5. Verify Docker network exists:
   ```bash
   docker network inspect solution_backnet
   ```

### MariaDB Connection Refused
1. Verify MariaDB container is running: `docker ps | grep lens-mariadb`
2. Wait a few more seconds for MariaDB to fully start
3. Check logs: `docker-compose -f lens-db.yml logs lens-mariadb`
4. Verify port mapping: `docker ps --filter "name=lens-mariadb"`

### Adminer Web UI Not Accessible
1. Verify Adminer container is running: `docker ps | grep lens-mariadb-adminer`
2. Check logs: `docker-compose -f lens-db.yml logs lens-mariadb-adminer`
3. Verify MariaDB is accessible (Adminer depends on it)
4. Try accessing: http://localhost:38080

### Redis Connection Issues
1. Verify Redis container is running: `docker ps | grep lens-redis`
2. Check logs: `docker-compose -f lens-db.yml logs lens-redis`
3. Verify port is accessible: `redis-cli -h localhost -p 6379 ping`

### Permission Denied
1. Ensure scripts have execute permission:
   ```bash
   chmod +x start.sh stop.sh
   ```
2. Run with sudo if needed:
   ```bash
   sudo ./start.sh
   ```

### One Container Started But Others Failed
1. Check all logs: `docker-compose -f lens-db.yml logs`
2. Some containers may depend on others (e.g., Adminer depends on MariaDB)
3. Stop and restart all containers:
   ```bash
   ./stop.sh
   ./start.sh
   ```

## Data Persistence

- Container data is persisted in Docker volumes
- Data survives container restart/stop
- To permanently delete data, use:
  ```bash
  docker-compose -f lens-db.yml down -v
  ```

## Additional Commands

### Restart All Services
```bash
./stop.sh
./start.sh
```

### Stop Services Only (Keep Containers)
```bash
docker-compose -f lens-db.yml stop
```

### Start Stopped Containers (Without Removing)
```bash
docker-compose -f lens-db.yml start
```

### Remove Containers (Keep Data Volumes)
```bash
./stop.sh
```

### Remove Everything Including Data (DESTRUCTIVE)
```bash
docker-compose -f lens-db.yml down -v
```

### Access Container Shell
```bash
# MariaDB container
docker exec -it lens-mariadb /bin/bash

# Adminer container
docker exec -it lens-mariadb-adminer /bin/bash

# Redis container
docker exec -it lens-redis /bin/bash
```

### View Container Resource Usage
```bash
docker stats --no-stream lens-mariadb lens-mariadb-adminer lens-redis
```

### Inspect Container Configuration
```bash
docker inspect lens-mariadb
docker inspect lens-mariadb-adminer
docker inspect lens-redis
```

## Services Summary

| Service | Container | Port | Purpose |
|---------|-----------|------|---------|
| MariaDB | lens-mariadb | 33306 | Relational database |
| Adminer | lens-mariadb-adminer | 38080 | Web DB management UI |
| Redis | lens-redis | 6379 | In-memory cache store |

---

**Location**: `/home/zhenac/my/lens_2026_deployment/docker_compose_chentown_cn/3rd-party/lens-db`

**Configuration File**: `lens-db.yml`

**Managed Services**:
- MariaDB database server
- Adminer web interface
- Redis cache server

**Last Updated**: 2026-01-23
