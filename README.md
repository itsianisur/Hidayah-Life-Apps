# Hidayah Life Apps (Desktop & Mobile)

Free downloadable apps for [Hidayah Life](https://hidayahlife.com) across **macOS**, **Windows**, and **Android**, distributed freely via GitHub Releases.

---

## Repository Structure

```
hidayah-life-apps/
├── desktop/                    # Electron — macOS (.dmg) + Windows (.exe)
│   ├── assets/                 # App icons (1024x1024 & vector SVG)
│   ├── electron-builder.yml    # Build & installer packaging configuration
│   ├── main.js                 # Electron main process & prayer alert engine
│   ├── preload.js              # Minimal context-isolated preload script
│   └── package.json
│
├── mobile/                     # Capacitor — Android (.apk)
│   ├── android/                # Native Android Studio / Gradle project
│   ├── assets/                 # High-resolution icons & adaptive assets
│   ├── capacitor.config.ts     # Capacitor configuration
│   ├── www/                    # Native wrapper & prayer alert scheduler
│   └── package.json
│
├── .github/
│   └── workflows/
│       └── release.yml         # GitHub Actions pipeline building all 3 platforms
│
├── RELEASING.md                # Step-by-step tag release & keystore guide
└── README.md
```

---

## Key Features

1. **Dedicated Native Environment:** Runs Hidayah Life in a focused, clutter-free desktop window or full-screen mobile app.
2. **Native Prayer-Time Notifications:** Automatically fetches daily prayer times from the Aladhan API (Dhaka / Bangladesh / Karachi method) and fires native notifications in Bangla for the 5 daily prayers (Fajr, Dhuhr, Asr, Maghrib, Isha).
3. **Always Up-to-Date:** Seamlessly wraps the live web platform (`https://hidayahlife.com`), ensuring users always experience the latest features and content.
4. **Offline Resilience:** If network connectivity is lost on app startup, the prayer scheduling engine retries every 15 minutes gracefully without crashing.
5. **Zero Store Restrictions:** Distributed directly and freely via GitHub Releases (no paid Apple Developer $99/year or Google Play $25 accounts required).

---

## Stable Download Artifacts

Each release published via `.github/workflows/release.yml` produces predictable, permanent download links:

| Platform | Installer Type | Stable Download URL |
|---|---|---|
| **macOS** | Universal DMG (Apple Silicon & Intel) | `https://github.com/<OWNER>/hidayah-life-apps/releases/latest/download/Hidayah-Life-macOS.dmg` |
| **Windows** | NSIS Per-User Installer | `https://github.com/<OWNER>/hidayah-life-apps/releases/latest/download/Hidayah-Life-Windows-Setup.exe` |
| **Android** | Sideloadable APK | `https://github.com/<OWNER>/hidayah-life-apps/releases/latest/download/Hidayah-Life-Android.apk` |

---

## Quick Start

### Developing Desktop (Electron)
```bash
cd desktop
npm install
npm start
```

### Developing Mobile (Android / Capacitor)
```bash
cd mobile
npm install
npx cap sync android
npx cap open android
```

### Publishing Releases
Refer to [RELEASING.md](./RELEASING.md) for details on tag-driven CI/CD and self-signed Android keystore configuration.
