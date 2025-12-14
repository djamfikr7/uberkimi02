# GitHub Repository Setup Guide - Uber Clone Project

This document provides step-by-step instructions for creating a new GitHub repository and setting up the main branch with the Uber Clone project structure.

## Prerequisites

Before proceeding, ensure you have:

1. **Git** installed on your local machine
2. **GitHub account** with appropriate permissions
3. **SSH keys** configured for GitHub (recommended) or HTTPS credentials
4. **Flutter SDK 3.10.4+** and **Dart 3.0.0+** installed
5. **Node.js 16+** installed
6. **PostgreSQL 13+** installed

## Step 1: Create New GitHub Repository

### Option A: Using GitHub Web Interface

1. Navigate to [GitHub](https://github.com) and log in to your account
2. Click the "+" icon in the top-right corner and select "New repository"
3. Fill in the repository details:
   - **Repository name**: `uber-clone` (or your preferred name)
   - **Description**: "A comprehensive ride-sharing platform with three distinct applications built using modern technologies and beautiful neomorphic UI design"
   - **Visibility**: Public (or Private if preferred)
   - **Initialize this repository with**: Leave unchecked
4. Click "Create repository"

### Option B: Using GitHub CLI

If you have GitHub CLI installed:

```bash
gh repo create uber-clone --public --clone
```

For a private repository:
```bash
gh repo create uber-clone --private --clone
```

## Step 2: Set Up Local Repository Structure

### Clone the Repository (if not already cloned)

```bash
git clone git@github.com:your-username/uber-clone.git
cd uber-clone
```

### Create the Repository Structure

Run the structure creation script we created earlier:

```bash
# Make sure the script is executable
chmod +x /media/fi/NewVolume/project01/UberKimi01/uberkimi02/scripts/create-repo-structure.sh

# Copy the script to your new repository
cp /media/fi/NewVolume/project01/UberKimi01/uberkimi02/scripts/create-repo-structure.sh .

# Run the script
./create-repo-structure.sh
```

Alternatively, manually create the structure:

```bash
# Create main directories
mkdir -p documentation/API_DOCS
mkdir -p flutter-apps/rider_app flutter-apps/driver_app flutter-apps/admin_app
mkdir -p flutter-packages/uber_shared
mkdir -p backend-services/rider-service/src/{controllers,middleware,models,routes,services,utils,config}
mkdir -p backend-services/driver-service/src/{controllers,middleware,models,routes,services,utils,config}
mkdir -p backend-services/admin-service/src/{controllers,middleware,models,routes,services,utils,config}
mkdir -p scripts
mkdir -p .github/workflows
mkdir -p .vscode
```

## Step 3: Add Essential Files

### Copy Documentation Files

Copy all the documentation files we've created:

```bash
cp /media/fi/NewVolume/project01/UberKimi01/uberkimi02/documentation/* documentation/
cp /media/fi/NewVolume/project01/UberKimi01/uberkimi02/NEW_REPOSITORY_SETUP.md .
cp /media/fi/NewVolume/project01/UberKimi01/uberkimi02/WALKTHROUGH.md documentation/
cp /media/fi/NewVolume/project01/UberKimi01/uberkimi02/TODO_TASKLIST.md documentation/
cp /media/fi/NewVolume/project01/UberKimi01/uberkimi02/documentation/ARCHITECTURE.md documentation/
```

### Copy Script Files

```bash
cp -r /media/fi/NewVolume/project01/UberKimi01/uberkimi02/scripts/* scripts/
```

## Step 4: Initialize Git Repository

### Add All Files to Git

```bash
# Add all files
git add .

# Make initial commit
git commit -m "Initial commit: Project structure and setup scripts

- Added complete repository structure
- Included comprehensive documentation
- Added setup and automation scripts
- Configured VS Code settings
- Added .gitignore for all technologies"
```

### Push to GitHub

```bash
# Add the remote origin (if not already done)
git remote add origin git@github.com:your-username/uber-clone.git

# Push to main branch
git branch -M main
git push -u origin main
```

## Step 5: Verify Repository Setup

### Check Remote Repository

1. Navigate to your GitHub repository URL
2. Verify that all files and directories are present
3. Check that the commit history shows the initial commit

### Verify Branch Protection (Optional)

For a production repository, consider setting up branch protection:

1. Go to your repository settings
2. Navigate to "Branches" section
3. Add branch protection rule for `main` branch
4. Enable required reviews and status checks

## Step 6: Set Up GitHub Features

### Create README.md

If you haven't already, create a comprehensive README:

```bash
cp /media/fi/NewVolume/project01/UberKimi01/uberkimi02/README.md .
git add README.md
git commit -m "Add comprehensive README.md"
git push
```

### Set Up GitHub Issues Templates

Create `.github/ISSUE_TEMPLATE` directory:

```bash
mkdir -p .github/ISSUE_TEMPLATE
```

Create bug report template:

```yaml
# .github/ISSUE_TEMPLATE/bug_report.md
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
```

Create feature request template:

```yaml
# .github/ISSUE_TEMPLATE/feature_request.md
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
```

### Set Up Pull Request Template

Create `.github/pull_request_template.md`:

```markdown
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
```

Commit these templates:

```bash
git add .github/
git commit -m "Add GitHub issue and pull request templates"
git push
```

## Step 7: Set Up CI/CD (Optional)

Create a basic GitHub Actions workflow:

```yaml
# .github/workflows/flutter-test.yml
name: Flutter Test

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.10.4'
        
    - name: Install dependencies
      run: |
        cd flutter-apps/rider_app
        flutter pub get
        
    - name: Run tests
      run: |
        cd flutter-apps/rider_app
        flutter test
```

```bash
git add .github/workflows/
git commit -m "Add basic CI workflow for Flutter tests"
git push
```

## Repository Management Best Practices

### 1. Branching Strategy

Recommended branching strategy:
- `main`: Production-ready code
- `develop`: Development branch
- `feature/*`: Feature branches
- `hotfix/*`: Bug fixes for production
- `release/*`: Release preparation

### 2. Commit Message Convention

Use conventional commits:
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

### 3. Tagging Releases

Tag releases with semantic versioning:
```bash
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

### 4. Repository Maintenance

Regular maintenance tasks:
- Keep dependencies updated
- Review and merge pull requests promptly
- Monitor CI/CD pipeline
- Update documentation with changes
- Archive stale branches

## Next Steps

After setting up the repository:

1. **Assign Team Members**: Add collaborators with appropriate permissions
2. **Set Up Project Board**: Create GitHub Projects for task tracking
3. **Configure Webhooks**: Set up notifications for team members
4. **Establish Code Review Process**: Define review requirements
5. **Set Up Monitoring**: Configure alerts for CI/CD failures

## Troubleshooting

### Common Issues

1. **Permission Denied**: Ensure SSH keys are configured or use HTTPS with credentials
2. **Remote Origin Already Exists**: Use `git remote set-url origin [new-url]`
3. **Large Files**: Consider using Git LFS for large binary files
4. **Slow Clones**: Check network connectivity and GitHub status

### Useful Git Commands

```bash
# Check remote URL
git remote -v

# Change remote URL
git remote set-url origin new-url

# Force push (use with caution)
git push --force-with-lease origin main

# Sync with remote
git fetch origin
git reset --hard origin/main
```

This guide provides a complete process for setting up your Uber Clone project on GitHub with all the structure and best practices we've discussed.