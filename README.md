# lens_2026_deployment

This directory contains all deployment configurations for the Lens 2026 project, including Docker Compose files, environment configurations, SQL initialization scripts, and service deployment manifests.

## Directory Structure

```
lens_2026_deployment/
├── README.md                    # This file
├── chentown_cn/                 # Docker Compose configurations for chentown environment
│   ├── 3rd-party/              # Third-party services (DB, Nacos, RabbitMQ, etc.)
│   ├── env/                    # Environment variables
│   ├── lens-blog/              # Blog service configurations
│   ├── lens-infra/             # Infrastructure configurations
│   └── lens-platform/          # Platform service configurations
├── docker_compose/             # Additional Docker Compose setups
└── sql/                         # Database initialization scripts
    ├── 01_root/                # Root database setup
    ├── 02_nacos/               # Nacos database initialization
    ├── 03_lensinfra/           # Infrastructure database
    ├── 04_platform/            # Platform database
    ├── 05_plumemo/             # Plumemo database
    ├── 06_lensblog/            # Blog database
    └── backup/                 # Database backups
```

## Quick Start

### Prerequisites
- Docker & Docker Compose (v3.8+)
- 8GB+ RAM recommended
- Ports 80, 443, 3306, 6379, 8848, 8888 available

### Start Services

```bash
cd chentown_cn

# Start all infrastructure services
cd ../3rd-party
./lens-db/start.sh
./lens-nacos/start.sh
./lens-zipkin/start.sh
./lens-rabbitmq/start.sh
./lens-keycloak/start.sh
./lens-prometheus/start.sh

# Start platform services
cd ../lens-platform
./start.sh

# Start blog services
cd ../lens-blog
./start.sh
```

### Stop Services

```bash
cd chentown_cn

# Stop services (reverse order)
cd lens-blog
./stop.sh

cd ../lens-platform
./stop.sh

cd ../3rd-party
./lens-prometheus/stop.sh
./lens-keycloak/stop.sh
./lens-rabbitmq/stop.sh
./lens-zipkin/stop.sh
./lens-nacos/stop.sh
./lens-db/stop.sh
```

## Service Deployment Map

### Database & Cache Layer
| 服务                     | 内部IP地址       | 内部端口 | 外部端口  | 说明                |
|------------------------|--------------|------|-------|-------------------|
| lens-mariadb           | 172.28.0.11  | 3306 | 33306 | MariaDB 数据库      |
| lens-mariadb-adminer   | 172.28.0.12  | 8080 | 38080 | 数据库管理界面      |
| lens-redis             | 172.28.0.13  | 6379 | 6379  | 缓存服务            |

### Infrastructure Services
| 服务                     | 内部IP地址       | 内部端口 | 外部端口  | 域名                |
|------------------------|--------------|------|-------|-------------------|
| lens-infra-nginx       | 172.28.0.80  | 80   | 80    | 反向代理/负载均衡   |
| lens-nacos             | 172.28.0.21  | 8848 | 8848  | nacos.chentown.cn |
| lens-zipkin            | -            | -    | -     | 分布式追踪          |
| lens-rabbitmq          | -            | -    | -     | 消息队列            |
| lens-prometheus        | -            | -    | -     | 监控平台            |
| lens-keycloak          | -            | -    | -     | 身份认证提供商      |

### Platform Services
| 服务                     | 内部IP地址       | 外部端口  | 说明                |
|------------------------|--------------|-------|-------------------|
| lens-platform-gateway  | 172.28.0.40  | 8888  | API 网关            |
| lens-platform-auth     | 172.28.0.41  | -     | 认证服务            |
| lens-platform-system   | -            | -     | 系统管理服务        |
| lens-platform-monitor  | -            | -     | 监控服务            |

### Blog Services
| 服务                           | 内部IP地址       | 说明                |
|--------------------------------|--------------|-------------------|
| lens-blog-admin-backend        | 172.28.0.102 | 博客管理后端        |
| lens-blog-admin-vue-frontend   | -            | 博客管理前端        |
| lens-blog-backend              | 172.28.0.101 | 博客公开API         |
| lens-blog-vue-frontend         | 172.28.0.181 | 博客前端            |
| lens-blog-search               | -            | 搜索服务            |
| lens-blog-sms                  | -            | 短信服务            |
| lens-blog-picture              | 172.28.0.112 | 图片管理服务        |
| lens-blog-spider               | -            | 内容爬虫服务        |

### WeChat Integration (Optional)
| 服务                           | 内部IP地址       | 说明                |
|--------------------------------|--------------|-------------------|
| lens-gzh-server                | 172.28.0.131 | 微信公众号后端      |
| lens-gzh-frontend              | 172.28.0.171 | 微信公众号前端      |

## Environment Configuration

### Network Configuration (`env/network.env`)
Contains Docker network settings and IP ranges.

### Solution Configuration (`env/solution.env`)
Contains application-specific environment variables.

## Database Initialization

### Initialize Databases

```bash
cd sql
./initDb.sh
```

### Individual Database Initialization

```bash
# Root database
sql/01_root/

# Nacos configuration center
sql/02_nacos/

# Infrastructure database
sql/03_lensinfra/

# Platform database
sql/04_platform/

# Plumemo (memo service) database
sql/05_plumemo/

# Blog database
sql/06_lensblog/
```

## Configuration Files

### Third-Party Services

#### Nacos Configuration
- **Location**: `chentown_cn/3rd-party/lens-nacos/`
- **Config File**: `conf/lens-nacos.env`
- **Init Script**: `init.d/custom.properties`

#### RabbitMQ Configuration
- **Location**: `chentown_cn/3rd-party/lens-rabbitmq/`
- **Config File**: `etc/rabbitmq.conf`
- **Plugins**: `etc/enabled_plugins`

#### Prometheus Configuration
- **Location**: `chentown_cn/3rd-party/lens-prometheus/`
- **Config File**: `config/prometheus-standalone.yaml`

#### Keycloak Configuration
- **Location**: `chentown_cn/3rd-party/lens-keycloak/`
- **Realm File**: `import/my-realm.json`
- **Env File**: `config/lens-keycloak.env`

#### Zipkin Configuration
- **Location**: `chentown_cn/3rd-party/lens-zipkin/`
- **Config File**: `lens-zipkin.env`

### Service Configurations

#### Blog Services
- **Location**: `chentown_cn/lens-blog/`
- **Files**:
  - `lens-blog.yml` - Compose file
  - `lens-blog-admin-backend.yml` - Admin backend
  - `lens-blog-admin-vue-frontend.yml` - Admin frontend
  - `lens-blog-backend.yml` - Public API
  - `lens-blog-vue-frontend.yml` - Web frontend
  - `lens-blog-picture.yml` - Picture service
  - `lens-blog-monitor.yml` - Monitoring

#### Platform Services
- **Location**: `chentown_cn/lens-platform/`
- **Files**:
  - `lens-platform.yml` - Compose file
  - `lens-platform-gateway.yml` - API Gateway
  - `lens-platform-auth.yml` - Auth service

#### Infrastructure
- **Location**: `chentown_cn/lens-infra/`
- **Files**: Nginx configuration and deployment

## Common Operations

### View Logs

```bash
# View specific service logs
docker-compose -f lens-blog.yml logs -f lens-blog-backend

# View all logs
docker-compose -f lens-blog.yml logs -f
```

### Access Services

| Service | URL | Credentials |
|---------|-----|-------------|
| Nacos | http://localhost:8848 | nacos/nacos |
| Prometheus | http://localhost:9090 | - |
| RabbitMQ | http://localhost:15672 | guest/guest |
| Zipkin | http://localhost:9411 | - |
| Keycloak | http://localhost:8080 | admin/admin |
| Blog API | http://localhost:8888/blog | - |
| Platform Gateway | http://localhost:8888 | - |

### Restart Services

```bash
cd chentown_cn/lens-blog
docker-compose -f lens-blog.yml restart lens-blog-backend
```

### Scale Services

```bash
cd chentown_cn/lens-platform
docker-compose -f lens-platform.yml up -d --scale lens-platform-gateway=3
```

## Troubleshooting

### Port Already in Use
```bash
# Find process using port
lsof -i :8848

# Kill process
kill -9 <PID>
```

### Network Issues
```bash
# Check Docker network
docker network ls
docker network inspect <network-name>

# View service connectivity
docker ps --filter "label=com.docker.compose.service=lens-blog-backend"
```

### Database Connection Failed
```bash
# Check MariaDB container
docker ps | grep mariadb

# Access database directly
docker exec -it lens-mariadb mysql -uroot -ppassword
```

### Memory Issues
```bash
# Check Docker resource usage
docker stats

# Limit container memory
docker update --memory 2g <container-id>
```

## Backup & Recovery

### Backup Database
```bash
docker exec lens-mariadb mysqldump -uroot -ppassword --all-databases > backup.sql
```

### Restore Database
```bash
docker exec -i lens-mariadb mysql -uroot -ppassword < backup.sql
```

### Backup Files
```bash
# Backup configurations
tar -czf lens-2026-config-backup-$(date +%Y%m%d).tar.gz chentown_cn/
```

## Security Considerations

1. **Change Default Passwords**
   - Nacos: Change default nacos/nacos
   - RabbitMQ: Change default guest/guest
   - Keycloak: Change default admin/admin
   - MariaDB: Change root password

2. **Network Isolation**
   - Use Docker networks to isolate services
   - Restrict external port exposure
   - Use firewall rules

3. **Secrets Management**
   - Use environment files for sensitive data
   - Store credentials in secure vaults
   - Rotate credentials regularly

4. **SSL/TLS**
   - Enable HTTPS for all external services
   - Use valid certificates (not self-signed in production)

## Performance Tuning

### Database Optimization
- Enable query caching
- Optimize index usage
- Monitor slow queries

### Cache Optimization
- Configure Redis memory limits
- Implement cache eviction policies
- Monitor cache hit rates

### Gateway Optimization
- Enable connection pooling
- Configure request timeouts
- Load balance across instances

## Monitoring & Alerts

### Prometheus Scrape Targets
- MariaDB exporter
- Redis exporter
- Node exporter
- JVM metrics from services

### Key Metrics to Monitor
- Request latency
- Error rates
- Memory usage
- Disk space
- Database connections

### Alert Rules
Configure alert thresholds for:
- High CPU usage (>80%)
- High memory usage (>85%)
- Disk space (<10% free)
- Service unavailability
- High error rates (>5%)

## Useful Commands

```bash
# Remove all containers and volumes (WARNING: Data loss!)
docker-compose -f lens-blog.yml down -v

# Rebuild images
docker-compose -f lens-blog.yml build --no-cache

# Run service in detached mode
docker-compose -f lens-blog.yml up -d

# View running containers
docker ps

# Execute command in container
docker exec -it <container-id> /bin/bash

# Copy file to container
docker cp <file> <container-id>:/path

# View container stats
docker stats <container-id>
```

## Support & Documentation

For more information:
- See `/home/zhenac/my/MODULES_SUMMARY.md` for project structure
- Check individual service documentation in each subdirectory
- Review Docker Compose files for detailed service configuration
- Consult the main lens_2026 project repository

## License

See LICENSE file in the main project repository.

---

**Last Updated**: 2026-01-22  
**Version**: 2.0.0-SNAPSHOT
