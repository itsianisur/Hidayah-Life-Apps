# Hidayah Life Apps — Releasing Guide

This document describes how to generate releases for **macOS (.dmg)**, **Windows (.exe)**, and **Android (.apk)** using automated GitHub Actions CI/CD workflows and free distribution via GitHub Releases.

---

## 1. One-Time Setup: Android Keystore & GitHub Secrets

Because the Android APK is distributed as a direct sideloaded `.apk` (no Google Play Store account or paid signing certificate), you can use a self-signed release keystore.

### Step 1.1: Generate a Keystore Locally
Run the standard Java `keytool` command in your terminal:

```bash
keytool -genkeypair -v \
  -keystore hidayah-release.keystore \
  -alias hidayahlife \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```
- Set a secure keystore password (e.g. `YourSecretPassphrase123`).
- Enter the organization information (e.g., `CN=Hidayah Life, O=Hidayah, C=BD`).

### Step 1.2: Encode Keystore to Base64
Run:
- **macOS / Linux:**
  ```bash
  base64 -i hidayah-release.keystore | pbcopy # or base64 -w 0 on Linux
  ```
- **Windows (PowerShell):**
  ```powershell
  [Convert]::ToBase64String([IO.File]::ReadAllBytes("hidayah-release.keystore")) | Set-Clipboard
  ```

### Step 1.3: Add GitHub Repository Secrets
Go to your GitHub repository:
**Settings → Secrets and variables → Actions → New repository secret**

Add the following 4 secrets:

| Secret Name | Description | Example Value |
|---|---|---|
| `ANDROID_KEYSTORE_B64` | The entire base64 string of `hidayah-release.keystore` | `MIIDvTCCAqW...` |
| `KEYSTORE_PASSWORD` | The password you entered during key generation | `YourSecretPassphrase123` |
| `KEY_ALIAS` | The alias used in the keytool command | `hidayahlife` |
| `KEY_PASSWORD` | The key password (usually the same as keystore password) | `YourSecretPassphrase123` |

---

## 2. Release Steps for a New Version

When you are ready to publish a new release (e.g., `v1.0.0` or `v1.0.1`):

### Step 2.1: Version Bump
Update the version strings across the projects:

1. **Desktop App:**
   In `desktop/package.json`:
   ```json
   "version": "1.0.1"
   ```

2. **Mobile App:**
   In `mobile/package.json`:
   ```json
   "version": "1.0.1"
   ```
   In `mobile/android/app/build.gradle`:
   ```groovy
   versionCode 2       // increment integer by 1
   versionName "1.0.1" // match semantic version
   ```

3. **Download Page Config:**
   Update `APP_DOWNLOAD_CONFIG.version` in `lib/app-download.ts` to `"1.0.1"`.

### Step 2.2: Commit and Tag
```bash
git add .
git commit -m "chore(release): bump version to v1.0.1"
git tag v1.0.1
git push origin main
git push origin v1.0.1
```

### Step 2.3: Automated Build Pipeline
Pushing the `v*` tag triggers the GitHub Actions workflow in `.github/workflows/release.yml`:
1. **`macos` runner:** Builds `Hidayah-Life-macOS.dmg` (Universal binary for Intel & Apple Silicon).
2. **`windows` runner:** Builds `Hidayah-Life-Windows-Setup.exe` (NSIS per-user installer).
3. **`android` runner:** Builds and signs `Hidayah-Life-Android.apk` with the keystore.
4. **`release` runner:** Aggregates all 3 installers and creates the GitHub Release tagged `v1.0.1` with stable asset names.

---

## 3. Permanent Download Links

Because the filenames are guaranteed stable across all releases:
- macOS: `https://github.com/<OWNER>/hidayah-life-apps/releases/latest/download/Hidayah-Life-macOS.dmg`
- Windows: `https://github.com/<OWNER>/hidayah-life-apps/releases/latest/download/Hidayah-Life-Windows-Setup.exe`
- Android: `https://github.com/<OWNER>/hidayah-life-apps/releases/latest/download/Hidayah-Life-Android.apk`

Users visiting `hidayahlife.com/download` always receive the newest release automatically without modifying download URLs!
