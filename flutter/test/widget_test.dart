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
      "slug": "surah-al-fatiha",
      "titleBn": "সূরা ফাতিহা",
      "titleEn": "Surah Al-Fatiha",
      "category": "surah",
      "arabic": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
      "transliteration": "Bismillahir Rahmanir Rahim",
      "translationBn": "পরম করুণাময় অসীম দয়ালু আল্লাহর নামে।",
      "reference": "সূরা ফাতিহা (১)",
      "virtueBn": "নামাজের প্রতি রাকাতে পড়া অপরিহার্য",
      "audioUrl": null,
      "reviewed": false
    }
    ''';

    final Map<String, dynamic> map = jsonDecode(rawJson);
    final item = DuaItem.fromJson(map);

    expect(item.slug, 'surah-al-fatiha');
    expect(item.titleBn, 'সূরা ফাতিহা');
    expect(item.category, 'surah');
    expect(item.reviewed, false);
    expect(item.getCategoryTitleBn(), 'ছোট সূরা');
  });

  test('DuaService loads bundled duas.json offline and matches item count', () async {
    SharedPreferences.setMockInitialValues({});
    final duaService = DuaService();
    await duaService.init();

    // Verify item count matches source dataset exactly (22 items)
    expect(duaService.allDuas.length, 22);

    // Verify search finds items by Bangla title
    final fatihaResults = duaService.filter(searchQuery: 'ফাতিহা');
    expect(fatihaResults.isNotEmpty, true);
    expect(fatihaResults.first.slug, 'surah-al-fatiha');

    // Verify search finds items by English title
    final ikhlasResults = duaService.filter(searchQuery: 'Ikhlas');
    expect(ikhlasResults.isNotEmpty, true);
    expect(ikhlasResults.first.slug, 'surah-al-ikhlas');

    // Verify category filter
    final surahs = duaService.filter(categoryKey: 'surah');
    expect(surahs.length, 12);

    final daily = duaService.filter(categoryKey: 'daily');
    expect(daily.length, 4);

    final rabbana = duaService.filter(categoryKey: 'rabbana');
    expect(rabbana.length, 3);

    final dorud = duaService.filter(categoryKey: 'dorud');
    expect(dorud.length, 2);

    final qunut = duaService.filter(categoryKey: 'qunut');
    expect(qunut.length, 1);

    // Verify favourites bookmarking
    expect(duaService.isFavourite('surah-al-fatiha'), false);
    await duaService.toggleFavourite('surah-al-fatiha');
    expect(duaService.isFavourite('surah-al-fatiha'), true);

    final favs = duaService.filter(onlyFavourites: true);
    expect(favs.length, 1);
    expect(favs.first.slug, 'surah-al-fatiha');
  });
}
