# GitHub Codespaces Setup Guide

## 🚀 Quick Start

### 1. Initialize Git Repository

```bash
cd ~/55_flutterapps
git init
git add .
git commit -m "Initial commit: 55 Flutter Apps workspace"
```

### 2. Create GitHub Repository

1. Go to https://github.com/new
2. Create a new repository (e.g., `55-flutter-apps`)
3. **Don't** initialize with README (we already have files)

### 3. Push to GitHub

```bash
git remote add origin https://github.com/YOUR_USERNAME/55-flutter-apps.git
git branch -M main
git push -u origin main
```

### 4. Open in Codespaces

1. Go to your repository on GitHub
2. Click the green "Code" button
3. Select "Codespaces" tab
4. Click "Create codespace on main"
5. Wait for setup (first time takes ~5 minutes)

## 📁 Workspace in Codespaces

The workspace will be automatically set up with:
- ✅ Flutter SDK installed (`/usr/local/flutter`)
- ✅ Python 3 for scripts
- ✅ VS Code extensions (Dart, Flutter)
- ✅ All your apps and store assets

## 🔧 Working in Codespaces

### Build AAB Files

```bash
cd 01_giggle_game/joke_generator
flutter clean
flutter pub get
flutter build appbundle --release
```

### Run Scripts

```bash
python3 create_wordpress_posts.py
```

## 💾 Syncing

### Push Changes to GitHub
```bash
git add .
git commit -m "Your commit message"
git push
```

### Pull Changes in Codespaces
```bash
git pull
```

## 🎯 Codespaces Features

- **Free tier:** 60 hours/month, 2-core machine
- **Storage:** 32GB default
- **Auto-save:** Changes saved automatically
- **Terminal:** Full Linux terminal access
- **Extensions:** Pre-installed Flutter/Dart extensions

## 📝 Next Steps

1. ✅ Create GitHub repository
2. ✅ Push workspace to GitHub
3. ✅ Open in Codespaces
4. ✅ Verify Flutter installation
5. ✅ Test building an app

---

**Need Help?**
- GitHub Codespaces Docs: https://docs.github.com/en/codespaces
- Flutter Docs: https://docs.flutter.dev
