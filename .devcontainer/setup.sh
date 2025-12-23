#!/bin/bash
set -e

echo "══════════════════════════════════════════════════════════════"
echo "   🚀 Setting up Flutter Apps Workspace in Codespaces"
echo "══════════════════════════════════════════════════════════════"
echo ""

# Install Flutter
if [ ! -d "/usr/local/flutter" ]; then
    echo "📦 Installing Flutter..."
    cd /usr/local
    git clone https://github.com/flutter/flutter.git -b stable
    chmod -R 755 flutter
    export PATH="$PATH:/usr/local/flutter/bin"
    flutter doctor --android-licenses || true
    flutter doctor
else
    echo "✅ Flutter already installed"
    export PATH="$PATH:/usr/local/flutter/bin"
    flutter --version
fi

# Install Python dependencies
echo ""
echo "📦 Installing Python dependencies..."
pip3 install requests --quiet

echo ""
echo "══════════════════════════════════════════════════════════════"
echo "   ✅ Setup Complete!"
echo "══════════════════════════════════════════════════════════════"
echo ""
echo "Flutter: $(flutter --version | head -1)"
echo "Python: $(python3 --version)"
echo "Workspace: $(pwd)"
echo ""
