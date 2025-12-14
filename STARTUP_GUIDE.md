# Startup Guide - Uber Clone Project

This guide explains how to set up and run the clean, organized Uber Clone project.

## Project Structure Overview

```
uberkimi02/
├── flutter-apps/           # Flutter applications
│   ├── rider_app/          # Rider application
│   ├── driver_app/         # Driver application
│   └── admin_app/          # Admin application
├── flutter-packages/       # Shared Flutter packages
│   └── uber_shared/        # Shared components and utilities
├── backend-services/       # Backend microservices
│   ├── rider-service/      # Rider backend service
│   ├── driver-service/     # Driver backend service
│   └── admin-service/      # Admin backend service
├── init-scripts/           # Setup and initialization scripts
├── COMPREHENSIVE_IMPLEMENTATION_PLAN.md
├── DETAILED_TODO_LIST.md
├── PROJECT_STRUCTURE.md
├── README.md
└── run_all_services.sh
```

## Prerequisites

Before starting, ensure you have the following installed:

1. **Flutter SDK 3.10.4+**
2. **Dart 3.0.0+**
3. **Node.js 16+**
4. **PostgreSQL 13+**
5. **Git**

## Initial Setup

### 1. Clone and Navigate

```bash
# If starting fresh, create new directory
mkdir uber-clone-clean && cd uber-clone-clean

# Or if using existing structure
cd /media/fi/NewVolume/project01/UberKimi01/uberkimi02
```

### 2. Database Setup

```bash
# Start PostgreSQL service
sudo service postgresql start

# Create database and user
sudo -u postgres psql
CREATE DATABASE uber_clone;
CREATE USER uber_user WITH PASSWORD 'uber_password';
GRANT ALL PRIVILEGES ON DATABASE uber_clone TO uber_user;
\q
```

### 3. Environment Configuration

Create `.env` files in each service directory:

**backend-services/rider-service/.env**
```
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=uber_clone
DB_USER=uber_user
DB_PASSWORD=uber_password

# JWT Configuration
JWT_SECRET=uber_clone_secret_key_for_development_only
JWT_EXPIRES_IN=24h

# Server Configuration
PORT=3001
NODE_ENV=development

# Map Configuration
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
MAPBOX_ACCESS_TOKEN=your_mapbox_access_token
```

Repeat similar configuration for `driver-service` (PORT=3002) and `admin-service` (PORT=3003).

## Backend Services Setup

### 1. Install Dependencies

```bash
# Rider Service
cd backend-services/rider-service
npm install

# Driver Service
cd ../driver-service
npm install

# Admin Service
cd ../admin-service
npm install
```

### 2. Database Migration

Each service should have its own migration setup. Run migrations for each:

```bash
# In each service directory
npm run migrate
# or
node migrate.js
```

### 3. Start Services

Option 1: Manual start (recommended for development)
```bash
# Terminal 1 - Rider Service
cd backend-services/rider-service
npm start

# Terminal 2 - Driver Service
cd backend-services/driver-service
npm start

# Terminal 3 - Admin Service
cd backend-services/admin-service
npm start
```

Option 2: Automated start
```bash
# Make script executable
chmod +x run_all_services.sh

# Run all services
./run_all_services.sh
```

## Frontend Applications Setup

### 1. Install Flutter Dependencies

```bash
# Rider App
cd flutter-apps/rider_app
flutter pub get

# Driver App
cd ../driver_app
flutter pub get

# Admin App
cd ../admin_app
flutter pub get
```

### 2. Configure Environment Variables

Each Flutter app uses environment variables for API configuration. These are typically set in:
- `lib/config/environment.dart`

### 3. Run Applications

```bash
# Rider App
cd flutter-apps/rider_app
flutter run -d chrome --web-port 3010

# Driver App
cd ../driver_app
flutter run -d chrome --web-port 3011

# Admin App
cd ../admin_app
flutter run -d chrome --web-port 3012
```

## Development Workflow

### Code Organization Principles

1. **Separation of Concerns**: Each app/service has a single responsibility
2. **Shared Components**: Common functionality goes in `uber_shared`
3. **Consistent Naming**: Follow established patterns
4. **Environment Configuration**: Use `.env` files for configuration
5. **Neomorphic Design**: Maintain consistent UI style

### Adding New Features

1. **Identify Scope**: Determine which app/service needs changes
2. **Check Shared Components**: See if functionality can be shared
3. **Implement Feature**: Follow existing patterns
4. **Test Thoroughly**: Ensure compatibility across apps
5. **Document Changes**: Update relevant documentation

### Testing Strategy

1. **Unit Tests**: Test individual components and functions
2. **Integration Tests**: Test API endpoints and database interactions
3. **End-to-End Tests**: Test complete user workflows
4. **UI Tests**: Test interface behavior and appearance

## Troubleshooting Common Issues

### Port Conflicts
```bash
# Check what's using ports
lsof -i :3001,3002,3003,3010,3011,3012

# Kill conflicting processes
pkill -f "node.*3001"
pkill -f "flutter.*3010"
```

### Database Connection Issues
```bash
# Check PostgreSQL status
sudo service postgresql status

# Restart if needed
sudo service postgresql restart

# Test connection
psql -h localhost -U uber_user -d uber_clone
```

### Flutter Build Issues
```bash
# Clean build artifacts
flutter clean

# Get dependencies
flutter pub get

# Upgrade packages if needed
flutter pub upgrade
```

### Dependency Resolution Problems
```bash
# In Node.js services
npm install --legacy-peer-deps

# In Flutter apps
flutter pub cache repair
```

## Neomorphic UI Guidelines

### Design Principles
1. **Soft Shadows**: Use subtle inner and outer shadows
2. **Gradient Backgrounds**: Apply gentle color transitions
3. **Rounded Corners**: Maintain consistent border radius
4. **Hover Effects**: Add smooth transitions on interaction
5. **Depth Perception**: Create 3D-like appearance

### Component Examples

**Neomorphic Button**
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.white, Colors.grey.shade300],
    ),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        offset: Offset(4, 4),
        blurRadius: 8,
      ),
      BoxShadow(
        color: Colors.white.withOpacity(0.8),
        offset: Offset(-4, -4),
        blurRadius: 8,
      ),
    ],
  ),
  child: // Button content
)
```

**Neomorphic Card**
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.grey.shade200,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3),
        offset: Offset(6, 6),
        blurRadius: 12,
      ),
      BoxShadow(
        color: Colors.white.withOpacity(0.5),
        offset: Offset(-6, -6),
        blurRadius: 12,
      ),
    ],
  ),
  child: // Card content
)
```

## Best Practices

### Code Quality
1. **Consistent Formatting**: Use established style guides
2. **Meaningful Names**: Use descriptive variable and function names
3. **Comments**: Document complex logic
4. **Modularity**: Keep functions and components small
5. **Error Handling**: Implement proper error management

### Performance
1. **Lazy Loading**: Load components only when needed
2. **Caching**: Cache frequently accessed data
3. **Optimization**: Profile and optimize bottlenecks
4. **Memory Management**: Clean up unused resources
5. **Network Efficiency**: Minimize API calls

### Security
1. **Input Validation**: Sanitize all user inputs
2. **Authentication**: Implement proper auth flows
3. **Authorization**: Check permissions for all actions
4. **Data Protection**: Encrypt sensitive information
5. **Rate Limiting**: Prevent abuse

This startup guide provides everything needed to begin working with the clean, organized Uber Clone project structure while maintaining the beautiful neomorphic design aesthetic.