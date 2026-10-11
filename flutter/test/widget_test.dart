import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hidayah_life/models/prayer_times_data.dart';
import 'package:hidayah_life/models/dua_item.dart';
import 'package:hidayah_life/services/dua_service.dart';
import 'package:hidayah_life/constants/app_strings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  test('DuaItem model parses correctly and preserves all fields', () {
    const rawJson = '''
    {
      "slug": "salah-takbir",
      "titleBn": "আল্লাহু আকবার",
      "titleEn": "Opening Takbir",
      "category": "salah",
      "arabic": "اللهُ أَكْبَرُ",
      "transliteration": "Allahu Akbar",
      "translationBn": "আল্লাহ সবচেয়ে বড় — তাঁর সত্তা, নাম ও গুণাবলিতে।",
      "reference": "তাকবীরে তাহরিমা (নামাজ শুরু)",
      "virtueBn": "নামাজের সময়: Opening Takbir",
      "audioUrl": null,
      "reviewed": false
    }
    ''';

    final Map<String, dynamic> map = jsonDecode(rawJson);
    final item = DuaItem.fromJson(map);

    expect(item.slug, 'salah-takbir');
    expect(item.titleBn, 'আল্লাহু আকবার');
    expect(item.category, 'salah');
    expect(item.reviewed, false);
    expect(item.getCategoryTitleBn(), 'নামাজের দোয়া');
  });

  test('DuaService loads bundled duas.json offline and matches item count', () async {
    SharedPreferences.setMockInitialValues({});
    final duaService = DuaService();
    await duaService.init();

    // Verify item count matches total dataset (22 original + 13 Salah Adhkar = 35)
    expect(duaService.allDuas.length, 35);

    // Verify Salah Adhkar category has 13 items
    final salahItems = duaService.filter(categoryKey: 'salah');
    expect(salahItems.length, 13);
    expect(salahItems.first.titleBn, 'আল্লাহু আকবার');

    // Verify search finds Salah item by Bangla title
    final rukuResults = duaService.filter(searchQuery: 'আযীম');
    expect(rukuResults.isNotEmpty, true);
    expect(rukuResults.first.slug, 'salah-ruku');

    // Verify search finds items by English title
    final takbirResults = duaService.filter(searchQuery: 'Takbir');
    expect(takbirResults.isNotEmpty, true);
    expect(takbirResults.first.slug, 'salah-takbir');

    // Verify Surahs still exist
    final surahs = duaService.filter(categoryKey: 'surah');
    expect(surahs.length, 12);

    // Verify favourites bookmarking
    expect(duaService.isFavourite('salah-takbir'), false);
    await duaService.toggleFavourite('salah-takbir');
    expect(duaService.isFavourite('salah-takbir'), true);

    final favs = duaService.filter(onlyFavourites: true);
    expect(favs.length, 1);
    expect(favs.first.slug, 'salah-takbir');
  });
}
