#!/bin/bash

# Build AAB files and create WordPress posts for Giggle Game apps
# Developer: Giggle Game (createsuccess2026@gmail.com)

WORKSPACE="/home/maache/55 flutterapps"
cd "$WORKSPACE"

echo "══════════════════════════════════════════════════════════════"
echo "   🚀 Building Giggle Game Apps - AAB Files & WordPress Posts"
echo "══════════════════════════════════════════════════════════════"
echo ""

APPS=("joke_generator" "meme_maker" "emoji_story" "laugh_tracker")
DEVELOPER="Giggle Game"
DEVELOPER_EMAIL="createsuccess2026@gmail.com"

# Build AAB files
for app in "${APPS[@]}"; do
    echo "Building AAB for: $app"
    cd "$WORKSPACE/01_giggle_game/$app"
    
    # Clean previous builds
    flutter clean
    
    # Get dependencies
    flutter pub get
    
    # Build AAB (using debug signing for now - replace with release signing later)
    flutter build appbundle --release
    
    # Copy AAB to store assets
    if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
        mkdir -p "$WORKSPACE/store_assets/$DEVELOPER/$app"
        cp "build/app/outputs/bundle/release/app-release.aab" "$WORKSPACE/store_assets/$DEVELOPER/$app/app-release.aab"
        echo "  ✓ AAB file created and copied to store_assets"
    else
        echo "  ✗ AAB build failed"
    fi
    echo ""
done

echo "══════════════════════════════════════════════════════════════"
echo "   ✅ Build Complete!"
echo "══════════════════════════════════════════════════════════════"

