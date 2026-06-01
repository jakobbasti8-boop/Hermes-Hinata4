# Hermes-Hinata Setup Guide

## Prerequisites

- Android 11+ (API Level 30+)
- 2GB RAM minimum
- 500MB free storage
- USB debugging enabled (for installation)

## Development Setup

### 1. Clone Repository

```bash
git clone https://github.com/jakobbasti8-boop/hermes-hinata4.git
cd hermes-hinata4
```

### 2. Install Dependencies

```bash
./scripts/setup-dev.sh
```

This will:
- Install Node.js dependencies
- Install Python dependencies
- Verify all requirements

### 3. Configure Android SDK

```bash
# If using Expo
npx expo doctor

# Or manually set ANDROID_HOME
export ANDROID_HOME=$HOME/Android/Sdk
```

### 4. Start Development Server

```bash
npm start
```

This launches Metro bundler. Scan the QR code with:
- **Android**: Expo Go app
- **Physical device**: Camera + link

### 5. Run on Device/Emulator

```bash
npm run android
```

## Building APK

### Development APK

```bash
npm run build:android
```

### Production APK

```bash
npm run build:android -- --release
```

## Installation

### Via ADB

```bash
./scripts/install-device.sh
```

Or manually:

```bash
adb install app-release.apk
```

### Via APK File

1. Download APK to device
2. Open file manager
3. Tap APK → Install
4. Grant permissions

## Configuration

### Initial Setup

1. Open app
2. Tap Settings
3. Configure:
   - **Model**: Choose LLM provider/model
   - **API Key**: Enter for chosen provider
   - **Storage**: Set history size

### Config File

Location: `~/.hinata/config.json`

```json
{
  "agent": {
    "model": "nous-hermes-2-mixtral-8x7b-dpo",
    "provider": "openrouter",
    "api_key": "sk-...",
    "auto_save": true,
    "max_tokens": 4096
  },
  "terminal": {
    "font_size": 12,
    "font_family": "monospace",
    "theme": "dark",
    "cursor_style": "block"
  },
  "storage": {
    "max_history": 1000,
    "auto_backup": true,
    "backup_interval": 3600
  },
  "ui": {
    "theme": "auto",
    "font_scale": 1.0,
    "animations": true
  }
}
```

## Troubleshooting

### App won't start

1. Clear app data: Settings → Apps → Hermes-Hinata → Clear Storage
2. Restart device
3. Reinstall app

### Bridge crashes

1. Check Python: `python3 --version` (need 3.11+)
2. Reinstall bridge: `pip install -r hermes-bridge/requirements.txt`
3. View logs: Check app's log file

### Terminal not responding

1. Check Termux: Ensure it's installed separately
2. Verify PTY: Check permissions in Settings
3. Restart terminal: Pull down notification panel, tap "Restart Terminal"

### Low memory

1. Close other apps
2. Reduce max history in settings
3. Clear cache: Settings → Clear Cache

## Performance Optimization

### Reduce Memory Usage

```json
{
  "storage": {
    "max_history": 500  // Reduce from 1000
  },
  "agent": {
    "max_tokens": 2048  // Reduce from 4096
  }
}
```

### Faster Startup

1. Disable auto-load skills: `auto_load_skills: false`
2. Reduce font rendering: Lower font size
3. Simplify UI: Disable animations

## First Run Checklist

- [ ] App installs without errors
- [ ] Permissions granted (storage, internet)
- [ ] Settings page opens
- [ ] Can enter model/API key
- [ ] Chat screen loads
- [ ] Terminal initializes
- [ ] Can type in both interfaces
- [ ] Message sends and displays
- [ ] Terminal command executes

## Next Steps

1. Read [Architecture Guide](ARCHITECTURE.md)
2. Explore [API Reference](API.md)
3. Check [Contributing Guide](CONTRIBUTING.md)
4. Join our community discussions
