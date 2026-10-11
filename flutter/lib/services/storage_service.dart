import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prayer_times_data.dart';

class StorageService {
  static const String _keyMethod = 'hidayah_calc_method';
  static const String _keyNotifications = 'hidayah_notifications_enabled';
  static const String _keyLanguage = 'hidayah_language';
  static const String _keyCachedTimes = 'hidayah_cached_prayer_times';
  static const String _keyLastFetchDate = 'hidayah_last_fetch_date';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Calculation Method (default: 1 = Karachi)
  static int getMethod() {
    return _prefs?.getInt(_keyMethod) ?? 1;
  }

  static Future<void> setMethod(int methodId) async {
    await _prefs?.setInt(_keyMethod, methodId);
  }

  // Notifications (default: true)
  static bool getNotificationsEnabled() {
    return _prefs?.getBool(_keyNotifications) ?? true;
  }

  static Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs?.setBool(_keyNotifications, enabled);
  }

  // Language (default: 'bn' = Bangla)
  static String getLanguage() {
    return _prefs?.getString(_keyLanguage) ?? 'bn';
  }

  static Future<void> setLanguage(String lang) async {
    await _prefs?.setString(_keyLanguage, lang);
  }

  // Cached Prayer Times
  static PrayerTimesData? getCachedPrayerTimes() {
    final raw = _prefs?.getString(_keyCachedTimes);
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return PrayerTimesData.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveCachedPrayerTimes(PrayerTimesData data) async {
    final raw = jsonEncode(data.toJson());
    await _prefs?.setString(_keyCachedTimes, raw);
    await _prefs?.setString(
      _keyLastFetchDate,
      DateTime.now().toIso8601String().substring(0, 10),
    );
  }

  static String? getLastFetchDate() {
    return _prefs?.getString(_keyLastFetchDate);
  }
}
