<p align="center">
  <strong>clip</strong>
</p>

<p align="center">
  <strong>Minimal clipboard manager for macOS.</strong>
</p>

<p align="center">
  Keep your last copied items in the menu bar — click to paste anywhere.
</p>

<p align="center">
  <a href="#download">Download</a> · <a href="#features">Features</a> · <a href="#how-it-works">How It Works</a> · <a href="#building-from-source">Build</a>
</p>

---

## What is clip?

**clip** is a lightweight clipboard manager that lives in your menu bar. It automatically saves your copy history and lets you paste any previous item with a single click — no need to copy again.

Built with **SwiftUI and AppKit** — native macOS, no Electron.

## Download

**Download the latest .dmg from [Releases](https://github.com/yilmazcakmakci/clip/releases/latest)**

> Requires **macOS 13.5** or later. Works on Apple Silicon and Intel.

### First launch

Since clip is distributed outside the Mac App Store, macOS may block it on first open. Run this once in Terminal:

```bash
xattr -cr /Applications/clip.app
```

Then right-click the app → **Open**.

**Accessibility permission:** clip needs Accessibility access to paste into other apps. On first paste, macOS will prompt you. Go to **System Settings → Privacy & Security → Accessibility** and enable clip.

## Features

| Feature | Description |
|---------|-------------|
| **Clipboard history** | Automatically saves the last 10, 20, or 50 copied text items |
| **Click to paste** | Select an item from the menu — it pastes instantly into your active app |
| **Adjustable limit** | Choose how many items to keep: 10, 20, or 50 |
| **Clear history** | One-click to wipe all saved clips |
| **Menu bar only** | No dock icon — stays out of the way |

## How It Works

1. **Copy something** — clip automatically captures it in the background
2. **Click the menu bar icon** — see your recent copies
3. **Click an item** — it’s pasted into the frontmost app (or becomes the current clipboard for Cmd+V)
4. **Adjust** — change history limit or clear history from the menu

## Building from Source

### Requirements

- macOS 13.5+
- Xcode 15+
- Swift 5.9+

### Build

```bash
git clone https://github.com/yilmazcakmakci/clip.git
cd clip
open clip.xcodeproj
```

Build and run with ⌘R in Xcode.

### Create a release DMG

```bash
chmod +x build.sh
./build.sh
```

This builds a Release binary and creates `clip.dmg` in the project root.

### Project structure

```
clip/
├── clip.xcodeproj
├── build.sh                         # Release build + DMG creation
├── README.md
└── clip/
    ├── clipApp.swift                # App entry point, MenuBarExtra setup
    ├── ClipboardStore.swift         # Clipboard monitoring, history persistence
    ├── ClipboardMenuView.swift      # Menu bar dropdown UI
    ├── PasteService.swift           # Cmd+V simulation (Accessibility)
    ├── Info.plist
    └── Assets.xcassets/             # App icon and colors
```

## License

MIT
