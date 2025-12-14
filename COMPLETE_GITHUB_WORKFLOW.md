# Complete GitHub Workflow Guide - Uber Clone Project

This document provides a comprehensive guide for setting up, authenticating, and managing your GitHub repository for the Uber Clone project, including automated workflows.

## Overview

This guide covers:
1. Initial repository setup
2. GitHub authentication
3. Automated workflows
4. Best practices for repository management

## Step 1: Initial Repository Setup

### Prerequisites
- Git installed
- GitHub account
- GitHub CLI (recommended)

### Create and Initialize Repository

Use the script we created earlier:

```bash
# Navigate to your project directory
cd /media/fi/NewVolume/project01/UberKimi01/uberkimi02

# Run the GitHub initialization script
./scripts/init-github-repo.sh
```

Follow the prompts to:
1. Enter repository name
2. Select visibility (public/private)
3. Automatically create and configure the repository

## Step 2: GitHub Authentication Setup

### Using GitHub CLI (Recommended)

1. **Install GitHub CLI** (if not already installed):
   ```bash
   # Ubuntu/Debian
   sudo apt install gh
   
   # macOS
   brew install gh
   ```

2. **Authenticate**:
   ```bash
   gh auth login
   ```
   
   Follow the prompts:
   - Choose GitHub.com
   - Select SSH protocol (recommended)
   - Authenticate via browser

3. **Verify Authentication**:
   ```bash
   gh auth status
   ```

### Alternative: SSH Keys

If you prefer SSH keys:

1. **Generate SSH Key**:
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```

2. **Add to SSH Agent**:
   ```bash
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_ed25519
   ```

3. **Add to GitHub**:
   - Copy public key: `cat ~/.ssh/id_ed25519.pub`
   - Add to GitHub Settings > SSH and GPG keys

4. **Test Connection**:
   ```bash
   ssh -T git@github.com
   ```

## Step 3: Repository Structure Setup

The initialization script automatically creates the following structure:

```
uber-clone/
├── documentation/
│   ├── WALKTHROUGH.md
│   ├── TODO_TASKLIST.md
│   ├── ARCHITECTURE.md
│   └── API_DOCS/
├── flutter-apps/
│   ├── rider_app/
│   ├── driver_app/
│   └── admin_app/
├── flutter-packages/
│   └── uber_shared/
├── backend-services/
│   ├── rider-service/
│   ├── driver-service/
│   └── admin-service/
├── scripts/
│   ├── setup.sh
│   ├── run-all-services.sh
│   ├── run-all-apps.sh
│   ├── create-repo-structure.sh
│   ├── init-github-repo.sh
│   └── auto-push.sh
├── .github/
│   ├── workflows/
│   └── ISSUE_TEMPLATE/
├── .vscode/
├── .gitignore
└── README.md
```

## Step 4: Automated Workflows

### Auto-Push Script

Use the auto-push script to easily commit and push changes:

```bash
# Make script executable (already done by init script)
chmod +x scripts/auto-push.sh

# Usage examples:
./scripts/auto-push.sh                    # Push to current branch with default message
./scripts/auto-push.sh main              # Push to main branch with default message
./scripts/auto-push.sh feature/new-ui "Implement new UI components"  # Custom branch and message
```

### Continuous Integration (Optional)

Create a basic CI workflow:

```bash
# Create workflow directory if it doesn't exist
mkdir -p .github/workflows

# Create a simple test workflow
cat > .github/workflows/test.yml << 'EOF'
name: Test Suite

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  flutter-test:
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
EOF
```

## Step 5: Daily Workflow

### Starting Your Work Session

1. **Navigate to project directory**:
   ```bash
   cd /path/to/uber-clone
   ```

2. **Pull latest changes**:
   ```bash
   git pull origin main
   ```

3. **Create feature branch** (recommended):
   ```bash
   git checkout -b feature/your-feature-name
   ```

### During Development

1. **Make your changes** to the codebase
2. **Test your changes** locally
3. **Stage your changes**:
   ```bash
   git add .
   ```

4. **Commit your changes**:
   ```bash
   git commit -m "Brief description of changes"
   ```

### Ending Your Work Session

1. **Push your changes**:
   ```bash
   # If on a feature branch
   git push origin feature/your-feature-name
   
   # Or use the auto-push script
   ./scripts/auto-push.sh
   ```

2. **Create Pull Request** (if using feature branches):
   ```bash
   gh pr create --title "Your PR Title" --body "Description of changes"
   ```

## Step 6: Repository Management Best Practices

### Branching Strategy

Recommended workflow:
- `main`: Production-ready code
- `develop`: Development branch
- `feature/*`: Feature branches
- `hotfix/*`: Bug fixes for production
- `release/*`: Release preparation

### Commit Message Guidelines

Use conventional commits:
```
<type>(<scope>): <subject>

<body>

<footer>
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code formatting
- `refactor`: Code refactoring
- `test`: Tests
- `chore`: Maintenance

### Code Review Process

1. Create pull requests for all changes
2. Assign reviewers
3. Address feedback
4. Merge after approval

## Step 7: Security Considerations

### Protecting Sensitive Information

1. **Never commit**:
   - API keys
   - Passwords
   - Database credentials
   - `.env` files

2. **Use environment variables**:
   ```bash
   # Example .env file (add to .gitignore)
   DB_PASSWORD=your_secure_password
   API_KEY=your_api_key
   ```

3. **GitHub Secrets** (for CI/CD):
   - Go to repository Settings > Secrets and variables > Actions
   - Add secrets for sensitive values

## Step 8: Troubleshooting Common Issues

### Authentication Problems

1. **Permission denied**:
   ```bash
   # Re-authenticate
   gh auth login
   
   # Or test SSH connection
   ssh -T git@github.com
   ```

2. **Wrong remote URL**:
   ```bash
   # Check current URL
   git remote -v
   
   # Update URL
   git remote set-url origin git@github.com:username/repo.git
   ```

### Merge Conflicts

1. **Pull latest changes**:
   ```bash
   git pull origin main
   ```

2. **Resolve conflicts** manually in files

3. **Stage resolved files**:
   ```bash
   git add resolved-file.txt
   ```

4. **Commit and push**:
   ```bash
   git commit -m "Resolve merge conflicts"
   git push
   ```

### Large Files

For large binary files, consider Git LFS:
```bash
# Install Git LFS
git lfs install

# Track specific file types
git lfs track "*.zip"
git add .gitattributes
```

## Useful Commands Reference

### Git Basics
```bash
# Status
git status

# View commit history
git log --oneline

# View differences
git diff

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Discard uncommitted changes
git checkout .
```

### GitHub CLI
```bash
# Create repository
gh repo create repo-name --public

# Clone repository
gh repo clone username/repo-name

# Create pull request
gh pr create

# View issues
gh issue list
```

### Repository Maintenance
```bash
# Clean up deleted files
git add -u

# Prune remote-tracking branches
git remote prune origin

# Garbage collect
git gc
```

## Next Steps

After setting up your repository:

1. **Invite team members** to collaborate
2. **Set up project boards** for task tracking
3. **Configure branch protection rules** for main branch
4. **Establish code review requirements**
5. **Set up notifications** for team communication

This complete workflow guide ensures you can effectively manage your Uber Clone project on GitHub with proper authentication, automated workflows, and best practices for collaboration.