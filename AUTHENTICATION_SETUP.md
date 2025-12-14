# GitHub Authentication Setup Guide

This document provides instructions for setting up GitHub authentication so you can easily push changes to your repository.

## Prerequisites

Before setting up authentication, ensure you have:

1. **Git** installed on your local machine
2. **GitHub account** with appropriate permissions
3. **GitHub CLI** installed (recommended for easier authentication)

## Authentication Methods

### Method 1: GitHub CLI Authentication (Recommended)

GitHub CLI provides the easiest way to authenticate with GitHub.

#### Install GitHub CLI

**macOS:**
```bash
brew install gh
```

**Windows:**
```bash
winget install GitHub.cli
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt install gh
```

**Other Linux distributions:**
Visit [GitHub CLI installation guide](https://github.com/cli/cli/blob/trunk/docs/install_linux.md)

#### Authenticate with GitHub CLI

```bash
gh auth login
```

Follow the prompts:
1. Choose GitHub.com
2. Choose SSH or HTTPS (SSH is recommended for better security)
3. Authenticate using:
   - Browser: Opens your browser to authenticate
   - Token: If you prefer using a personal access token

#### Verify Authentication

```bash
gh auth status
```

### Method 2: SSH Keys (More Secure)

#### Generate SSH Key Pair

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

Press Enter to accept the default file location.

When prompted for a passphrase, you can either:
- Enter a secure passphrase (recommended)
- Press Enter to leave it empty (less secure)

#### Add SSH Key to SSH Agent

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

#### Add SSH Key to GitHub

1. Copy your public key:
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

2. Go to GitHub Settings > SSH and GPG keys > New SSH key
3. Paste your public key and save

#### Test SSH Connection

```bash
ssh -T git@github.com
```

You should see a message like:
```
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

### Method 3: Personal Access Token (HTTPS)

#### Create Personal Access Token

1. Go to GitHub Settings > Developer settings > Personal access tokens > Tokens (classic)
2. Click "Generate new token" > "Generate new token (classic)"
3. Give your token a name (e.g., "Uber Clone Development")
4. Select appropriate scopes:
   - `repo` (Full control of private repositories)
   - `workflow` (Update GitHub Action workflows)
   - `gist` (if needed)
5. Click "Generate token"
6. **Copy the token immediately** (you won't see it again)

#### Store Token Securely

Create a credential helper or store it in your Git configuration:

```bash
git config --global credential.helper store
```

Then, the next time you push, you'll be prompted for username and token.

## Automated Push Script

The auto-push script has been created at `scripts/auto-push.sh` and can be used to automate your Git workflow.

### Using the Auto Push Script

1. Make sure the script is executable:
   ```bash
   chmod +x scripts/auto-push.sh
   ```

2. Run the script:
   ```bash
   # Push to current branch with default message
   ./scripts/auto-push.sh

   # Push to specific branch with default message
   ./scripts/auto-push.sh main

   # Push to specific branch with custom message
   ./scripts/auto-push.sh main "Add new feature implementation"
   ```

## Best Practices

1. **Regular Authentication Checks**: Periodically verify your authentication status
2. **Secure Token Storage**: Never commit personal access tokens to repositories
3. **SSH Key Security**: Protect your SSH keys with passphrases
4. **Automated Backups**: Regularly push changes to avoid data loss
5. **Branch Management**: Use feature branches for development work

## Troubleshooting

### Common Issues

1. **Permission Denied**:
   - Verify your SSH key is added to GitHub
   - Check that your personal access token has the correct scopes
   - Ensure you're using the correct repository URL

2. **Authentication Failed**:
   - Re-authenticate with GitHub CLI: `gh auth login`
   - Regenerate SSH keys if needed
   - Create a new personal access token

3. **Push Rejected**:
   - Pull latest changes: `git pull origin main`
   - Resolve any merge conflicts
   - Try pushing again

### Useful Commands

```bash
# Check authentication status
gh auth status

# Test SSH connection
ssh -T git@github.com

# View remote URL
git remote -v

# Change remote URL
git remote set-url origin new-url

# View commit history
git log --oneline
```

With proper authentication set up and the auto-push script ready, you'll be able to easily push changes to your GitHub repository without manual authentication steps each time.