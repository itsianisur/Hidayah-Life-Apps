import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hidayah_life/models/prayer_times_data.dart';
import 'package:hidayah_life/models/dua_item.dart';
import 'package:hidayah_life/services/dua_service.dart';
import 'package:hidayah_life/services/salah_guide_service.dart';
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

  test('SalahGuideService loads all 13 steps offline in exact order', () async {
    final service = SalahGuideService();
    await service.init();

    expect(service.steps.length, 13);

    // Verify order 1 to 13
    for (int i = 0; i < 13; i++) {
      expect(service.steps[i].order, i + 1);
      expect(service.steps[i].occasion.isNotEmpty, true);
      expect(service.steps[i].title.isNotEmpty, true);
      expect(service.steps[i].arabic.isNotEmpty, true);
      expect(service.steps[i].transliteration.isNotEmpty, true);
      expect(service.steps[i].banglaMeaning.isNotEmpty, true);
    }

    // Check specific steps
    expect(service.steps[0].title, 'আল্লাহু আকবার');
    expect(service.steps[0].arabic, 'اللهُ أَكْبَرُ');

    expect(service.steps[3].occasion, 'রুকু');
    expect(service.steps[3].title, 'সুবহানা রাব্বিয়াল আযীম');
    expect(service.steps[3].arabic, 'سُبْحَانَ رَبِّيَ الْعَظِيمِ');

    expect(service.steps[6].occasion, 'সিজদা');
    expect(service.steps[6].title, "সুবহানা রাব্বিয়াল আ'লা");
    expect(service.steps[6].arabic, 'سُبْحَانَ رَبِّيَ الْأَعْلَى');

    expect(service.steps[7].occasion, 'দুই সিজদার মাঝে');
    expect(service.steps[7].arabic, 'رَبِّ اغْفِرْ لِي');

    expect(service.steps[12].order, 13);
    expect(service.steps[12].occasion, 'নামাজ সমাপ্তি (ডানে ও বামে)');
    expect(service.steps[12].title, 'আসসালামু আলাইকুম ওয়া রাহমাতুল্লাহ');
    expect(service.steps[12].arabic, 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ');
  });
}

