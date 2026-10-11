import 'package:flutter_test/flutter_test.dart';
import 'package:hidayah_life/models/prayer_times_data.dart';
import 'package:hidayah_life/constants/app_strings.dart';

void main() {
  test('PrayerTimesData dhakaFallback initializes valid prayer times', () {
    final fallback = PrayerTimesData.dhakaFallback();
    expect(fallback.fajr, '04:39');
    expect(fallback.allEntries.length, 6);

    final nextPrayer = fallback.getNextPrayer(DateTime.now());
    expect(nextPrayer.prayer.nameBn.isNotEmpty, true);
    expect(nextPrayer.timeRemaining.inSeconds, isNotNull);
  });

  test('Bangla number formatting works correctly', () {
    expect(AppStrings.toBanglaNumber('0123456789'), '০১২৩৪৫৬৭৮৯');
    expect(AppStrings.toBanglaNumber('10:45 AM'), '১০:৪৫ AM');
  });
}
