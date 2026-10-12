import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ignore: unnecessary_import
import 'package:flutter_local_notifications_windows/flutter_local_notifications_windows.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/prayer_times_data.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final List<Timer> _windowsTimers = [];
  bool _isInitialized = false;

  // The 5 daily prayers for notifications with exact Bangla bodies as requested
  static const Map<String, Map<String, dynamic>> prayerNotificationConfig = {
    'Fajr': {
      'id': 101,
      'body': 'এখন ফজরের সময়',
    },
    'Dhuhr': {
      'id': 102,
      'body': 'এখন যোহরের সময়',
    },
    'Asr': {
      'id': 103,
      'body': 'এখন আসরের সময়',
    },
    'Maghrib': {
      'id': 104,
      'body': 'এখন মাগরিবের সময়',
    },
    'Isha': {
      'id': 105,
      'body': 'এখন এশার সময়',
    },
  };

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();
      final String timeZoneName = DateTime.now().timeZoneName;
      try {
        tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));
      } catch (_) {
        try {
          tz.setLocalLocation(tz.getLocation(timeZoneName));
        } catch (_) {
          // Fallback to UTC or default location
        }
      }

      if (kIsWeb) return;

      if (Platform.isAndroid ||
          Platform.isMacOS ||
          Platform.isIOS ||
          Platform.isWindows) {
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');

        const DarwinInitializationSettings initializationSettingsDarwin =
            DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

        const WindowsInitializationSettings initializationSettingsWindows =
            WindowsInitializationSettings(
          appName: 'Hidayah Life',
          appUserModelId: 'com.hidayahlife.app',
          guid: '47F06953-D83E-40A4-AFCF-B320EC2D3FB8',
        );

        const InitializationSettings initializationSettings =
            InitializationSettings(
          android: initializationSettingsAndroid,
          macOS: initializationSettingsDarwin,
          iOS: initializationSettingsDarwin,
          windows: initializationSettingsWindows,
        );

        await _flutterLocalNotificationsPlugin.initialize(
          settings: initializationSettings,
        );

        // Request permissions on Android 13+
        if (Platform.isAndroid) {
          final androidPlugin = _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();
          await androidPlugin?.requestNotificationsPermission();
          await androidPlugin?.requestExactAlarmsPermission();
        }
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('[NotificationService] Init error: $e');
    }
  }

  Future<void> schedulePrayerNotifications(PrayerTimesData data) async {
    await cancelAllNotifications();

    final now = DateTime.now();

    for (final entry in prayerNotificationConfig.entries) {
      final prayerKey = entry.key;
      final config = entry.value;
      final int id = config['id'] as int;
      final String body = config['body'] as String;

      final prayerEntry =
          data.allEntries.firstWhere((p) => p.key == prayerKey);
      final parts = prayerEntry.time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      var scheduleTime = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
        0,
      );

      // If prayer time today has already passed, schedule for tomorrow
      if (scheduleTime.isBefore(now)) {
        scheduleTime = scheduleTime.add(const Duration(days: 1));
      }

      await _scheduleSingleNotification(
        id: id,
        title: 'Hidayah Life',
        body: body,
        scheduledDate: scheduleTime,
      );
    }
  }

  Future<void> _scheduleSingleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    try {
      if (kIsWeb) return;

      if (Platform.isWindows) {
        // Windows schedule via timer
        final delay = scheduledDate.difference(DateTime.now());
        if (delay.isNegative) return;

        final timer = Timer(delay, () async {
          await _flutterLocalNotificationsPlugin.show(
            id: id,
            title: title,
            body: body,
            notificationDetails: const NotificationDetails(),
          );
        });
        _windowsTimers.add(timer);
      } else {
        final tzScheduled = tz.TZDateTime.from(scheduledDate, tz.local);

        const AndroidNotificationDetails androidDetails =
            AndroidNotificationDetails(
          'hidayah_prayer_channel',
          'নামাজের সময়সূচি (Prayer Times)',
          channelDescription: 'Alerts at each prayer time',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        );

        const DarwinNotificationDetails darwinDetails =
            DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

        const NotificationDetails platformDetails = NotificationDetails(
          android: androidDetails,
          macOS: darwinDetails,
          iOS: darwinDetails,
        );

        await _flutterLocalNotificationsPlugin.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: tzScheduled,
          notificationDetails: platformDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    } catch (e) {
      debugPrint('[NotificationService] Error scheduling notification $id: $e');
    }
  }

  // Test Notification: Instant
  Future<void> showInstantTestNotification() async {
    try {
      if (kIsWeb) return;

      if (Platform.isWindows) {
        await _flutterLocalNotificationsPlugin.show(
          id: 999,
          title: 'Hidayah Life',
          body: 'টেস্ট নোটিফিকেশন: নামাজের সময়সূচি নোটিফিকেশন সক্রিয় রয়েছে।',
          notificationDetails: const NotificationDetails(),
        );
      } else {
        const AndroidNotificationDetails androidDetails =
            AndroidNotificationDetails(
          'hidayah_test_channel',
          'টেস্ট নোটিফিকেশন (Test Alerts)',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

        const DarwinNotificationDetails darwinDetails =
            DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

        const NotificationDetails platformDetails = NotificationDetails(
          android: androidDetails,
          macOS: darwinDetails,
          iOS: darwinDetails,
        );

        await _flutterLocalNotificationsPlugin.show(
          id: 999,
          title: 'Hidayah Life',
          body: 'টেস্ট নোটিফিকেশন: নামাজের সময়সূচি নোটিফিকেশন সক্রিয় রয়েছে।',
          notificationDetails: platformDetails,
        );
      }
    } catch (e) {
      debugPrint('[NotificationService] Test alert error: $e');
    }
  }

  // Test Notification: Scheduled 2 minutes ahead (as requested for manual test)
  Future<void> scheduleTwoMinuteTestAlert() async {
    final target = DateTime.now().add(const Duration(minutes: 2));
    await _scheduleSingleNotification(
      id: 998,
      title: 'Hidayah Life',
      body: 'টেস্ট নোটিফিকেশন (২ মিনিট পূর্বনির্ধারিত): নামাজের সময়সূচি সফলভাবে কাজ করছে।',
      scheduledDate: target,
    );
  }

  Future<void> cancelAllNotifications() async {
    for (final timer in _windowsTimers) {
      timer.cancel();
    }
    _windowsTimers.clear();

    if (!kIsWeb) {
      await _flutterLocalNotificationsPlugin.cancelAll();
    }
  }
}
