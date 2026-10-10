# Hidayah Life Desktop App (macOS & Windows)

Native desktop wrapper for [Hidayah Life](https://hidayahlife.com) built with [Electron](https://www.electronjs.org/).

## Features
- **Dedicated Native Window:** 1280×800 window loading `https://hidayahlife.com` with dark brand styling.
- **Native Prayer-Time Notifications:** Automatically queries the Aladhan API (Dhaka / Bangladesh / Karachi method) and fires native OS notifications for the 5 daily prayers (Fajr, Dhuhr, Asr, Maghrib, Isha) in Bangla.
- **Notification Controls:** Toggle notifications on/off via the app menu bar (`Notifications → Prayer alerts`). State is persisted locally.
- **Offline Resilient:** If the computer is offline on boot or the API is unavailable, it automatically retries every 15 minutes without crashing.
- **External Links Handling:** Links with `target="_blank"` or external URLs open in your system default web browser.
- **Single Instance:** Multiple launches bring the existing window to focus.

---

## Local Development

### 1. Installation
Navigate into the `desktop/` directory and install dependencies:
```bash
cd desktop
npm install
```

### 2. Run App Locally
```bash
npm start
```

### 3. Testing Prayer Notifications
You can test the notification mechanism in two ways:
1. **Via the Menu Bar:**
   - Click `Notifications` in the menu bar.
   - Click `Test notification now` to immediately see a native notification.
   - Click `Test notification in 2 minutes` to schedule an alert 2 minutes ahead and verify background firing.
2. **Programmatic test in `main.js`:**
   Temporarily add this inside `app.whenReady()`:
   ```javascript
   setTimeout(() => {
     triggerPrayerNotification('Hidayah Life', 'টেস্ট নোটিফিকেশন: আযান ও নামাজের সময় হয়েছে।');
   }, 5000); // triggers after 5 seconds
   ```

---

## Building Installers

### macOS (`.dmg`)
```bash
npm run dist:mac
```
Generates universal binary (`x64` + `arm64` Apple Silicon) installer at `dist/Hidayah-Life-macOS.dmg`.

### Windows (`.exe` NSIS Installer)
```bash
npm run dist:win
```
Generates per-user setup installer at `dist/Hidayah-Life-Windows-Setup.exe`.

### Build All Supported Targets
```bash
npm run dist
```

---

## Code Signing & Gatekeeper Notes
This project is distributed completely free under open-source licenses via GitHub Releases without paid Apple ($99/year) or Windows ($200+/year) developer certificates.

- **macOS:** Users will see the standard Gatekeeper warning on first launch. To open: Right-click the app in `/Applications` → click **Open** → Confirm **Open**, or go to **System Settings → Privacy & Security → Open Anyway**.
- **Windows:** Microsoft SmartScreen will display "Windows protected your PC". Click **More info** → **Run anyway**.
