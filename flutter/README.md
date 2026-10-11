# Hidayah Life Flutter App (Phase 1 & 2)

Real native multiplatform application for **Android**, **macOS**, and **Windows**, built with [Flutter](https://flutter.dev).

---

## Brand & UI Design
- **Theme:** Emerald & Islamic Gold with a deep dark background default (`#041A13`, `#0A261D`, `#0E3327`, Gold `#D4A03E`, `#FBBF24`).
- **Bangla & Arabic Typography:**
  - Bundled **Hind Siliguri** font (Regular, Medium, SemiBold, Bold) with native Bengali numeral conversion (`০`, `১`, `২`, `৩`, ...).
  - Bundled **Amiri** font (Regular, Bold) for large, authentic Arabic scripture rendering.
- **Iconography:** Tailored Islamic icons and launcher icons generated from a high-resolution 1024×1024 emerald/gold artwork.

---

## Features

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
- **Offline Resilience:** Cached locally via `shared_preferences`, midnight auto-refresh, 15-minute retry if offline, and built-in Dhaka fallback.

### 2. Dua & Surah Reader (100% Offline — Phase 2)
Dedicated offline section with **22 verified items** from the Hidayah Life library:
- **Categories:**
  - ছোট সূরা (12 Short Surahs: Al-Fatiha, Al-Ikhlas, Al-Falaq, An-Nas, Al-Kawthar, Al-Asr, Al-Kafirun, Al-Masad, An-Nasr, Quraysh, Al-Fil, Al-Maun)
  - দৈনন্দিন দোয়া (Daily Duas: sleep, waking up, eating, morning)
  - রাব্বানা দোয়া (Rabbana Duas from the Quran)
  - দরুদ শরীফ (Dorud-e-Ibrahim & Short Dorud)
  - দোয়া কুনুত (Witr Dua-e-Qunut - Hanafi)
  - Hisnul Muslim situational duas
- **Detail View:**
  - Large Arabic scripture using the bundled **Amiri** font.
  - Pronunciation (transliteration) in Bangla.
  - Complete Bangla translation.
  - Virtue (ফজিলত) notes where applicable.
  - Authentic reference / source at the bottom.
  - One-tap **Copy to Clipboard** button.
  - Persistent **Bookmark (Favourite)** toggle.
- **Instant Search & Favourites:**
  - Real-time search across Bangla titles, English names, transliteration, meanings, and references.
  - Filter by category chip or "প্রিয় তালিকা" (Favourites) button.
  - 100% offline with zero network dependencies.

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
- **Calculation Method Picker:** Karachi (Default = 1), ISNA (2), MWL (3), Umm al-Qura (4), Egyptian (5), Diyanet (13), Moonsighting Committee (14).
- **Language Picker:** Bangla (বাংলা - Default) / English (with numeral format switching).
- **Manual Notification Test Actions:** Trigger instant alerts or 2-minute delayed alerts.

### 5. In-App Platform WebView Tab
- Bottom Navigation Bar with 3 tabs:
  - **নামাজের সময়সূচি (Prayer Times)**
  - **দোয়া ও সূরা (Dua & Surah)**
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
