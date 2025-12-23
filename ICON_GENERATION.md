# App Icon Generation Guide

## 🎨 Custom App Icons

All apps now have custom icons instead of the generic Flutter F icon. Icons are generated automatically with:
- **App-specific emojis** - Unique emoji for each app
- **Brand colors** - Color matching each developer's brand
- **All Android sizes** - mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi
- **Adaptive icons** - Support for Android 8.0+ adaptive icons

## 🚀 Generating Icons

### Via GitHub Actions

1. **Go to Actions tab** in GitHub
2. **Select "Build Apps with Custom Icons"** workflow
3. **Click "Run workflow"**
4. Icons will be generated automatically before building

### Manual Generation (Local/Codespaces)

```bash
# Install dependencies
pip install Pillow

# Generate icons for all apps
python3 .github/scripts/generate_app_icons.py all

# Generate icons for specific developer
python3 .github/scripts/generate_app_icons.py 01_giggle_game
```

## 📱 Icon Specifications

Each app gets:
- **5 standard sizes**: mdpi (48px), hdpi (72px), xhdpi (96px), xxhdpi (144px), xxxhdpi (192px)
- **Adaptive icon support**: Foreground and background layers
- **Rounded corners**: Modern Android design
- **Brand colors**: Matching developer account theme

## 🎯 App Icon Mappings

### Giggle Game
- Joke Generator: 😂 Orange
- Meme Maker: 🎨 Pink
- Emoji Story: 📖 Yellow-Orange
- Laugh Tracker: 😄 Gold

### PlayPal Creations
- PlayPal Connect: 🎮 Green
- Party Games: 🎉 Purple
- Duo Challenges: 👥 Blue
- Word Games: 📝 Orange

### olaf
- Brain Gym: 🧠 Indigo
- Focus Timer: ⏱️ Teal
- Meditation: 🧘 Brown
- Word Puzzles: 🧩 Blue Grey

### Good Kids
- ABC Learning: 🔤 Amber
- Numbers Counting: 🔢 Pink
- Kindness Quest: ❤️ Red
- Chore Champion: ⭐ Yellow

### ApocalypseNever
- Eco Warrior: 🌱 Green
- Survival Calc: 🛡️ Grey
- Carbon Tracker: 🌍 Blue
- Resource Manager: 📦 Brown

### Atomizer
- Quick Notes: ⚡ Amber
- Speed Reader: 📚 Indigo
- Flash Math: 🔢 Purple
- Micro Habits: ✅ Green

### Okkyes
- Affirmations: ✨ Purple
- Mood OK: 😊 Amber
- Gratitude Journal: 🙏 Orange
- Goal Tracker: 🎯 Blue

### Insightful Apps
- Insight Journal: 💡 Amber
- Spending Insights: 💰 Green
- Habit Insights: 📊 Blue
- Reading Tracker: 📖 Purple

### Build & Deploy Labs
- DevLog App: 📝 Blue Grey
- JSON Formatter: {} Indigo
- Regex Playground: 🔍 Teal
- Git Cheatsheet: 🔧 Grey

### MIcho
- Startup Ideas: 💡 Orange
- Pitch Deck: 📊 Blue
- Founder Daily: 📅 Purple
- Startup Glossary: 📚 Indigo

### Playtime Programmers
- Code Hero: 🦸 Deep Orange
- Bug Squash: 🐛 Green
- Loop Master: 🔄 Blue
- Variable Valley: 📦 Purple

## 🔨 Building with Icons

### Build AAB and APK

1. **Icons are generated automatically** when you run the build workflow
2. **Both AAB and APK** files are built with custom icons
3. **Artifacts are uploaded** to GitHub Actions for download

### Workflow Steps

1. Generate icons for selected apps
2. Build AAB file (for Google Play)
3. Build APK file (for direct installation)
4. Upload both as artifacts
5. Copy to store_assets folder

## 📦 Icon Files Location

Icons are stored in:
```
[developer]/[app]/android/app/src/main/res/
├── mipmap-mdpi/ic_launcher.png
├── mipmap-hdpi/ic_launcher.png
├── mipmap-xhdpi/ic_launcher.png
├── mipmap-xxhdpi/ic_launcher.png
├── mipmap-xxxhdpi/ic_launcher.png
└── mipmap-anydpi-v26/ic_launcher.xml (adaptive icon)
```

## ✅ Verification

After building, verify icons are included:
```bash
# Check icon files exist
find . -name "ic_launcher.png" | head -5

# Check adaptive icon
find . -name "ic_launcher.xml" | head -5
```

## 🔄 Updating Icons

To change an app's icon:
1. Edit `.github/scripts/generate_app_icons.py`
2. Update emoji or color for the app
3. Run the workflow again
4. Icons will be regenerated

---

**Last Updated:** December 2024

