import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dua_item.dart';

class DuaCategory {
  final String key;
  final String titleBn;
  final String titleEn;

  const DuaCategory({
    required this.key,
    required this.titleBn,
    required this.titleEn,
  });
}

class DuaService {
  static final DuaService _instance = DuaService._internal();
  factory DuaService() => _instance;
  DuaService._internal();

  static const String _keyFavourites = 'hidayah_favourite_duas';

  List<DuaItem> _allDuas = [];
  Set<String> _favouriteSlugs = {};
  bool _isLoaded = false;

  List<DuaItem> get allDuas => List.unmodifiable(_allDuas);
  Set<String> get favouriteSlugs => Set.unmodifiable(_favouriteSlugs);
  bool get isLoaded => _isLoaded;

  static const List<DuaCategory> categories = [
    DuaCategory(key: 'all', titleBn: 'সকল', titleEn: 'All'),
    DuaCategory(key: 'salah', titleBn: 'নামাজের দোয়া', titleEn: 'Salah Adhkar'),
    DuaCategory(key: 'surah', titleBn: 'ছোট সূরা', titleEn: 'Short Surahs'),
    DuaCategory(key: 'daily', titleBn: 'দৈনন্দিন দোয়া', titleEn: 'Daily Duas'),
    DuaCategory(key: 'rabbana', titleBn: 'রাব্বানা দোয়া', titleEn: 'Rabbana Duas'),
    DuaCategory(key: 'dorud', titleBn: 'দরুদ শরীফ', titleEn: 'Dorud Sharif'),
    DuaCategory(key: 'qunut', titleBn: 'দোয়া কুনুত', titleEn: 'Dua-e-Qunut'),
    DuaCategory(key: 'hisnul', titleBn: 'Hisnul Muslim', titleEn: 'Hisnul Muslim'),
  ];

  Future<void> init() async {
    if (_isLoaded) return;

    // Load bundled offline JSON
    final jsonString = await rootBundle.loadString('assets/data/duas.json');
    final List<dynamic> list = jsonDecode(jsonString);
    _allDuas = list.map((item) => DuaItem.fromJson(item as Map<String, dynamic>)).toList();

    // Load persisted favourites from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final savedFavs = prefs.getStringList(_keyFavourites) ?? [];
    _favouriteSlugs = savedFavs.toSet();

    _isLoaded = true;
  }

  bool isFavourite(String slug) {
    return _favouriteSlugs.contains(slug);
  }

  Future<bool> toggleFavourite(String slug) async {
    if (_favouriteSlugs.contains(slug)) {
      _favouriteSlugs.remove(slug);
    } else {
      _favouriteSlugs.add(slug);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyFavourites, _favouriteSlugs.toList());
    return _favouriteSlugs.contains(slug);
  }

  List<DuaItem> filter({
    String categoryKey = 'all',
    String searchQuery = '',
    bool onlyFavourites = false,
  }) {
    final query = searchQuery.trim().toLowerCase();

    return _allDuas.filter((item) {
      // 1. Favourites filter
      if (onlyFavourites && !_favouriteSlugs.contains(item.slug)) {
        return false;
      }

      // 2. Category filter
      if (categoryKey != 'all') {
        if (categoryKey == 'hisnul') {
          // Hisnul Muslim situational & hadith referenced daily items
          final isHisnulRef = item.category == 'daily' ||
              item.reference.toLowerCase().contains('বুখারী') ||
              item.reference.toLowerCase().contains('দাউদ') ||
              item.reference.toLowerCase().contains('মাজাহ') ||
              item.category == 'hisnul';
          if (!isHisnulRef) return false;
        } else if (item.category != categoryKey) {
          return false;
        }
      }

      // 3. Search query filter
      if (query.isNotEmpty) {
        final matches = item.titleBn.toLowerCase().contains(query) ||
            item.titleEn.toLowerCase().contains(query) ||
            item.transliteration.toLowerCase().contains(query) ||
            item.translationBn.toLowerCase().contains(query) ||
            item.reference.toLowerCase().contains(query) ||
            item.arabic.contains(query);
        if (!matches) return false;
      }

      return true;
    }).toList();
  }

  DuaItem? getBySlug(String slug) {
    try {
      return _allDuas.firstWhere((d) => d.slug == slug);
    } catch (_) {
      return null;
    }
  }
}

extension _IterableFilter<E> on Iterable<E> {
  Iterable<E> filter(bool Function(E) test) sync* {
    for (final element in this) {
      if (test(element)) yield element;
    }
  }
}
