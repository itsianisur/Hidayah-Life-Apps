# Hidayah Life Flutter App (Phase 1: Prayer Times)

Real native multiplatform application for **Android**, **macOS**, and **Windows**, built with [Flutter](https://flutter.dev).

---

## Brand & UI Design
- **Theme:** Emerald & Islamic Gold with a deep dark background default (`#041A13`, `#0A261D`, `#0E3327`, Gold `#D4A03E`, `#FBBF24`).
- **Bangla-First Typography:** Bundled **Hind Siliguri** font (Regular, Medium, SemiBold, Bold) with native Bengali numeral conversion (`০`, `১`, `২`, `৩`, ...). English secondary toggle available in Settings.
- **Iconography:** Tailored Islamic icons and launcher icons generated from a high-resolution 1024×1024 emerald/gold artwork.

---

## Features (Phase 1)

### 1. Prayer Times Home Screen
Inspired by `tareq1988/prayer-times-macos`:
- **Live Countdown Ticker:** Counts down to the next prayer, updating every second (e.g. `ফজর শুরু হতে বাকি ০২:০৮:২৫` or `Fajr in 02:08:25`).
- **6 Daily Times Panel:** Displays Fajr (ফজর), Sunrise (সূর্যোদয়), Dhuhr (যোহর), Asr (আসর), Maghrib (মাগরিব), and Isha (এশা).
- **Prominent Next Prayer Highlighting:** The upcoming prayer card is highlighted with gold borders, glowing gradients, and a "পরবর্তী" / "NEXT" badge.
- **Dual Date Header:** Displays both Gregorian date and Hijri Islamic date (e.g., `সোমবার, ১২ অক্টোবর ২০২৬ / ১ জুমাদাল উলা ১৪৪৮ হিজরি`).
- **Aladhan API Integration:** Fetches accurate timings from `https://api.aladhan.com/v1/timingsByCity` using constants:
  - `CITY = "Dhaka"`
  - `COUNTRY = "Bangladesh"`
  - `METHOD = 1` (University of Islamic Sciences, Karachi - Hanafi)

### 2. Offline Resilience & Reliability
- **Midnight Daily Refetch:** A background timer automatically fetches the new day's prayer times at 00:01 AM.
- **Offline Caching:** Times are cached locally via `shared_preferences`. On launch or offline mode (airplane mode), cached times load instantly.
- **15-Minute Retry:** If offline at launch or during a network failure, the service automatically retries in 15 minutes.
- **Dhaka Built-in Fallback:** The app never crashes and never shows a blank screen, even on a fresh offline install.

### 3. Native Local Notifications
- **Per-Prayer Alerts:** Scheduled for all 5 daily waqts (Fajr, Dhuhr, Asr, Maghrib, Isha) with Bangla alert bodies:
  - Fajr: `"এখন ফজরের সময়"`
  - Dhuhr: `"এখন যোহরের সময়"`
  - Asr: `"এখন আসরের সময়"`
  - Maghrib: `"এখন মাগরিবের সময়"`
  - Isha: `"এখন এশার সময়"`
- **Cross-Platform:**
  - **Android & macOS:** `flutter_local_notifications` with high priority channels.
  - **Windows:** Native desktop toast notifications powered by `local_notifier`.
- **Persistent Toggle:** Notification enable/disable switch persisted across restarts.

### 4. Settings Screen
- **Calculation Method Picker:**
  - 1: Karachi (University of Islamic Sciences, Karachi - Hanafi) [Default]
  - 2: ISNA (Islamic Society of North America)
  - 3: Muslim World League (MWL)
  - 4: Umm al-Qura University, Makkah
  - 5: Egyptian General Authority of Survey
  - 13: Diyanet (Presidency of Religious Affairs, Turkey)
  - 14: Moonsighting Committee Worldwide
- **Language Picker:** Bangla (বাংলা - Default) / English (with numeral format switching).
- **Manual Notification Test Actions:** Trigger instant alerts or 2-minute delayed alerts.

### 5. In-App Platform WebView Tab
- Bottom Navigation Bar with 2 tabs:
  - **নামাজের সময়সূচি (Prayer Times)**
  - **ওয়েবসাইট (Platform)**
- Loads `https://hidayah-life.vercel.app` inside an in-app webview (`flutter_inappwebview`) with state preservation (`IndexedStack`), loading progress bar, reload button, and external browser launcher fallback.

---

## Manual Notification Test (Step-by-Step)

To verify that background notifications are functioning properly on your device:

1. Open **Hidayah Life**.
2. Tap the **Settings (⚙️)** icon in the top right of the Prayer Times tab.
3. Ensure **Prayer Notifications (নামাজের নোটিফিকেশন)** toggle is **ON**.
4. Tap **"Send Test Notification" (পাঠান)** to verify immediate notification delivery.
5. Tap **"Test Alert (in 2 minutes)" (নির্ধারণ)**:
   - A confirmation toast will display: `"২ মিনিট পর টেস্ট নোটিফিকেশন নির্ধারিত হয়েছে!"`.
   - Press the device home button and **lock your screen**.
   - Wait **2 minutes**.
   - Your device will vibrate/ring and show:
     ```
     Hidayah Life
     টেস্ট নোটিফিকেশন (২ মিনিট পূর্বনির্ধারিত): নামাজের সময়সূচি সফলভাবে কাজ করছে।
     ```

---

## App Identity & Compatibility
- **Application ID (Android):** `com.hidayahlife.app`
- **Bundle Identifier (macOS):** `com.hidayahlife.app`
- **Windows Executable:** `Hidayah Life.exe`
- Uses the same keystore and bundle identifier as the previous wrapper releases, enabling direct in-place updates.

---

## Development & Testing

```bash
# Get dependencies
flutter pub get

# Run static analysis
flutter analyze

# Run unit tests
flutter test test/widget_test.dart

# Run on macOS
flutter run -d macos

# Run on Android
flutter run -d android

# Run on Windows
flutter run -d windows
```
