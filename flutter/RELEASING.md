# Release Guide — Hidayah Life Flutter App

This guide outlines how to create and distribute official multiplatform releases for the **Hidayah Life Flutter App** (`Android`, `macOS`, and `Windows`).

---

## 1. Automated CI Pipeline (`.github/workflows/release-flutter.yml`)

Releases are completely automated via GitHub Actions:
- **Trigger:** Any Git tag matching `app-v*` (e.g., `app-v1.0.0`).
- **Jobs:**
  1. **Android (`ubuntu-latest`):**
     - Installs Java 17 & Flutter stable.
     - Decodes `ANDROID_KEYSTORE_B64` secret into `android/app/release.keystore`.
     - Executes `flutter build apk --release`.
     - Signs with production keystore credentials.
     - Renames artifact to **`Hidayah-Life-App-Android.apk`**.
  2. **macOS (`macos-latest`):**
     - Installs Flutter stable.
     - Executes `flutter build macos --release`.
     - Compresses `.app` bundle into **`Hidayah-Life-App-macOS.zip`**.
  3. **Windows (`windows-latest`):**
     - Installs NuGet and Flutter stable.
     - Enables Windows desktop support.
     - Executes `flutter build windows --release`.
     - Compresses Release binary folder into **`Hidayah-Life-App-Windows.zip`**.
  4. **Release (`ubuntu-latest`):**
     - Downloads all 3 compiled artifacts.
     - Creates an official GitHub Release with release notes.
     - Attaches the binaries with permanent, stable download links.

---

## 2. Release Steps

### Step 1: Bump Version in `pubspec.yaml`
Open `flutter/pubspec.yaml` and update the version string:
```yaml
version: 1.1.0+2
```

### Step 2: Commit Changes
```bash
git add flutter/
git commit -m "chore: bump flutter app version to 1.1.0"
git push origin main
```

### Step 3: Tag and Push
Create a git tag prefixed with `app-v` and push it:
```bash
git tag app-v1.1.0
git push origin app-v1.1.0
```

---

## 3. GitHub Secrets Required

Ensure the following repository secrets are configured in **GitHub Settings → Secrets and variables → Actions**:
- `ANDROID_KEYSTORE_B64`: Base64 string of `release.keystore`.
- `KEYSTORE_PASSWORD`: Keystore protection password.
- `KEY_ALIAS`: Key alias name (e.g. `hidayah`).
- `KEY_PASSWORD`: Key password.

---

## 4. Stable Download URLs

Users and landing pages can download the latest binaries directly using permanent URLs:
- **Android APK:**
  `https://github.com/itsianisur/Hidayah-Life-Apps/releases/latest/download/Hidayah-Life-App-Android.apk`
- **macOS Bundle:**
  `https://github.com/itsianisur/Hidayah-Life-Apps/releases/latest/download/Hidayah-Life-App-macOS.zip`
- **Windows Bundle:**
  `https://github.com/itsianisur/Hidayah-Life-Apps/releases/latest/download/Hidayah-Life-App-Windows.zip`
