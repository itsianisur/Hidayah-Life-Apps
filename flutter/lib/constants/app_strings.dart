class AppStrings {
  static const Map<String, Map<String, String>> localized = {
    'bn': {
      'appName': 'হেদায়েত লাইফ',
      'prayerTimes': 'নামাজের সময়সূচি',
      'salahGuide': 'নামাজ শিক্ষা',
      'duasAndSurahs': 'দোয়া ও সূরা',
      'platform': 'ওয়েবসাইট',
      'settings': 'সেটিংস',
      'nextPrayer': 'পরবর্তী নামাজ',
      'remaining': 'বাকি আছে',
      'in': 'আর',
      'fajr': 'ফজর',
      'sunrise': 'সূর্যোদয়',
      'dhuhr': 'যোহর',
      'asr': 'আসর',
      'maghrib': 'মাগরিব',
      'isha': 'এশা',
      'fajrDesc': 'ভোরের নামাজ',
      'sunriseDesc': 'সূর্য ওঠার সময় (নফল নিষেধ)',
      'dhuhrDesc': 'দুপুরের নামাজ',
      'asrDesc': 'বিকেলের নামাজ',
      'maghribDesc': 'সন্ধ্যার নামাজ',
      'ishaDesc': 'রাতের নামাজ',
      'calculationMethod': 'হিসাব পদ্ধতি',
      'notifications': 'নামাজের নোটিফিকেশন',
      'notificationsDesc': 'প্রতিটি ওয়াক্ত শুরু হলে নোটিফিকেশন দিন',
      'language': 'ভাষা',
      'languageBn': 'বাংলা',
      'languageEn': 'English',
      'testNotification': 'টেস্ট নোটিফিকেশন পাঠান',
      'testNotificationDesc': 'নোটিফিকেশন কাজ করছে কিনা যাচাই করতে ক্লিক করুন',
      'testNotificationSent': 'টেস্ট নোটিফিকেশন পাঠানো হয়েছে!',
      'testNotificationScheduled': '২ মিনিট পর টেস্ট নোটিফিকেশন নির্ধারিত হয়েছে!',
      'offlineMode': 'অফলাইন মোড (সংরক্ষিত সময়সূচি)',
      'syncSuccess': 'সর্বশেষ তথ্য আপডেট হয়েছে',
      'refresh': 'রিফ্রেশ',
      'openInBrowser': 'ব্রাউজারে খুলুন',
      'platformDesc': 'সম্পূর্ণ বিনামূল্যে ইসলামিক শিক্ষা ও সোশ্যাল নেটওয়ার্কিং প্ল্যাটফর্ম',
      'now': 'এখন',
      'timePassed': 'ওয়াক্ত চলছে',
      'aboutApp': 'অ্যাপ সম্পর্কিত',
      'version': 'ভার্সন',
      'dhakaBangladesh': 'ঢাকা, বাংলাদেশ',
    },
    'en': {
      'appName': 'Hidayah Life',
      'prayerTimes': 'Prayer Times',
      'salahGuide': 'Salah Guide',
      'duasAndSurahs': 'Dua & Surah',
      'platform': 'Platform',
      'settings': 'Settings',
      'nextPrayer': 'Next Prayer',
      'remaining': 'Remaining',
      'in': 'in',
      'fajr': 'Fajr',
      'sunrise': 'Sunrise',
      'dhuhr': 'Dhuhr',
      'asr': 'Asr',
      'maghrib': 'Maghrib',
      'isha': 'Isha',
      'fajrDesc': 'Dawn prayer',
      'sunriseDesc': 'Sunrise (prohibited for prayer)',
      'dhuhrDesc': 'Noon prayer',
      'asrDesc': 'Afternoon prayer',
      'maghribDesc': 'Sunset prayer',
      'ishaDesc': 'Night prayer',
      'calculationMethod': 'Calculation Method',
      'notifications': 'Prayer Notifications',
      'notificationsDesc': 'Receive alert at each prayer time',
      'language': 'Language',
      'languageBn': 'বাংলা',
      'languageEn': 'English',
      'testNotification': 'Send Test Notification',
      'testNotificationDesc': 'Trigger an alert now or in 2 minutes to verify',
      'testNotificationSent': 'Test notification sent!',
      'testNotificationScheduled': 'Test notification scheduled in 2 minutes!',
      'offlineMode': 'Offline Mode (Cached Times)',
      'syncSuccess': 'Updated successfully',
      'refresh': 'Refresh',
      'openInBrowser': 'Open in Browser',
      'platformDesc': 'Free-forever Islamic learning & networking platform',
      'now': 'Now',
      'timePassed': 'In Progress',
      'aboutApp': 'About App',
      'version': 'Version',
      'dhakaBangladesh': 'Dhaka, Bangladesh',
    },
  };

  static String get(String key, String lang) {
    return localized[lang]?[key] ?? localized['bn']?[key] ?? key;
  }

  static String toBanglaNumber(String input) {
    const englishToBangla = {
      '0': '০',
      '1': '১',
      '2': '২',
      '3': '৩',
      '4': '৪',
      '5': '৫',
      '6': '৬',
      '7': '৭',
      '8': '৮',
      '9': '৯',
    };
    String result = input;
    englishToBangla.forEach((en, bn) {
      result = result.replaceAll(en, bn);
    });
    return result;
  }

  static String formatCountdown(Duration duration, String lang) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final raw =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return lang == 'bn' ? toBanglaNumber(raw) : raw;
  }

  static String formatPrayerTime(String time24, String lang) {
    // Converts "04:39" to 12-hour formatted "4:39 AM" or "৪:৩৯ AM / ভোর ৪:৩৯"
    try {
      final parts = time24.split(':');
      int hour = int.parse(parts[0]);
      final minute = parts[1];
      final isPm = hour >= 12;
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;

      final period = isPm ? 'PM' : 'AM';
      final formatted = '$hour:$minute $period';
      return lang == 'bn' ? toBanglaNumber(formatted) : formatted;
    } catch (_) {
      return lang == 'bn' ? toBanglaNumber(time24) : time24;
    }
  }
}
