#!/bin/bash

# Script to create the Uber Clone repository structure
# Run this script from the root directory where you want to create the project

echo "🚀 Creating Uber Clone Repository Structure..."

# Check if we're in the right directory
if [ ! -f "NEW_REPOSITORY_SETUP.md" ]; then
    echo "⚠️  Warning: This script should be run from the project root directory"
    echo "Creating structure in current directory: $(pwd)"
    echo "Continue? (y/n)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "❌ Aborted"
        exit 1
    fi
fi

# Create main directories
echo "📁 Creating main directories..."
mkdir -p documentation/API_DOCS
mkdir -p flutter-apps/rider_app flutter-apps/driver_app flutter-apps/admin_app
mkdir -p flutter-packages/uber_shared
mkdir -p backend-services/rider-service/src/{controllers,middleware,models,routes,services,utils,config}
mkdir -p backend-services/driver-service/src/{controllers,middleware,models,routes,services,utils,config}
mkdir -p backend-services/admin-service/src/{controllers,middleware,models,routes,services,utils,config}
mkdir -p scripts
mkdir -p .github/workflows
mkdir -p .vscode

# Create essential files
echo "📄 Creating essential configuration files..."

# Create .gitignore
cat > .gitignore << 'EOF'
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
EOF

# Create main README.md
cat > README.md << 'EOF'
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
EOF

# Create VS Code configuration
cat > .vscode/settings.json << 'EOF'
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
EOF

cat > .vscode/extensions.json << 'EOF'
{
    "recommendations": [
        "dart-code.dart-code",
        "dart-code.flutter",
        "ms-vscode.vscode-typescript-next",
        "ms-azuretools.vscode-docker"
    ]
}
EOF

# Make scripts executable
chmod +x scripts/*.sh 2>/dev/null || echo "No existing scripts to make executable"

echo "✅ Repository structure created successfully!"
echo ""
echo "Next steps:"
echo "1. Copy your documentation files to the documentation/ directory"
echo "2. Set up your Flutter apps in flutter-apps/"
echo "3. Set up your backend services in backend-services/"
echo "4. Run 'scripts/setup.sh' to install dependencies"
echo ""
echo "For detailed instructions, see NEW_REPOSITORY_SETUP.md"