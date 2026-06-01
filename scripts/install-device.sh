#!/bin/bash

set -e

echo "📱 Installing APK on connected device..."

# Find latest APK
APK=$(find . -name "*.apk" -type f -printf '%T@ %p\n' | sort -rn | head -1 | cut -d' ' -f2-)

if [ -z "$APK" ]; then
    echo "❌ No APK found. Build first with ./scripts/build-apk.sh"
    exit 1
fi

echo "📦 Found APK: $APK"
echo "📲 Installing on device..."

adb install -r "$APK"

echo "✅ Installation complete!"
echo "Starting app..."
adb shell am start -n com.jakobbasti8.hermeshinata/com.jakobbasti8.hermeshinata.MainActivity
