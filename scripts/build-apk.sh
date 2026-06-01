#!/bin/bash

set -e

echo "🏗️  Building Hermes-Hinata APK..."

# Check if eas is installed
if ! command -v eas &> /dev/null; then
    echo "Installing EAS CLI..."
    npm install -g eas-cli
fi

echo "📦 Building APK with EAS..."
eas build --platform android --local

echo "✅ APK build complete!"
echo "Check the output for APK location."
