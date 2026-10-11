import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/prayer_times_data.dart';
import 'storage_service.dart';
import 'notification_service.dart';

// ============================================================================
// Service Constants (Top of file as specified)
// ============================================================================
const String CITY = "Dhaka";
const String COUNTRY = "Bangladesh";
const int METHOD = 1; // 1 = University of Islamic Sciences, Karachi (Hanafi)

class PrayerService {
  static final PrayerService _instance = PrayerService._internal();
  factory PrayerService() => _instance;
  PrayerService._internal();

  PrayerTimesData? _currentData;
  bool _isLoading = false;
  bool _isOffline = false;
  Timer? _midnightTimer;
  Timer? _retryTimer;

  final _streamController = StreamController<PrayerTimesData>.broadcast();
  Stream<PrayerTimesData> get prayerTimesStream => _streamController.stream;

  PrayerTimesData? get currentData => _currentData;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;

  Future<void> init() async {
    // 1. Immediately load cached data so screen is never blank
    final cached = StorageService.getCachedPrayerTimes();
    if (cached != null) {
      _currentData = cached;
      _streamController.add(cached);
    } else {
      _currentData = PrayerTimesData.dhakaFallback();
      _streamController.add(_currentData!);
    }

    // 2. Fetch fresh times from API
    await fetchPrayerTimes();

    // 3. Schedule next midnight refresh
    _scheduleMidnightCheck();
  }

  Future<PrayerTimesData> fetchPrayerTimes({int? methodOverride}) async {
    _isLoading = true;
    final activeMethod = methodOverride ?? StorageService.getMethod();

    final url = Uri.parse(
      'https://api.aladhan.com/v1/timingsByCity?city=$CITY&country=$COUNTRY&method=$activeMethod',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['code'] == 200 && body['data'] != null) {
          final data = PrayerTimesData.fromAladhan(body);
          _currentData = data;
          _isOffline = false;
          await StorageService.saveCachedPrayerTimes(data);

          // Cancel any active retry timer on success
          _retryTimer?.cancel();
          _retryTimer = null;

          _streamController.add(data);

          // Reschedule local notifications for today's prayers
          if (StorageService.getNotificationsEnabled()) {
            await NotificationService().schedulePrayerNotifications(data);
          }

          _isLoading = false;
          return data;
        }
      }
      throw Exception('Invalid response: ${response.statusCode}');
    } catch (e) {
      debugPrint('[PrayerService] Network error fetching prayer times: $e');
      _isOffline = true;

      // Ensure we have at least cached or fallback data
      if (_currentData == null) {
        final cached = StorageService.getCachedPrayerTimes();
        _currentData = cached ?? PrayerTimesData.dhakaFallback();
        _streamController.add(_currentData!);
      }

      // Schedule retry in 15 minutes as requested
      _scheduleRetry();

      _isLoading = false;
      return _currentData!;
    }
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();
    _retryTimer = Timer(const Duration(minutes: 15), () {
      debugPrint('[PrayerService] 15-minute retry triggering...');
      fetchPrayerTimes();
    });
  }

  void _scheduleMidnightCheck() {
    _midnightTimer?.cancel();
    final now = DateTime.now();
    // Schedule for 00:01 AM tomorrow
    final tomorrowMidnight = DateTime(
      now.year,
      now.month,
      now.day + 1,
      0,
      1,
      0,
    );
    final delay = tomorrowMidnight.difference(now);

    _midnightTimer = Timer(delay, () {
      debugPrint('[PrayerService] Midnight check triggered, fetching times...');
      fetchPrayerTimes();
      _scheduleMidnightCheck();
    });
  }

  void dispose() {
    _midnightTimer?.cancel();
    _retryTimer?.cancel();
    _streamController.close();
  }
}
