#!/bin/bash
set -e

# clip DMG Builder
# Run from project root: ./build.sh

APP_NAME="clip"
DMG_NAME="${APP_NAME}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"
DMG_TEMP="${BUILD_DIR}/dmg-temp"
OUTPUT_DIR="${SCRIPT_DIR}"

echo "🔨 Starting Release build..."

# Disable code signing in CI (no certificates available)
XCODEBUILD_EXTRA=()
if [[ -n "${CI}" ]]; then
    XCODEBUILD_EXTRA=(CODE_SIGN_IDENTITY="-" CODE_SIGNING_REQUIRED=NO)
fi

xcodebuild -scheme "${APP_NAME}" \
    -configuration Release \
    -derivedDataPath "${BUILD_DIR}/DerivedData" \
    "${XCODEBUILD_EXTRA[@]}" \
    clean build

APP_PATH="${BUILD_DIR}/DerivedData/Build/Products/Release/${APP_NAME}.app"

if [[ ! -d "${APP_PATH}" ]]; then
    echo "❌ Error: ${APP_NAME}.app not found: ${APP_PATH}"
    exit 1
fi

echo "📦 Creating DMG..."

# Cleanup
rm -rf "${DMG_TEMP}"
mkdir -p "${DMG_TEMP}"

# Copy app and Applications symlink
cp -R "${APP_PATH}" "${DMG_TEMP}/"
ln -s /Applications "${DMG_TEMP}/Applications"

# Create DMG
DMG_OUTPUT="${OUTPUT_DIR}/${DMG_NAME}.dmg"
rm -f "${DMG_OUTPUT}"

hdiutil create \
    -volname "${DMG_NAME}" \
    -srcfolder "${DMG_TEMP}" \
    -ov \
    -format UDZO \
    "${DMG_OUTPUT}"

# Cleanup
rm -rf "${DMG_TEMP}"

echo "✅ DMG created: ${DMG_OUTPUT}"
if [[ -z "${CI}" ]]; then
    open -R "${DMG_OUTPUT}"
fi
