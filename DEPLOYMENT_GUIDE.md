# Uber Clone Deployment Guide

This comprehensive deployment guide provides step-by-step instructions for deploying the Uber Clone application in development, staging, and production environments.

## 📋 Table of Contents

1. [System Architecture](#system-architecture)
2. [Prerequisites](#prerequisites)
3. [Development Environment Setup](#development-environment-setup)
4. [Staging Environment Deployment](#staging-environment-deployment)
5. [Production Environment Deployment](#production-environment-deployment)
6. [Database Configuration](#database-configuration)
7. [Environment Variables](#environment-variables)
8. [SSL/TLS Configuration](#ssltls-configuration)
9. [Monitoring and Logging](#monitoring-and-logging)
10. [Backup and Recovery](#backup-and-recovery)
11. [Scaling and Performance](#scaling-and-performance)
12. [Security Considerations](#security-considerations)

## 🏗️ System Architecture

The Uber Clone application follows a microservices architecture with the following components:

### Backend Services
- **Rider Service**: Port 3010 - Handles rider-related functionality
- **Driver Service**: Port 3020 - Manages driver operations
- **Admin Service**: Port 3030 - Provides administrative functions
- **Shared Utilities**: Common libraries and utilities
- **Database**: PostgreSQL for data persistence
- **Redis**: Caching and session management
- **Socket.IO**: Real-time communication

### Frontend Applications
- **Rider App**: Port 3000 - Rider-facing web application
- **Driver App**: Port 3001 - Driver-facing web application
- **Admin App**: Port 3002 - Administrative web interface
- **Shared Package**: Common UI components and utilities

### Infrastructure Components
- **Load Balancer**: Distributes traffic across services
- **Reverse Proxy**: Nginx for SSL termination and routing
- **Container Orchestration**: Docker Compose for multi-container deployment
- **Monitoring**: Prometheus and Grafana for metrics
- **Logging**: ELK stack for centralized logging

## 📦 Prerequisites

### Hardware Requirements

**Minimum (Development):**
- CPU: 2 cores
- RAM: 4 GB
- Storage: 20 GB SSD
- Network: 10 Mbps bandwidth

**Recommended (Production):**
- CPU: 8 cores
- RAM: 16 GB
- Storage: 100 GB SSD
- Network: 100 Mbps bandwidth

### Software Requirements

**Operating Systems:**
- Ubuntu 20.04 LTS or later
- CentOS 8 or later
- macOS 11.0 or later (development)
- Windows 10/11 with WSL2 (development)

**Required Software:**
- Node.js 18.x or later
- npm 8.x or later
- PostgreSQL 13.x or later
- Docker 20.x or later
- Docker Compose 1.29.x or later
- Nginx 1.20.x or later
- Git 2.30.x or later

### Development Tools

**IDE/Editors:**
- Visual Studio Code (recommended)
- IntelliJ IDEA
- WebStorm

**Additional Tools:**
- Postman for API testing
- pgAdmin for database management
- Redis Desktop Manager for cache monitoring

## 💻 Development Environment Setup

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/uber-clone.git
cd uber-clone
```

### 2. Install Dependencies

```bash
# Install backend service dependencies
cd backend-services/shared-utils
npm install

cd ../rider-service
npm install

cd ../driver-service
npm install

cd ../admin-service
npm install

# Install frontend application dependencies
cd ../../flutter-apps/rider_app
flutter pub get

cd ../driver_app
flutter pub get

cd ../admin_app
flutter pub get

# Install shared package dependencies
cd ../../flutter-packages/uber_shared
flutter pub get
```

### 3. Configure Environment Variables

Create `.env` files in each service directory:

**rider-service/.env:**
```env
NODE_ENV=development
PORT=3010
DB_HOST=localhost
DB_PORT=5432
DB_NAME=uber_clone_rider
DB_USER=uber_user
DB_PASSWORD=uber_password
JWT_SECRET=uber_clone_secret_key_for_development_only
MAPBOX_ACCESS_TOKEN=your_mapbox_token
GOOGLE_MAPS_API_KEY=your_google_maps_key
```

Repeat for driver-service and admin-service with appropriate port numbers.

### 4. Set Up Database

```bash
# Start PostgreSQL
sudo systemctl start postgresql

# Create databases
sudo -u postgres psql -c "CREATE DATABASE uber_clone_rider;"
sudo -u postgres psql -c "CREATE DATABASE uber_clone_driver;"
sudo -u postgres psql -c "CREATE DATABASE uber_clone_admin;"
sudo -u postgres psql -c "CREATE USER uber_user WITH PASSWORD 'uber_password';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE uber_clone_rider TO uber_user;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE uber_clone_driver TO uber_user;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE uber_clone_admin TO uber_user;"
```

### 5. Run Database Migrations

```bash
# Run migrations for each service
cd backend-services/rider-service
npx sequelize-cli db:migrate

cd ../driver-service
npx sequelize-cli db:migrate

cd ../admin-service
npx sequelize-cli db:migrate
```

### 6. Start Development Servers

```bash
# Terminal 1: Start Rider Service
cd backend-services/rider-service
npm run dev

# Terminal 2: Start Driver Service
cd backend-services/driver-service
npm run dev

# Terminal 3: Start Admin Service
cd backend-services/admin-service
npm run dev

# Terminal 4: Start Rider App
cd flutter-apps/rider_app
flutter run -d chrome --web-port 3000

# Terminal 5: Start Driver App
cd flutter-apps/driver_app
flutter run -d chrome --web-port 3001

# Terminal 6: Start Admin App
cd flutter-apps/admin_app
flutter run -d chrome --web-port 3002
```

### 7. Verify Installation

Visit the following URLs:
- Rider App: http://localhost:3000
- Driver App: http://localhost:3001
- Admin App: http://localhost:3002
- Rider API: http://localhost:3010
- Driver API: http://localhost:3020
- Admin API: http://localhost:3030

## ☁️ Staging Environment Deployment

### 1. Server Preparation

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install required software
sudo apt install -y docker docker-compose nginx postgresql redis-server git

# Start and enable services
sudo systemctl start docker postgresql redis-server nginx
sudo systemctl enable docker postgresql redis-server nginx
```

### 2. Deploy with Docker Compose

Create `docker-compose.staging.yml`:

```yaml
version: '3.8'

services:
  rider-db:
    image: postgres:13
    environment:
      POSTGRES_DB: uber_clone_rider
      POSTGRES_USER: uber_user
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - rider_db_data:/var/lib/postgresql/data
    networks:
      - uber-network

  driver-db:
    image: postgres:13
    environment:
      POSTGRES_DB: uber_clone_driver
      POSTGRES_USER: uber_user
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - driver_db_data:/var/lib/postgresql/data
    networks:
      - uber-network

  admin-db:
    image: postgres:13
    environment:
      POSTGRES_DB: uber_clone_admin
      POSTGRES_USER: uber_user
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - admin_db_data:/var/lib/postgresql/data
    networks:
      - uber-network

  redis:
    image: redis:7-alpine
    networks:
      - uber-network

  rider-service:
    build:
      context: ./backend-services/rider-service
    ports:
      - "3010:3010"
    environment:
      NODE_ENV: staging
      DB_HOST: rider-db
      DB_PORT: 5432
      DB_NAME: uber_clone_rider
      DB_USER: uber_user
      DB_PASSWORD: ${DB_PASSWORD}
      REDIS_URL: redis://redis:6379
    depends_on:
      - rider-db
      - redis
    networks:
      - uber-network

  driver-service:
    build:
      context: ./backend-services/driver-service
    ports:
      - "3020:3020"
    environment:
      NODE_ENV: staging
      DB_HOST: driver-db
      DB_PORT: 5432
      DB_NAME: uber_clone_driver
      DB_USER: uber_user
      DB_PASSWORD: ${DB_PASSWORD}
      REDIS_URL: redis://redis:6379
    depends_on:
      - driver-db
      - redis
    networks:
      - uber-network

  admin-service:
    build:
      context: ./backend-services/admin-service
    ports:
      - "3030:3030"
    environment:
      NODE_ENV: staging
      DB_HOST: admin-db
      DB_PORT: 5432
      DB_NAME: uber_clone_admin
      DB_USER: uber_user
      DB_PASSWORD: ${DB_PASSWORD}
      REDIS_URL: redis://redis:6379
    depends_on:
      - admin-db
      - redis
    networks:
      - uber-network

  rider-app:
    build:
      context: ./flutter-apps/rider_app
      args:
        - BASE_URL=http://localhost:3010
    ports:
      - "3000:80"
    networks:
      - uber-network

  driver-app:
    build:
      context: ./flutter-apps/driver_app
      args:
        - BASE_URL=http://localhost:3020
    ports:
      - "3001:80"
    networks:
      - uber-network

  admin-app:
    build:
      context: ./flutter-apps/admin_app
      args:
        - BASE_URL=http://localhost:3030
    ports:
      - "3002:80"
    networks:
      - uber-network

networks:
  uber-network:
    driver: bridge

volumes:
  rider_db_data:
  driver_db_data:
  admin_db_data:
```

### 3. Build and Deploy

```bash
# Create environment file
echo "DB_PASSWORD=your_secure_password" > .env

# Build and start services
docker-compose -f docker-compose.staging.yml up -d

# Run database migrations
docker-compose -f docker-compose.staging.yml exec rider-service npx sequelize-cli db:migrate
docker-compose -f docker-compose.staging.yml exec driver-service npx sequelize-cli db:migrate
docker-compose -f docker-compose.staging.yml exec admin-service npx sequelize-cli db:migrate
```

## 🚀 Production Environment Deployment

### 1. Infrastructure Setup

**Cloud Provider Options:**
- AWS EC2 instances with RDS and ElastiCache
- Google Cloud Platform with Cloud SQL and Memorystore
- Azure Virtual Machines with Azure Database for PostgreSQL
- DigitalOcean Droplets with managed databases

### 2. Production Docker Compose

Create `docker-compose.prod.yml`:

```yaml
version: '3.8'

services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/ssl:/etc/nginx/ssl
      - ./logs/nginx:/var/log/nginx
    depends_on:
      - rider-app
      - driver-app
      - admin-app
    networks:
      - uber-network

  rider-service:
    build:
      context: ./backend-services/rider-service
      dockerfile: Dockerfile.prod
    environment:
      NODE_ENV: production
      DB_HOST: ${RIDER_DB_HOST}
      DB_PORT: ${RIDER_DB_PORT}
      DB_NAME: ${RIDER_DB_NAME}
      DB_USER: ${RIDER_DB_USER}
      DB_PASSWORD: ${RIDER_DB_PASSWORD}
      REDIS_URL: ${REDIS_URL}
      JWT_SECRET: ${JWT_SECRET}
    networks:
      - uber-network
    deploy:
      replicas: 3
      restart_policy:
        condition: on-failure
      resources:
        limits:
          cpus: '0.5'
          memory: 512M

  driver-service:
    build:
      context: ./backend-services/driver-service
      dockerfile: Dockerfile.prod
    environment:
      NODE_ENV: production
      DB_HOST: ${DRIVER_DB_HOST}
      DB_PORT: ${DRIVER_DB_PORT}
      DB_NAME: ${DRIVER_DB_NAME}
      DB_USER: ${DRIVER_DB_USER}
      DB_PASSWORD: ${DRIVER_DB_PASSWORD}
      REDIS_URL: ${REDIS_URL}
      JWT_SECRET: ${JWT_SECRET}
    networks:
      - uber-network
    deploy:
      replicas: 3
      restart_policy:
        condition: on-failure
      resources:
        limits:
          cpus: '0.5'
          memory: 512M

  admin-service:
    build:
      context: ./backend-services/admin-service
      dockerfile: Dockerfile.prod
    environment:
      NODE_ENV: production
      DB_HOST: ${ADMIN_DB_HOST}
      DB_PORT: ${ADMIN_DB_PORT}
      DB_NAME: ${ADMIN_DB_NAME}
      DB_USER: ${ADMIN_DB_USER}
      DB_PASSWORD: ${ADMIN_DB_PASSWORD}
      REDIS_URL: ${REDIS_URL}
      JWT_SECRET: ${JWT_SECRET}
    networks:
      - uber-network
    deploy:
      replicas: 2
      restart_policy:
        condition: on-failure
      resources:
        limits:
          cpus: '0.5'
          memory: 512M

  rider-app:
    build:
      context: ./flutter-apps/rider_app
      dockerfile: Dockerfile.prod
      args:
        - BASE_URL=https://api.yourdomain.com/rider
    networks:
      - uber-network

  driver-app:
    build:
      context: ./flutter-apps/driver_app
      dockerfile: Dockerfile.prod
      args:
        - BASE_URL=https://api.yourdomain.com/driver
    networks:
      - uber-network

  admin-app:
    build:
      context: ./flutter-apps/admin_app
      dockerfile: Dockerfile.prod
      args:
        - BASE_URL=https://api.yourdomain.com/admin
    networks:
      - uber-network

networks:
  uber-network:
    driver: overlay

volumes:
  rider_logs:
  driver_logs:
  admin_logs:
```

### 3. Environment Configuration

Create `production.env`:

```env
# Database Configuration
RIDER_DB_HOST=rider-db.yourdomain.com
RIDER_DB_PORT=5432
RIDER_DB_NAME=uber_clone_rider
RIDER_DB_USER=uber_user
RIDER_DB_PASSWORD=your_secure_password

DRIVER_DB_HOST=driver-db.yourdomain.com
DRIVER_DB_PORT=5432
DRIVER_DB_NAME=uber_clone_driver
DRIVER_DB_USER=uber_user
DRIVER_DB_PASSWORD=your_secure_password

ADMIN_DB_HOST=admin-db.yourdomain.com
ADMIN_DB_PORT=5432
ADMIN_DB_NAME=uber_clone_admin
ADMIN_DB_USER=uber_user
ADMIN_DB_PASSWORD=your_secure_password

# Redis Configuration
REDIS_URL=redis://redis.yourdomain.com:6379

# Security
JWT_SECRET=your_production_jwt_secret_key
MAPBOX_ACCESS_TOKEN=your_production_mapbox_token
GOOGLE_MAPS_API_KEY=your_production_google_maps_key

# External Services
EMAIL_SERVICE_API_KEY=your_email_service_key
SMS_SERVICE_API_KEY=your_sms_service_key
PAYMENT_GATEWAY_SECRET=your_payment_gateway_secret
```

### 4. Deployment Commands

```bash
# Deploy to production cluster
docker stack deploy -c docker-compose.prod.yml uber-clone

# Scale services as needed
docker service scale uber-clone_rider-service=5
docker service scale uber-clone_driver-service=5
docker service scale uber-clone_admin-service=3

# Monitor deployment
docker service ls
docker service ps uber-clone_rider-service
```

## 🗄️ Database Configuration

### PostgreSQL Setup

**Production Database Configuration:**

```sql
-- Create databases
CREATE DATABASE uber_clone_rider OWNER uber_user;
CREATE DATABASE uber_clone_driver OWNER uber_user;
CREATE DATABASE uber_clone_admin OWNER uber_user;

-- Create read-only user for analytics
CREATE USER analytics_user WITH PASSWORD 'secure_analytics_password';
GRANT CONNECT ON DATABASE uber_clone_rider TO analytics_user;
GRANT USAGE ON SCHEMA public TO analytics_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analytics_user;

-- Set up connection pooling
ALTER SYSTEM SET max_connections = 200;
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET effective_cache_size = '1GB';
ALTER SYSTEM SET maintenance_work_mem = '64MB';
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
ALTER SYSTEM SET wal_buffers = '16MB';
ALTER SYSTEM SET default_statistics_target = 100;
ALTER SYSTEM SET random_page_cost = 1.1;
ALTER SYSTEM SET effective_io_concurrency = 200;
ALTER SYSTEM SET work_mem = '13107kB';
ALTER SYSTEM SET min_wal_size = '1GB';
ALTER SYSTEM SET max_wal_size = '4GB';
```

### Backup Strategy

```bash
#!/bin/bash
# backup.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups/postgresql"
RETENTION_DAYS=30

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup each database
pg_dump -h localhost -U uber_user -d uber_clone_rider > $BACKUP_DIR/rider_$DATE.sql
pg_dump -h localhost -U uber_user -d uber_clone_driver > $BACKUP_DIR/driver_$DATE.sql
pg_dump -h localhost -U uber_user -d uber_clone_admin > $BACKUP_DIR/admin_$DATE.sql

# Compress backups
gzip $BACKUP_DIR/*_$DATE.sql

# Remove old backups
find $BACKUP_DIR -name "*.sql.gz" -mtime +$RETENTION_DAYS -delete

# Upload to cloud storage (AWS S3 example)
aws s3 sync $BACKUP_DIR s3://your-backup-bucket/uber-clone/backups/

# Log backup completion
echo "Backup completed: $DATE" >> /var/log/uber-clone-backup.log
```

## 🔐 Environment Variables

### Required Variables

**Backend Services:**
```env
# General
NODE_ENV=production
PORT=3010
HOST=0.0.0.0

# Database
DB_HOST=your-db-host
DB_PORT=5432
DB_NAME=uber_clone_rider
DB_USER=uber_user
DB_PASSWORD=your_secure_password

# Redis
REDIS_URL=redis://your-redis-host:6379

# Security
JWT_SECRET=your_production_jwt_secret
JWT_EXPIRES_IN=1h

# External APIs
MAPBOX_ACCESS_TOKEN=your_mapbox_token
GOOGLE_MAPS_API_KEY=your_google_maps_key

# Email Service
EMAIL_SERVICE_PROVIDER=sendgrid
EMAIL_API_KEY=your_email_api_key

# SMS Service
SMS_SERVICE_PROVIDER=twilio
SMS_ACCOUNT_SID=your_twilio_sid
SMS_AUTH_TOKEN=your_twilio_token

# Payment Processing
PAYMENT_GATEWAY=stripe
PAYMENT_SECRET_KEY=your_stripe_secret_key
PAYMENT_PUBLISHABLE_KEY=your_stripe_publishable_key
```

### Security Best Practices

1. **Never commit secrets to version control**
2. **Use different secrets for each environment**
3. **Rotate secrets regularly**
4. **Use environment-specific configuration files**
5. **Encrypt sensitive configuration in production**

## 🔒 SSL/TLS Configuration

### Nginx SSL Configuration

```nginx
# nginx.conf

upstream rider_backend {
    server rider-service:3010;
}

upstream driver_backend {
    server driver-service:3020;
}

upstream admin_backend {
    server admin-service:3030;
}

server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name yourdomain.com www.yourdomain.com;

    ssl_certificate /etc/nginx/ssl/yourdomain.crt;
    ssl_certificate_key /etc/nginx/ssl/yourdomain.key;
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    
    # HSTS
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    
    # Content Security Policy
    add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline';";
    
    location /rider/ {
        proxy_pass http://rider_backend/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    location /driver/ {
        proxy_pass http://driver_backend/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    location /admin/ {
        proxy_pass http://admin_backend/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    location / {
        root /var/www/html;
        index index.html;
        try_files $uri $uri/ =404;
    }
}
```

### Let's Encrypt Certificate Setup

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx

# Obtain certificates
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# Auto-renewal
sudo crontab -e
# Add: 0 12 * * * /usr/bin/certbot renew --quiet
```

## 📊 Monitoring and Logging

### Prometheus Metrics Configuration

```yaml
# prometheus.yml

global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'uber-clone-rider'
    static_configs:
      - targets: ['rider-service:3010']
    metrics_path: '/metrics'

  - job_name: 'uber-clone-driver'
    static_configs:
      - targets: ['driver-service:3020']
    metrics_path: '/metrics'

  - job_name: 'uber-clone-admin'
    static_configs:
      - targets: ['admin-service:3030']
    metrics_path: '/metrics'

  - job_name: 'postgres-exporter'
    static_configs:
      - targets: ['postgres-exporter:9187']

  - job_name: 'redis-exporter'
    static_configs:
      - targets: ['redis-exporter:9121']
```

### Grafana Dashboard Configuration

```json
{
  "dashboard": {
    "title": "Uber Clone Monitoring",
    "panels": [
      {
        "title": "Active Rides",
        "type": "graph",
        "targets": [
          {
            "expr": "uber_active_rides_total",
            "legendFormat": "Active Rides"
          }
        ]
      },
      {
        "title": "API Response Times",
        "type": "graph",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le))",
            "legendFormat": "95th Percentile"
          }
        ]
      },
      {
        "title": "Database Connections",
        "type": "stat",
        "targets": [
          {
            "expr": "pg_stat_database_numbackends{datname=~\"uber_clone_.*\"}",
            "legendFormat": "{{datname}}"
          }
        ]
      }
    ]
  }
}
```

### Centralized Logging with ELK Stack

```yaml
# docker-compose.logging.yml

version: '3.8'

services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.17.0
    environment:
      - discovery.type=single-node
      - ES_JAVA_OPTS=-Xms1g -Xmx1g
    volumes:
      - es_data:/usr/share/elasticsearch/data
    ports:
      - "9200:9200"
      - "9300:9300"

  kibana:
    image: docker.elastic.co/kibana/kibana:7.17.0
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch

  logstash:
    image: docker.elastic.co/logstash/logstash:7.17.0
    volumes:
      - ./logstash/pipeline:/usr/share/logstash/pipeline
    ports:
      - "5044:5044"
    depends_on:
      - elasticsearch

volumes:
  es_data:
```

## 🔄 Backup and Recovery

### Automated Backup Script

```bash
#!/bin/bash
# automated_backup.sh

# Configuration
BACKUP_DIR="/backups"
S3_BUCKET="s3://your-company-backups/uber-clone"
RETENTION_DAYS=30
LOG_FILE="/var/log/backup.log"

# Timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Function to log messages
log_message() {
    echo "$(date): $1" >> $LOG_FILE
}

# Create backup directories
mkdir -p $BACKUP_DIR/database/$TIMESTAMP
mkdir -p $BACKUP_DIR/uploads/$TIMESTAMP

log_message "Starting backup process"

# Database backup
log_message "Backing up databases"
pg_dump -h $DB_HOST -U $DB_USER -d uber_clone_rider > $BACKUP_DIR/database/$TIMESTAMP/rider.sql
pg_dump -h $DB_HOST -U $DB_USER -d uber_clone_driver > $BACKUP_DIR/database/$TIMESTAMP/driver.sql
pg_dump -h $DB_HOST -U $DB_USER -d uber_clone_admin > $BACKUP_DIR/database/$TIMESTAMP/admin.sql

# Compress database backups
gzip $BACKUP_DIR/database/$TIMESTAMP/*.sql

# Backup uploaded files
log_message "Backing up uploaded files"
tar -czf $BACKUP_DIR/uploads/$TIMESTAMP/uploads.tar.gz /var/www/uploads

# Upload to cloud storage
log_message "Uploading backups to S3"
aws s3 sync $BACKUP_DIR s3://your-backup-bucket/uber-clone/backups/

# Cleanup old backups
log_message "Cleaning up old backups"
find $BACKUP_DIR -name "*" -type f -mtime +$RETENTION_DAYS -delete

# Verify backup integrity
log_message "Verifying backup integrity"
# Add verification logic here

log_message "Backup process completed"
```

### Disaster Recovery Plan

1. **Immediate Response (0-30 minutes)**
   - Assess impact and notify stakeholders
   - Activate backup systems if available
   - Begin investigation of root cause

2. **Short-term Recovery (1-4 hours)**
   - Restore from most recent backup
   - Verify data integrity
   - Bring services back online gradually

3. **Long-term Recovery (4+ hours)**
   - Implement permanent fixes
   - Conduct post-mortem analysis
   - Update disaster recovery procedures

## 📈 Scaling and Performance

### Horizontal Scaling

**Load Balancer Configuration:**
```nginx
upstream rider_backend_pool {
    least_conn;
    server rider-service-1:3010 weight=3;
    server rider-service-2:3010 weight=3;
    server rider-service-3:3010 weight=2;
    server rider-service-backup:3010 backup;
}
```

**Auto-scaling Configuration:**
```yaml
# docker-compose.autoscale.yml

services:
  rider-service:
    # ... existing configuration
    deploy:
      mode: replicated
      replicas: 3
      placement:
        constraints:
          - node.role == worker
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
      rollback_config:
        parallelism: 1
        delay: 10s
      update_config:
        parallelism: 1
        delay: 10s
        failure_action: rollback
```

### Caching Strategy

**Redis Cache Configuration:**
```javascript
// cacheConfig.js

const redis = require('redis');

const client = redis.createClient({
    host: process.env.REDIS_HOST || 'localhost',
    port: process.env.REDIS_PORT || 6379,
    retry_strategy: (options) => {
        if (options.error && options.error.code === 'ECONNREFUSED') {
            return new Error('Redis server refused connection');
        }
        if (options.total_retry_time > 1000 * 60 * 60) {
            return new Error('Retry time exhausted');
        }
        if (options.attempt > 10) {
            return undefined;
        }
        return Math.min(options.attempt * 100, 3000);
    }
});

// Cache middleware
const cacheMiddleware = (duration) => {
    return (req, res, next) => {
        if (req.method !== 'GET') {
            return next();
        }

        const key = '__express__' + req.originalUrl || req.url;
        
        client.get(key, (err, cachedResponse) => {
            if (err) throw err;
            
            if (cachedResponse) {
                return res.json(JSON.parse(cachedResponse));
            } else {
                res.sendResponse = res.json;
                res.json = (body) => {
                    client.setex(key, duration, JSON.stringify(body));
                    res.sendResponse(body);
                };
                next();
            }
        });
    };
};

module.exports = { client, cacheMiddleware };
```

## 🔐 Security Considerations

### Network Security

**Firewall Configuration:**
```bash
# UFW Firewall Rules
ufw default deny incoming
ufw default allow outgoing

# SSH Access
ufw allow ssh

# HTTP/HTTPS
ufw allow 80/tcp
ufw allow 443/tcp

# Backend Services (internal only)
ufw allow from 10.0.0.0/8 to any port 3010
ufw allow from 10.0.0.0/8 to any port 3020
ufw allow from 10.0.0.0/8 to any port 3030

# Database (internal only)
ufw allow from 10.0.0.0/8 to any port 5432

# Enable firewall
ufw enable
```

### Application Security

**Rate Limiting Configuration:**
```javascript
// rateLimiter.js

const rateLimit = require('express-rate-limit');

const apiLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100, // limit each IP to 100 requests per windowMs
    message: {
        success: false,
        message: 'Too many requests from this IP, please try again later.'
    },
    standardHeaders: true,
    legacyHeaders: false,
});

const authLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 5, // limit each IP to 5 requests per windowMs
    message: {
        success: false,
        message: 'Too many authentication attempts, please try again later.'
    }
});

module.exports = { apiLimiter, authLimiter };
```

**Security Headers:**
```javascript
// securityHeaders.js

const helmet = require('helmet');

const securityHeaders = helmet({
    contentSecurityPolicy: {
        directives: {
            defaultSrc: ["'self'"],
            styleSrc: ["'self'", "'unsafe-inline'"],
            imgSrc: ["'self'", "data:", "https:"],
            scriptSrc: ["'self'"],
            connectSrc: ["'self'", "ws:", "wss:"],
        },
    },
    dnsPrefetchControl: {
        allow: false
    },
    frameguard: {
        action: 'deny'
    },
    hidePoweredBy: true,
    hsts: {
        maxAge: 31536000,
        includeSubDomains: true,
        preload: true
    },
    ieNoOpen: true,
    noSniff: true,
    referrerPolicy: {
        policy: 'strict-origin-when-cross-origin'
    },
    xssFilter: true
});

module.exports = securityHeaders;
```

---

*This deployment guide provides a comprehensive framework for deploying the Uber Clone application across different environments. Always test deployment procedures in a staging environment before applying to production.*