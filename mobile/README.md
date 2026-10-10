# Hidayah Life Android App

Native Android wrapper for [Hidayah Life](https://hidayahlife.com) powered by [Capacitor](https://capacitorjs.com/).

## Features
- **Always Up-to-Date:** Connects seamlessly to the live platform (`https://hidayahlife.com`).
- **5 Daily Prayer Notifications:** Automatically fetches timings from Aladhan API (Dhaka, Bangladesh, Karachi method) on boot and schedules local alerts in Bangla:
  - ফজরের সময়: "এখন ফজরের সময়"
  - যোহরের সময়: "এখন যোহরের সময়"
  - আসরের সময়: "এখন আসরের সময়"
  - মাগরিবের সময়: "এখন মাগরিবের সময়"
  - এশার সময়: "এখন এশার সময়"
- **Offline Resilient:** Retries automatically every 15 minutes if network is initially unavailable; never crashes.
- **Deep Emerald Branding:** Adaptive launcher icon and `#041A13` dark emerald launch screen.

---

## Local Development & Setup

### Prerequisites
- Node.js 18+ and npm
- Java JDK 17 (or 21)
- Android Studio with Android SDK (API 34)

### 1. Install Dependencies
```bash
cd mobile
npm install
```

### 2. Sync Web Assets to Android Project
Whenever web assets or configs are updated:
```bash
npx cap sync android
```

### 3. Open in Android Studio
```bash
npx cap open android
```
From Android Studio, click **Run** (green triangle) to launch on an Android emulator or connected device.

---

## Building APK Locally

### Debug APK
From the `mobile/android` directory:
```bash
cd android
./gradlew assembleDebug
```
The output will be generated at:
`mobile/android/app/build/outputs/apk/debug/app-debug.apk`

### Unsigned Release APK
```bash
cd android
./gradlew assembleRelease
```
The output will be at:
`mobile/android/app/build/outputs/apk/release/app-release-unsigned.apk`

---

## Automated CI/CD & Keystore Signing
Production release APKs are automatically built and signed via GitHub Actions (`.github/workflows/release.yml`) whenever a new git tag (`v*`) is pushed. See `RELEASING.md` in the root repository for step-by-step instructions.
