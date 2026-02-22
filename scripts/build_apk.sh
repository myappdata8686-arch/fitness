#!/usr/bin/env bash
set -euo pipefail

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter SDK is required but not installed/in PATH."
  exit 1
fi

flutter pub get
flutter create --platforms=android .
flutter build apk --debug

echo "APK built at: build/app/outputs/flutter-apk/app-debug.apk"
