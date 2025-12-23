#!/bin/bash
# Sync workspace with GitHub (no SSH needed)

set -e

WORKSPACE_DIR="$(pwd)"

echo "══════════════════════════════════════════════════════════════"
echo "   🔄 Syncing Workspace with GitHub"
echo "══════════════════════════════════════════════════════════════"
echo ""

# Check if git repo exists
if [ ! -d ".git" ]; then
    echo "⚠️  Git repository not initialized"
    echo "   Run: git init && git remote add origin https://github.com/ahmedmaache/55-flutter-apps-workspace.git"
    exit 1
fi

# Function to sync to GitHub
sync_to_github() {
    echo "📤 Syncing to GitHub..."
    
    # Check if remote exists
    if ! git remote get-url origin &>/dev/null; then
        echo "⚠️  GitHub remote not configured"
        echo "   Run: git remote add origin https://github.com/ahmedmaache/55-flutter-apps-workspace.git"
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
    "push"|"to-github")
        sync_to_github
        ;;
    "pull"|"from-github")
        sync_from_github
        ;;
    "status")
        git status
        ;;
    "menu"|*)
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  push, to-github    - Push changes to GitHub"
        echo "  pull, from-github - Pull changes from GitHub"
        echo "  status            - Show git status"
        echo ""
        echo "Example:"
        echo "  $0 push    # Push local changes to GitHub"
        echo "  $0 pull    # Pull changes from GitHub"
        ;;
esac

echo "══════════════════════════════════════════════════════════════"
echo "   ✅ Sync Complete!"
echo "══════════════════════════════════════════════════════════════"

