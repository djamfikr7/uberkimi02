#!/bin/bash

# Auto Push Script
# Automates the process of committing and pushing changes to GitHub

echo "🚀 Auto Push Script"
echo "==================="

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not in a git repository"
    exit 1
fi

# Get branch name (default to current branch)
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

# Allow user to specify a different branch
if [ $# -gt 0 ]; then
    BRANCH_NAME=$1
fi

echo "📁 Working on branch: $BRANCH_NAME"

# Check for changes
if ! git diff-index --quiet HEAD -- && git diff --quiet; then
    echo "✅ No changes to commit"
    exit 0
fi

# Stage all changes
echo "➕ Staging all changes..."
git add .

# Get commit message from user or use default
if [ $# -gt 1 ]; then
    COMMIT_MESSAGE="$2"
else
    echo "📝 Enter commit message (or press Enter for default):"
    read -r COMMIT_MESSAGE
    if [ -z "$COMMIT_MESSAGE" ]; then
        COMMIT_MESSAGE="Update files"
    fi
fi

# Commit changes
echo "📌 Committing changes..."
git commit -m "$COMMIT_MESSAGE"

# Push changes
echo "☁️ Pushing to GitHub..."
git push origin "$BRANCH_NAME"

if [ $? -eq 0 ]; then
    echo "✅ Changes successfully pushed to GitHub!"
    echo "🔗 View your repository at: https://github.com/$(git remote get-url origin | sed 's/.*://' | sed 's/\.git$//')"
else
    echo "❌ Failed to push changes"
    exit 1
fi