#!/bin/bash

set -e

echo "🚀 Setting up Hermes-Hinata development environment..."

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Please install Node.js 18+"
    exit 1
fi

echo "✅ Node.js $(node --version) found"

# Install npm dependencies
echo "📦 Installing npm dependencies..."
npm install

# Install Python dependencies for bridge
echo "🐍 Installing Python dependencies..."
if [ -d "hermes-bridge" ]; then
    cd hermes-bridge
    python3 -m pip install -r requirements.txt
    cd ..
fi

echo "✅ Development environment setup complete!"
echo ""
echo "Next steps:"
echo "1. Start development: npm start"
echo "2. Run on Android: npm run android"
echo "3. Build APK: ./scripts/build-apk.sh"
