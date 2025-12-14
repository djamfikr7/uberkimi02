# New Repository Setup Guide - Uber Clone Project

This document provides instructions for creating a clean, organized repository structure for the Uber Clone project that follows all requirements and best practices.

## Repository Structure Overview

```
uber-clone/
├── documentation/
│   ├── WALKTHROUGH.md              # Comprehensive project walkthrough
│   ├── TODO_TASKLIST.md            # Detailed task list
│   ├── ARCHITECTURE.md             # System architecture documentation
│   ├── API_DOCS/                   # API documentation
│   │   ├── rider-api.yaml
│   │   ├── driver-api.yaml
│   │   └── admin-api.yaml
│   └── STYLE_GUIDE.md              # UI/UX design guidelines
├── flutter-apps/
│   ├── rider_app/                  # Rider Flutter application
│   │   ├── lib/
│   │   │   ├── config/             # Environment configuration
│   │   │   ├── models/             # Data models
│   │   │   ├── screens/            # UI screens
│   │   │   ├── services/           # API services
│   │   │   ├── theme/              # UI theme and styling
│   │   │   └── widgets/            # Custom UI components
│   │   ├── test/                   # Unit and widget tests
│   │   ├── integration_test/       # Integration tests
│   │   ├── pubspec.yaml            # Dependencies
│   │   ├── README.md               # App-specific documentation
│   │   └── analysis_options.yaml   # Linting rules
│   ├── driver_app/                 # Driver Flutter application
│   └── admin_app/                  # Admin Flutter application
├── flutter-packages/
│   └── uber_shared/                # Shared components and utilities
│       ├── lib/
│       │   ├── models/             # Shared data models
│       │   ├── widgets/            # Shared UI components
│       │   ├── utils/              # Shared utility functions
│       │   └── theme/              # Shared theme definitions
│       ├── test/                   # Shared package tests
│       ├── pubspec.yaml            # Dependencies
│       └── README.md               # Package documentation
├── backend-services/
│   ├── rider-service/              # Rider backend microservice
│   │   ├── src/
│   │   │   ├── controllers/        # Request handlers
│   │   │   ├── middleware/         # Authentication/validation
│   │   │   ├── models/             # Database models
│   │   │   ├── routes/             # API endpoints
│   │   │   ├── services/           # Business logic
│   │   │   ├── utils/              # Utilities
│   │   │   └── config/             # Configuration files
│   │   ├── tests/                  # Service tests
│   │   ├── .env.example            # Environment variable template
│   │   ├── server.js               # Entry point
│   │   ├── package.json            # Dependencies
│   │   ├── README.md               # Service documentation
│   │   └── Dockerfile              # Containerization (future)
│   ├── driver-service/             # Driver backend microservice
│   └── admin-service/              # Admin backend microservice
├── scripts/
│   ├── setup.sh                    # Initial setup script
│   ├── run-all-services.sh         # Start all backend services
│   ├── run-all-apps.sh             # Start all Flutter apps
│   └── deploy.sh                   # Deployment script (future)
├── .github/
│   └── workflows/                  # CI/CD pipelines (future)
├── .vscode/                        # VS Code configuration
│   ├── settings.json
│   └── extensions.json
├── .gitignore                      # Git ignore rules
├── README.md                       # Main project documentation
├── LICENSE                         # License information
└── CHANGELOG.md                    # Version history

## Setting Up the New Repository

### 1. Create the Root Directory

```bash
mkdir uber-clone
cd uber-clone
git init
```

### 2. Create the Basic Directory Structure

```bash
# Create main directories
mkdir documentation flutter-apps flutter-packages backend-services scripts

# Create documentation subdirectories
mkdir documentation/API_DOCS

# Create app directories
mkdir flutter-apps/rider_app flutter-apps/driver_app flutter-apps/admin_app

# Create package directory
mkdir flutter-packages/uber_shared

# Create service directories
mkdir backend-services/rider-service backend-services/driver-service backend-services/admin-service

# Create scripts directory
mkdir scripts

# Create VS Code configuration directory
mkdir .vscode

# Create GitHub workflows directory
mkdir -p .github/workflows
```

### 3. Create Essential Configuration Files

#### .gitignore
```gitignore
# Flutter/Dart/Pub
*.mode1v3
*.mode2v3
*.moved-aside
*.perm
*.properties
*.pydevproject
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
build/
flutter_*.png
linked_*.ds
unlinked.ds
unlinked_spec.ds

# Android related
**/android/**/gradle-wrapper.jar
**/android/.gradle
**/android/captures/
**/android/gradlew
**/android/gradlew.bat
**/android/local.properties
**/android/**/GeneratedPluginRegistrant.java

# iOS/XCode related
**/ios/**/*.mode1v3
**/ios/**/*.mode2v3
**/ios/**/*.moved-aside
**/ios/**/*.pbxuser
**/ios/**/*.perspectivev3
**/ios/**/*sync/
**/ios/**/.sconsign.dblite
**/ios/**/.tags*
**/ios/**/.vagrant/
**/ios/**/DerivedData/
**/ios/**/Icon?
**/ios/**/Pods/
**/ios/**/.symlinks/
**/ios/**/profile
**/ios/**/xcuserdata
**/ios/.generated/
**/ios/Flutter/App.framework
**/ios/Flutter/Flutter.framework
**/ios/Flutter/Flutter.podspec
**/ios/Flutter/Generated.xcconfig
**/ios/Flutter/app.flx
**/ios/Flutter/app.zip
**/ios/Flutter/flutter_assets/
**/ios/Flutter/flutter_export_environment.sh
**/ios/ServiceDefinitions.json
**/ios/Runner/GeneratedPluginRegistrant.*

# Exceptions to ignore rules
!**/ios/**/default.mode1v3
!**/ios/**/default.mode2v3
!**/ios/**/default.pbxuser
!**/ios/**/default.perspectivev3
!/packages/flutter_tools/test/data/dart_dependencies_test/**/.packages

# Node.js
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Docker
.dockerignore
docker-compose.override.yml

# IDE
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json
*.swp
*.swo
```

#### README.md
```markdown
# Uber Clone Project

A comprehensive ride-sharing platform with three distinct applications built using modern technologies and beautiful neomorphic UI design.

## Project Overview

This project implements a ride-sharing platform with three separated applications:
- **Rider App**: Request rides, track drivers, make payments
- **Driver App**: Accept ride requests, navigate routes, earn money
- **Admin App**: Monitor system, manage users, oversee operations

## Technology Stack

### Frontend
- Flutter 3.10.4+ with Dart 3.0.0+
- Provider for state management
- Socket.IO client for real-time communication
- Flutter Map for mapping

### Backend
- Node.js with Express.js microservices
- PostgreSQL for database storage
- Socket.IO server for real-time communication
- JWT for authentication

## Getting Started

### Prerequisites
- Flutter SDK 3.10.4+
- Dart 3.0.0+
- Node.js 16+
- PostgreSQL 13+

### Setup Instructions
See [documentation/WALKTHROUGH.md](documentation/WALKTHROUGH.md) for detailed setup instructions.

## Documentation
- [Walkthrough Guide](documentation/WALKTHROUGH.md)
- [TODO Task List](documentation/TODO_TASKLIST.md)
- [Architecture Documentation](documentation/ARCHITECTURE.md)

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## License
See [LICENSE](LICENSE) for license information.
```

### 4. Create VS Code Configuration

#### .vscode/settings.json
```json
{
    "dart.flutterSdkPath": "/path/to/flutter/sdk",
    "dart.pubAdditionalArgs": ["--no-example"],
    "editor.formatOnSave": true,
    "dart.lineLength": 100,
    "files.exclude": {
        "**/*.dart_tool": true,
        "**/*.pub": true,
        "**/build": true
    }
}
```

#### .vscode/extensions.json
```json
{
    "recommendations": [
        "dart-code.dart-code",
        "dart-code.flutter",
        "ms-vscode.vscode-typescript-next",
        "ms-azuretools.vscode-docker"
    ]
}
```

### 5. Create Initial Script Files

#### scripts/setup.sh
```bash
#!/bin/bash

echo "🚀 Setting up Uber Clone Project..."

# Install Flutter dependencies
echo "📦 Installing Flutter dependencies..."
cd flutter-apps/rider_app && flutter pub get
cd ../driver_app && flutter pub get
cd ../admin_app && flutter pub get
cd ../..

# Install backend dependencies
echo "🔧 Installing backend dependencies..."
cd backend-services/rider-service && npm install
cd ../driver-service && npm install
cd ../admin-service && npm install
cd ../..

echo "✅ Setup complete! Run 'scripts/run-all-services.sh' to start backend services."
```

#### scripts/run-all-services.sh
```bash
#!/bin/bash

echo "🚀 Starting all backend services..."

# Start rider service
echo "🚕 Starting Rider Service on port 3001..."
cd backend-services/rider-service
npm start > /tmp/rider-service.log 2>&1 &
RIDER_PID=$!
cd ../..

# Start driver service
echo "🚗 Starting Driver Service on port 3002..."
cd backend-services/driver-service
npm start > /tmp/driver-service.log 2>&1 &
DRIVER_PID=$!
cd ../..

# Start admin service
echo "👨‍💼 Starting Admin Service on port 3003..."
cd backend-services/admin-service
npm start > /tmp/admin-service.log 2>&1 &
ADMIN_PID=$!
cd ../..

echo "⏱ Waiting for services to start..."
sleep 5

# Check if services are running
if lsof -i :3001 >/dev/null; then
  echo "✅ Rider Service is running on port 3001"
else
  echo "❌ Rider Service failed to start"
  cat /tmp/rider-service.log
fi

if lsof -i :3002 >/dev/null; then
  echo "✅ Driver Service is running on port 3002"
else
  echo "❌ Driver Service failed to start"
  cat /tmp/driver-service.log
fi

if lsof -i :3003 >/dev/null; then
  echo "✅ Admin Service is running on port 3003"
else
  echo "❌ Admin Service failed to start"
  cat /tmp/admin-service.log
fi

echo ""
echo "🔧 To start Flutter apps, run 'scripts/run-all-apps.sh'"
echo "🛑 Press Ctrl+C to stop backend services"

# Wait for user to stop services
wait $RIDER_PID $DRIVER_PID $ADMIN_PID
```

#### scripts/run-all-apps.sh
```bash
#!/bin/bash

echo "🚀 Starting all Flutter apps..."

# Start rider app
echo "🚕 Starting Rider App on port 3010..."
cd flutter-apps/rider_app
nohup flutter run -d chrome --web-port 3010 > /tmp/rider-app.log 2>&1 &
RIDER_APP_PID=$!
cd ../..

# Start driver app
echo "🚗 Starting Driver App on port 3011..."
cd flutter-apps/driver_app
nohup flutter run -d chrome --web-port 3011 > /tmp/driver-app.log 2>&1 &
DRIVER_APP_PID=$!
cd ../..

# Start admin app
echo "👨‍💼 Starting Admin App on port 3012..."
cd flutter-apps/admin_app
nohup flutter run -d chrome --web-port 3012 > /tmp/admin-app.log 2>&1 &
ADMIN_APP_PID=$!
cd ../..

echo "⏱ Waiting for apps to start..."
sleep 10

# Check if apps are running
if netstat -tulpn | grep :3010 >/dev/null; then
  echo "✅ Rider App is running on port 3010"
else
  echo "❌ Rider App failed to start"
  cat /tmp/rider-app.log
fi

if netstat -tulpn | grep :3011 >/dev/null; then
  echo "✅ Driver App is running on port 3011"
else
  echo "❌ Driver App failed to start"
  cat /tmp/driver-app.log
fi

if netstat -tulpn | grep :3012 >/dev/null; then
  echo "✅ Admin App is running on port 3012"
else
  echo "❌ Admin App failed to start"
  cat /tmp/admin-app.log
fi

echo ""
echo "🌐 Apps are now accessible at:"
echo "   Rider App: http://localhost:3010"
echo "   Driver App: http://localhost:3011"
echo "   Admin App: http://localhost:3012"
echo "🛑 Press Ctrl+C to stop all apps"

# Wait for user to stop apps
wait $RIDER_APP_PID $DRIVER_APP_PID $ADMIN_APP_PID
```

### 6. Make Scripts Executable

```bash
chmod +x scripts/setup.sh
chmod +x scripts/run-all-services.sh
chmod +x scripts/run-all-apps.sh
```

### 7. Initialize Git Repository

```bash
git add .
git commit -m "Initial commit: Project structure and setup scripts"
```

## Repository Best Practices

### 1. Branching Strategy
- `main`: Production-ready code
- `develop`: Development branch
- `feature/*`: Feature branches
- `hotfix/*`: Bug fixes for production
- `release/*`: Release preparation

### 2. Commit Message Convention
```
<type>(<scope>): <subject>

<body>

<footer>
```

Types:
- feat: New feature
- fix: Bug fix
- docs: Documentation
- style: Code formatting
- refactor: Code refactoring
- test: Tests
- chore: Maintenance

### 3. File Naming Conventions
- Use kebab-case for file names
- Use PascalCase for class names
- Use camelCase for variables and functions
- Use UPPER_SNAKE_CASE for constants

### 4. Code Organization
- Separate concerns clearly
- Follow single responsibility principle
- Use meaningful names
- Document complex logic
- Keep functions small

## Environment Configuration

Each service and app should have its own `.env` file for configuration:

### Backend Services (.env)
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
PORT=3001  # 3002 for driver, 3003 for admin
NODE_ENV=development

# Map Configuration
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
MAPBOX_ACCESS_TOKEN=your_mapbox_access_token
```

### Flutter Apps (lib/config/environment.dart)
```dart
class Environment {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3001/api', // 3002 for driver, 3003 for admin
  );
  
  static const String socketBaseUrl = String.fromEnvironment(
    'SOCKET_BASE_URL',
    defaultValue: 'http://localhost:3001', // 3002 for driver, 3003 for admin
  );
  
  static const bool useMockData = bool.fromEnvironment(
    'USE_MOCK_DATA',
    defaultValue: false,
  );
}
```

This new repository structure provides a clean, organized foundation for the Uber Clone project that follows all the requirements and best practices we've discussed.