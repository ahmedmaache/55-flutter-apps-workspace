#!/usr/bin/env python3
"""
Generate app icons for all Flutter apps
Creates icons with app-specific emojis and colors
"""

import os
import sys
from PIL import Image, ImageDraw, ImageFont
import json

# App icon configurations
APP_ICONS = {
    "01_giggle_game": {
        "joke_generator": {"emoji": "😂", "color": (255, 107, 53)},  # Orange
        "meme_maker": {"emoji": "🎨", "color": (255, 107, 157)},  # Pink
        "emoji_story": {"emoji": "📖", "color": (255, 179, 71)},  # Yellow-Orange
        "laugh_tracker": {"emoji": "😄", "color": (255, 215, 0)},  # Gold
    },
    "02_playpal_creations": {
        "playpal_connect": {"emoji": "🎮", "color": (76, 175, 80)},  # Green
        "party_games": {"emoji": "🎉", "color": (156, 39, 176)},  # Purple
        "duo_challenges": {"emoji": "👥", "color": (33, 150, 243)},  # Blue
        "word_games": {"emoji": "📝", "color": (255, 152, 0)},  # Orange
    },
    "03_olaf": {
        "brain_gym": {"emoji": "🧠", "color": (63, 81, 181)},  # Indigo
        "focus_timer": {"emoji": "⏱️", "color": (0, 150, 136)},  # Teal
        "meditation": {"emoji": "🧘", "color": (121, 85, 72)},  # Brown
        "word_puzzles": {"emoji": "🧩", "color": (96, 125, 139)},  # Blue Grey
    },
    "04_good_kids": {
        "abc_learning": {"emoji": "🔤", "color": (255, 193, 7)},  # Amber
        "numbers_counting": {"emoji": "🔢", "color": (233, 30, 99)},  # Pink
        "kindness_quest": {"emoji": "❤️", "color": (244, 67, 54)},  # Red
        "chore_champion": {"emoji": "⭐", "color": (255, 235, 59)},  # Yellow
    },
    "05_apocalypse_never": {
        "eco_warrior": {"emoji": "🌱", "color": (76, 175, 80)},  # Green
        "survival_calc": {"emoji": "🛡️", "color": (158, 158, 158)},  # Grey
        "carbon_tracker": {"emoji": "🌍", "color": (33, 150, 243)},  # Blue
        "resource_manager": {"emoji": "📦", "color": (121, 85, 72)},  # Brown
    },
    "06_atomizer": {
        "quick_notes": {"emoji": "⚡", "color": (255, 193, 7)},  # Amber
        "speed_reader": {"emoji": "📚", "color": (63, 81, 181)},  # Indigo
        "flash_math": {"emoji": "🔢", "color": (156, 39, 176)},  # Purple
        "micro_habits": {"emoji": "✅", "color": (76, 175, 80)},  # Green
    },
    "07_okkyes": {
        "affirmations": {"emoji": "✨", "color": (156, 39, 176)},  # Purple
        "mood_ok": {"emoji": "😊", "color": (255, 193, 7)},  # Amber
        "gratitude_journal": {"emoji": "🙏", "color": (255, 152, 0)},  # Orange
        "goal_tracker": {"emoji": "🎯", "color": (33, 150, 243)},  # Blue
    },
    "08_insightful_apps": {
        "insight_journal": {"emoji": "💡", "color": (255, 193, 7)},  # Amber
        "spending_insights": {"emoji": "💰", "color": (76, 175, 80)},  # Green
        "habit_insights": {"emoji": "📊", "color": (33, 150, 243)},  # Blue
        "reading_tracker": {"emoji": "📖", "color": (156, 39, 176)},  # Purple
    },
    "09_build_deploy_labs": {
        "devlog_app": {"emoji": "📝", "color": (96, 125, 139)},  # Blue Grey
        "json_formatter": {"emoji": "{}", "color": (63, 81, 181)},  # Indigo
        "regex_playground": {"emoji": "🔍", "color": (0, 150, 136)},  # Teal
        "git_cheatsheet": {"emoji": "🔧", "color": (158, 158, 158)},  # Grey
    },
    "10_micho": {
        "startup_ideas": {"emoji": "💡", "color": (255, 152, 0)},  # Orange
        "pitch_deck": {"emoji": "📊", "color": (33, 150, 243)},  # Blue
        "founder_daily": {"emoji": "📅", "color": (156, 39, 176)},  # Purple
        "startup_glossary": {"emoji": "📚", "color": (63, 81, 181)},  # Indigo
    },
    "11_playtime_programmers": {
        "code_hero": {"emoji": "🦸", "color": (255, 87, 34)},  # Deep Orange
        "bug_squash": {"emoji": "🐛", "color": (76, 175, 80)},  # Green
        "loop_master": {"emoji": "🔄", "color": (33, 150, 243)},  # Blue
        "variable_valley": {"emoji": "📦", "color": (156, 39, 176)},  # Purple
    },
}

# Android icon sizes
ICON_SIZES = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}

def create_icon(size, emoji, color):
    """Create an app icon with emoji and background color"""
    # Create image with rounded corners
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Draw rounded rectangle background
    corner_radius = size // 8
    draw.rounded_rectangle(
        [(0, 0), (size, size)],
        radius=corner_radius,
        fill=color
    )
    
    # For emoji rendering, we'll use a text-based approach
    # Since emoji fonts may not be available, we'll create a simple colored circle with text
    # Try to use Noto Color Emoji font (common on Linux)
    font_size = int(size * 0.5)
    font = None
    
    # Try different emoji font paths
    emoji_font_paths = [
        "/usr/share/fonts/truetype/noto/NotoColorEmoji.ttf",
        "/usr/share/fonts/truetype/noto/NotoEmoji-Regular.ttf",
        "/System/Library/Fonts/Apple Color Emoji.ttc",
        "/Library/Fonts/Apple Color Emoji.ttc",
    ]
    
    for font_path in emoji_font_paths:
        try:
            if os.path.exists(font_path):
                font = ImageFont.truetype(font_path, font_size)
                break
        except:
            continue
    
    # If no emoji font found, use default and draw emoji as text
    if font is None:
        try:
            # Try DejaVu Sans which has better Unicode support
            font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", font_size)
        except:
            font = ImageFont.load_default()
    
    # Calculate text position (center)
    try:
        bbox = draw.textbbox((0, 0), emoji, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        x = (size - text_width) // 2 - bbox[0]
        y = (size - text_height) // 2 - bbox[1]
    except:
        # Fallback positioning
        x = size // 4
        y = size // 4
    
    # Draw emoji/text
    try:
        draw.text((x, y), emoji, font=font, fill=(255, 255, 255, 255), embedded_color=True)
    except:
        # If emoji rendering fails, draw a simple circle with first letter
        circle_size = int(size * 0.6)
        circle_x = (size - circle_size) // 2
        circle_y = (size - circle_size) // 2
        draw.ellipse(
            [circle_x, circle_y, circle_x + circle_size, circle_y + circle_size],
            fill=(255, 255, 255, 200)
        )
        # Draw first character of emoji or app name
        text = emoji[0] if len(emoji) > 0 else "A"
        bbox = draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        text_x = (size - text_width) // 2 - bbox[0]
        text_y = (size - text_height) // 2 - bbox[1]
        draw.text((text_x, text_y), text, font=font, fill=color)
    
    return img

def generate_icons_for_app(developer, app_name, config):
    """Generate all icon sizes for an app"""
    emoji = config["emoji"]
    color = config["color"]
    
    app_path = f"{developer}/{app_name}/android/app/src/main/res"
    
    for mipmap_name, size in ICON_SIZES.items():
        mipmap_path = os.path.join(app_path, mipmap_name)
        os.makedirs(mipmap_path, exist_ok=True)
        
        icon = create_icon(size, emoji, color)
        icon_path = os.path.join(mipmap_path, "ic_launcher.png")
        icon.save(icon_path, "PNG")
        print(f"✅ Created {icon_path} ({size}x{size})")
    
    # Also create adaptive icon foreground (for Android 8.0+)
    adaptive_path = os.path.join(app_path, "mipmap-anydpi-v26")
    os.makedirs(adaptive_path, exist_ok=True)
    
    # Create adaptive icon XML
    xml_content = '''<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>'''
    
    with open(os.path.join(adaptive_path, "ic_launcher.xml"), "w") as f:
        f.write(xml_content)
    
    # Create foreground icon (transparent background with emoji)
    foreground_size = 108  # Standard foreground size
    foreground_img = Image.new('RGBA', (foreground_size, foreground_size), (0, 0, 0, 0))
    foreground_draw = ImageDraw.Draw(foreground_img)
    
    # Try to draw emoji on transparent background
    font_size = int(foreground_size * 0.6)
    font = None
    emoji_font_paths = [
        "/usr/share/fonts/truetype/noto/NotoColorEmoji.ttf",
        "/usr/share/fonts/truetype/noto/NotoEmoji-Regular.ttf",
    ]
    for font_path in emoji_font_paths:
        try:
            if os.path.exists(font_path):
                font = ImageFont.truetype(font_path, font_size)
                break
        except:
            continue
    
    if font is None:
        try:
            font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", font_size)
        except:
            font = ImageFont.load_default()
    
    try:
        bbox = foreground_draw.textbbox((0, 0), emoji, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        x = (foreground_size - text_width) // 2 - bbox[0]
        y = (foreground_size - text_height) // 2 - bbox[1]
        foreground_draw.text((x, y), emoji, font=font, embedded_color=True)
    except:
        # Fallback: draw circle
        circle_size = int(foreground_size * 0.7)
        circle_x = (foreground_size - circle_size) // 2
        circle_y = (foreground_size - circle_size) // 2
        foreground_draw.ellipse(
            [circle_x, circle_y, circle_x + circle_size, circle_y + circle_size],
            fill=(255, 255, 255, 200)
        )
    
    # Save foreground icons in all sizes
    for mipmap_name, size in ICON_SIZES.items():
        mipmap_path = os.path.join(app_path, mipmap_name)
        foreground_resized = foreground_img.resize((size, size), Image.Resampling.LANCZOS)
        foreground_path = os.path.join(mipmap_path, "ic_launcher_foreground.png")
        foreground_resized.save(foreground_path, "PNG")
        print(f"✅ Created {foreground_path} ({size}x{size})")
    
    # Create color resource for adaptive icon background
    values_path = os.path.join(app_path, "../values")
    os.makedirs(values_path, exist_ok=True)
    colors_xml = f'''<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#{color[0]:02x}{color[1]:02x}{color[2]:02x}</color>
</resources>'''
    with open(os.path.join(values_path, "colors.xml"), "w") as f:
        f.write(colors_xml)
    print(f"✅ Created {values_path}/colors.xml")

def main():
    developer_filter = sys.argv[1] if len(sys.argv) > 1 else "all"
    
    print("══════════════════════════════════════════════════════════════")
    print("   🎨 Generating App Icons")
    print("══════════════════════════════════════════════════════════════")
    print("")
    
    total_icons = 0
    
    for developer, apps in APP_ICONS.items():
        if developer_filter != "all" and developer != developer_filter:
            continue
        
        print(f"Developer: {developer}")
        for app_name, config in apps.items():
            app_path = f"{developer}/{app_name}"
            if not os.path.exists(app_path):
                print(f"⚠️  Skipping {app_path} (not found)")
                continue
            
            print(f"  Generating icons for: {app_name}")
            generate_icons_for_app(developer, app_name, config)
            total_icons += len(ICON_SIZES) * 2  # Regular + foreground icons
            print("")
    
    print("══════════════════════════════════════════════════════════════")
    print(f"   ✅ Generated icons for {total_icons} icon files")
    print("══════════════════════════════════════════════════════════════")

if __name__ == "__main__":
    main()

