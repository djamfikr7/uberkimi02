#!/bin/bash

# Script to initialize GitHub repository with Uber Clone project structure
# This script assumes you have GitHub CLI installed and authenticated

echo "🚀 Initializing GitHub Repository for Uber Clone Project..."

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI is not installed. Please install it first:"
    echo "   macOS: brew install gh"
    echo "   Windows: winget install GitHub.cli"
    echo "   Linux: Visit https://cli.github.com/manual/installation"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Not authenticated with GitHub. Please authenticate first:"
    echo "   gh auth login"
    exit 1
fi

# Get repository name
echo "📝 Enter repository name (default: uber-clone):"
read -r REPO_NAME
REPO_NAME=${REPO_NAME:-uber-clone}

# Get repository visibility
echo "👁️  Select repository visibility:"
echo "1) Public (default)"
echo "2) Private"
read -r VISIBILITY_CHOICE
VISIBILITY_CHOICE=${VISIBILITY_CHOICE:-1}

case $VISIBILITY_CHOICE in
    2)
        VISIBILITY="--private"
        ;;
    *)
        VISIBILITY="--public"
        ;;
esac

# Create repository
echo "🏗️  Creating repository $REPO_NAME..."
gh repo create "$REPO_NAME" $VISIBILITY --clone

if [ $? -ne 0 ]; then
    echo "❌ Failed to create repository"
    exit 1
fi

# Navigate to repository directory
cd "$REPO_NAME" || exit 1

# Create repository structure
echo "📁 Creating repository structure..."
mkdir -p documentation/API_DOCS
mkdir -p flutter-apps/rider_app flutter-apps/driver_app flutter-apps/admin_app
mkdir -p flutter-packages/uber_shared
mkdir -p backend-services/rider-service/src/{controllers,middleware,models,routes,services,utils,config}
mkdir -p backend-services/driver-service/src/{controllers,middleware,models,routes,services,utils,config}
mkdir -p backend-services/admin-service/src/{controllers,middleware,models,routes,services,utils,config}
mkdir -p scripts
mkdir -p .github/{workflows,ISSUE_TEMPLATE}
mkdir -p .vscode

# Create .gitignore
echo "📄 Creating .gitignore..."
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

# Create README.md
echo "📄 Creating README.md..."
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
echo "⚙️  Creating VS Code configuration..."
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

# Create issue templates
echo "📋 Creating issue templates..."
cat > .github/ISSUE_TEMPLATE/bug_report.md << 'EOF'
---
name: Bug report
about: Create a report to help us improve
title: ''
labels: bug
assignees: ''

---

**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Desktop (please complete the following information):**
 - OS: [e.g. iOS]
 - Browser [e.g. chrome, safari]
 - Version [e.g. 22]

**Smartphone (please complete the following information):**
 - Device: [e.g. iPhone6]
 - OS: [e.g. iOS8.1]
 - Browser [e.g. stock browser, safari]
 - Version [e.g. 22]

**Additional context**
Add any other context about the problem here.
EOF

cat > .github/ISSUE_TEMPLATE/feature_request.md << 'EOF'
---
name: Feature request
about: Suggest an idea for this project
title: ''
labels: enhancement
assignees: ''

---

**Is your feature request related to a problem? Please describe.**
A clear and concise description of what the problem is. Ex. I'm always frustrated when [...]

**Describe the solution you'd like**
A clear and concise description of what you want to happen.

**Describe alternatives you've considered**
A clear and concise description of any alternative solutions or features you've considered.

**Additional context**
Add any other context or screenshots about the feature request here.
EOF

# Create pull request template
echo "🔄 Creating pull request template..."
cat > .github/pull_request_template.md << 'EOF'
# Pull Request

## Description
Please include a summary of the change and which issue is fixed. Please also include relevant motivation and context.

Fixes # (issue)

## Type of change

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] This change requires a documentation update

## How Has This Been Tested?

Please describe the tests that you ran to verify your changes. Provide instructions so we can reproduce.

- [ ] Test A
- [ ] Test B

## Checklist:

- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
- [ ] Any dependent changes have been merged and published in downstream modules
EOF

# Create initial commit
echo "💾 Making initial commit..."
git add .
git commit -m "Initial commit: Project structure and setup scripts

- Added complete repository structure
- Included comprehensive documentation
- Added setup and automation scripts
- Configured VS Code settings
- Added .gitignore for all technologies
- Created issue and pull request templates"

# Push to GitHub
echo "☁️  Pushing to GitHub..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo "✅ Repository successfully initialized!"
    echo "🔗 Repository URL: https://github.com/$(gh auth status | grep 'Logged in to github.com' | cut -d' ' -f6)/$REPO_NAME"
else
    echo "❌ Failed to push to GitHub"
    exit 1
fi

echo ""
echo "🎉 Setup complete! Your GitHub repository is ready."
echo "Next steps:"
echo "1. Visit your repository at the URL above"
echo "2. Start adding documentation files to the documentation/ directory"
echo "3. Begin implementing the frontend apps in flutter-apps/"
echo "4. Set up the backend services in backend-services/"
echo "5. Run 'scripts/setup.sh' to install dependencies when ready"