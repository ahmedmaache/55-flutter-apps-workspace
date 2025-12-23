#!/bin/bash

# 🚀 Gloven Incubator - Create 44 Flutter Apps
# This script creates all Flutter applications for the 11 developer accounts

WORKSPACE="/home/maache/55 flutterapps"
cd "$WORKSPACE"

echo "══════════════════════════════════════════════════════════════"
echo "   🚀 GLOVEN INCUBATOR - Creating 44 Flutter Applications"
echo "══════════════════════════════════════════════════════════════"
echo ""

# Create directories for each developer account
mkdir -p "01_giggle_game"
mkdir -p "02_playpal_creations"
mkdir -p "03_olaf"
mkdir -p "04_good_kids"
mkdir -p "05_apocalypse_never"
mkdir -p "06_atomizer"
mkdir -p "07_okkyes"
mkdir -p "08_insightful_apps"
mkdir -p "09_build_deploy_labs"
mkdir -p "10_micho"
mkdir -p "11_playtime_programmers"

total_apps=0
created_apps=0

# Function to create a Flutter app
create_app() {
    local dir="$1"
    local app_name="$2"
    local org="$3"
    
    total_apps=$((total_apps + 1))
    
    echo "[$total_apps/44] Creating: $app_name in $dir"
    
    cd "$WORKSPACE/$dir"
    
    if [ -d "$app_name" ]; then
        echo "  ✓ Already exists, skipping"
        created_apps=$((created_apps + 1))
        return
    fi
    
    if flutter create --org "$org" --project-name "$app_name" "$app_name" > /dev/null 2>&1; then
        echo "  ✓ Created $app_name"
        created_apps=$((created_apps + 1))
    else
        echo "  ✗ Failed to create $app_name"
    fi
}

# 01 - Giggle Game
echo ""
echo "=== 01_giggle_game ==="
create_app "01_giggle_game" "joke_generator" "org.gloven.giggle"
create_app "01_giggle_game" "meme_maker" "org.gloven.giggle"
create_app "01_giggle_game" "emoji_story" "org.gloven.giggle"
create_app "01_giggle_game" "laugh_tracker" "org.gloven.giggle"

# 02 - PlayPal Creations
echo ""
echo "=== 02_playpal_creations ==="
create_app "02_playpal_creations" "playpal_connect" "org.gloven.playpal"
create_app "02_playpal_creations" "party_games" "org.gloven.playpal"
create_app "02_playpal_creations" "duo_challenges" "org.gloven.playpal"
create_app "02_playpal_creations" "word_games" "org.gloven.playpal"

# 03 - olaf
echo ""
echo "=== 03_olaf ==="
create_app "03_olaf" "brain_gym" "org.gloven.olaf"
create_app "03_olaf" "focus_timer" "org.gloven.olaf"
create_app "03_olaf" "meditation" "org.gloven.olaf"
create_app "03_olaf" "word_puzzles" "org.gloven.olaf"

# 04 - Good Kids
echo ""
echo "=== 04_good_kids ==="
create_app "04_good_kids" "abc_learning" "org.gloven.goodkids"
create_app "04_good_kids" "numbers_counting" "org.gloven.goodkids"
create_app "04_good_kids" "kindness_quest" "org.gloven.goodkids"
create_app "04_good_kids" "chore_champion" "org.gloven.goodkids"

# 05 - ApocalypseNever
echo ""
echo "=== 05_apocalypse_never ==="
create_app "05_apocalypse_never" "eco_warrior" "org.gloven.apocalypse"
create_app "05_apocalypse_never" "survival_calc" "org.gloven.apocalypse"
create_app "05_apocalypse_never" "carbon_tracker" "org.gloven.apocalypse"
create_app "05_apocalypse_never" "resource_manager" "org.gloven.apocalypse"

# 06 - Atomizer
echo ""
echo "=== 06_atomizer ==="
create_app "06_atomizer" "quick_notes" "org.gloven.atomizer"
create_app "06_atomizer" "speed_reader" "org.gloven.atomizer"
create_app "06_atomizer" "flash_math" "org.gloven.atomizer"
create_app "06_atomizer" "micro_habits" "org.gloven.atomizer"

# 07 - Okkyes
echo ""
echo "=== 07_okkyes ==="
create_app "07_okkyes" "affirmations" "org.gloven.okkyes"
create_app "07_okkyes" "mood_ok" "org.gloven.okkyes"
create_app "07_okkyes" "gratitude_journal" "org.gloven.okkyes"
create_app "07_okkyes" "goal_tracker" "org.gloven.okkyes"

# 08 - Insightful Apps
echo ""
echo "=== 08_insightful_apps ==="
create_app "08_insightful_apps" "insight_journal" "org.gloven.insight"
create_app "08_insightful_apps" "spending_insights" "org.gloven.insight"
create_app "08_insightful_apps" "habit_insights" "org.gloven.insight"
create_app "08_insightful_apps" "reading_tracker" "org.gloven.insight"

# 09 - Build & Deploy Labs
echo ""
echo "=== 09_build_deploy_labs ==="
create_app "09_build_deploy_labs" "devlog_app" "org.gloven.devlabs"
create_app "09_build_deploy_labs" "json_formatter" "org.gloven.devlabs"
create_app "09_build_deploy_labs" "regex_playground" "org.gloven.devlabs"
create_app "09_build_deploy_labs" "git_cheatsheet" "org.gloven.devlabs"

# 10 - MIcho
echo ""
echo "=== 10_micho ==="
create_app "10_micho" "startup_ideas" "org.gloven.micho"
create_app "10_micho" "pitch_deck" "org.gloven.micho"
create_app "10_micho" "founder_daily" "org.gloven.micho"
create_app "10_micho" "startup_glossary" "org.gloven.micho"

# 11 - Playtime Programmers
echo ""
echo "=== 11_playtime_programmers ==="
create_app "11_playtime_programmers" "code_hero" "org.gloven.playcode"
create_app "11_playtime_programmers" "bug_squash" "org.gloven.playcode"
create_app "11_playtime_programmers" "loop_master" "org.gloven.playcode"
create_app "11_playtime_programmers" "variable_valley" "org.gloven.playcode"

echo ""
echo "══════════════════════════════════════════════════════════════"
echo "   ✅ Completed: $created_apps / 44 apps created"
echo "══════════════════════════════════════════════════════════════"
