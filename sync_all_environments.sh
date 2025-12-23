#!/bin/bash
# Sync workspace across all environments: Local, Remote PC, and GitHub

set -e

WORKSPACE_DIR="$(pwd)"
REMOTE_HOST="maache@192.168.1.24"
REMOTE_PASS="1234"
REMOTE_WORKSPACE="~/55_flutterapps"

echo "══════════════════════════════════════════════════════════════"
echo "   🔄 Syncing Workspace Across All Environments"
echo "══════════════════════════════════════════════════════════════"
echo ""

# Check if git repo exists
if [ ! -d ".git" ]; then
    echo "⚠️  Git repository not initialized"
    echo "   Run: git init && git add . && git commit -m 'Initial commit'"
    exit 1
fi

# Function to sync to GitHub
sync_to_github() {
    echo "📤 Syncing to GitHub..."
    
    # Check if remote exists
    if ! git remote get-url origin &>/dev/null; then
        echo "⚠️  GitHub remote not configured"
        echo "   Run: git remote add origin https://github.com/YOUR_USERNAME/REPO.git"
        return 1
    fi
    
    git add .
    if git diff --staged --quiet; then
        echo "ℹ️  No changes to commit"
    else
        git commit -m "Sync: $(date '+%Y-%m-%d %H:%M:%S')" || true
    fi
    
    git push origin main 2>&1 | tail -5
    echo "✅ GitHub sync complete"
    echo ""
}

# Function to sync from GitHub
sync_from_github() {
    echo "📥 Syncing from GitHub..."
    
    if ! git remote get-url origin &>/dev/null; then
        echo "⚠️  GitHub remote not configured"
        return 1
    fi
    
    git pull origin main 2>&1 | tail -5
    echo "✅ Sync from GitHub complete"
    echo ""
}

# Main menu
case "${1:-menu}" in
    "to-github")
        sync_to_github
        ;;
    "from-github")
        sync_from_github
        ;;
    "menu"|*)
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  to-github      - Sync to GitHub"
        echo "  from-github    - Sync from GitHub"
        ;;
esac

echo "══════════════════════════════════════════════════════════════"
echo "   ✅ Sync Complete!"
echo "══════════════════════════════════════════════════════════════"
