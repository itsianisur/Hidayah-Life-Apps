class PrayerEntry {
  final String key;
  final String nameBn;
  final String nameEn;
  final String time; // e.g. "04:39"
  final bool isWaqt; // true for 5 daily prayers, false for Sunrise

  const PrayerEntry({
    required this.key,
    required this.nameBn,
    required this.nameEn,
    required this.time,
    this.isWaqt = true,
  });

  String getName(String lang) => lang == 'bn' ? nameBn : nameEn;
}

class NextPrayerInfo {
  final PrayerEntry prayer;
  final DateTime targetTime;
  final Duration timeRemaining;
  final bool isNextDay;

  const NextPrayerInfo({
    required this.prayer,
    required this.targetTime,
    required this.timeRemaining,
    required this.isNextDay,
  });
}

class PrayerTimesData {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  // Gregorian
  final String gregorianReadable;
  final String gregorianWeekdayEn;
  final String gregorianDay;
  final String gregorianMonthEn;
  final String gregorianYear;

  // Hijri
  final String hijriDay;
  final String hijriMonthEn;
  final String hijriMonthAr;
  final String hijriYear;

  final DateTime fetchedAt;

  const PrayerTimesData({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.gregorianReadable,
    required this.gregorianWeekdayEn,
    required this.gregorianDay,
    required this.gregorianMonthEn,
    required this.gregorianYear,
    required this.hijriDay,
    required this.hijriMonthEn,
    required this.hijriMonthAr,
    required this.hijriYear,
    required this.fetchedAt,
  });

  List<PrayerEntry> get allEntries => [
        PrayerEntry(
          key: 'Fajr',
          nameBn: 'ফজর',
          nameEn: 'Fajr',
          time: fajr,
          isWaqt: true,
        ),
        PrayerEntry(
          key: 'Sunrise',
          nameBn: 'সূর্যোদয়',
          nameEn: 'Sunrise',
          time: sunrise,
          isWaqt: false,
        ),
        PrayerEntry(
          key: 'Dhuhr',
          nameBn: 'যোহর',
          nameEn: 'Dhuhr',
          time: dhuhr,
          isWaqt: true,
        ),
        PrayerEntry(
          key: 'Asr',
          nameBn: 'আসর',
          nameEn: 'Asr',
          time: asr,
          isWaqt: true,
        ),
        PrayerEntry(
          key: 'Maghrib',
          nameBn: 'মাগরিব',
          nameEn: 'Maghrib',
          time: maghrib,
          isWaqt: true,
        ),
        PrayerEntry(
          key: 'Isha',
          nameBn: 'এশা',
          nameEn: 'Isha',
          time: isha,
          isWaqt: true,
        ),
      ];

  DateTime _parseTimeToToday(String timeStr, DateTime now, {int dayOffset = 0}) {
    final cleanTime = timeStr.split(' ')[0]; // Remove timezone or (BST) if any
    final parts = cleanTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return DateTime(
      now.year,
      now.month,
      now.day + dayOffset,
      hour,
      minute,
      0,
    );
  }

  NextPrayerInfo getNextPrayer(DateTime now) {
    final entries = allEntries;

    for (final entry in entries) {
      final entryTime = _parseTimeToToday(entry.time, now);
      if (entryTime.isAfter(now)) {
        return NextPrayerInfo(
          prayer: entry,
          targetTime: entryTime,
          timeRemaining: entryTime.difference(now),
          isNextDay: false,
        );
      }
    }

    // If all prayers today have passed, next prayer is Fajr tomorrow
    final fajrTomorrow = _parseTimeToToday(fajr, now, dayOffset: 1);
    return NextPrayerInfo(
      prayer: entries.firstWhere((e) => e.key == 'Fajr'),
      targetTime: fajrTomorrow,
      timeRemaining: fajrTomorrow.difference(now),
      isNextDay: true,
    );
  }

  Map<String, dynamic> toJson() => {
        'fajr': fajr,
        'sunrise': sunrise,
        'dhuhr': dhuhr,
        'asr': asr,
        'maghrib': maghrib,
        'isha': isha,
        'gregorianReadable': gregorianReadable,
        'gregorianWeekdayEn': gregorianWeekdayEn,
        'gregorianDay': gregorianDay,
        'gregorianMonthEn': gregorianMonthEn,
        'gregorianYear': gregorianYear,
        'hijriDay': hijriDay,
        'hijriMonthEn': hijriMonthEn,
        'hijriMonthAr': hijriMonthAr,
        'hijriYear': hijriYear,
        'fetchedAt': fetchedAt.toIso8601String(),
      };

  factory PrayerTimesData.fromJson(Map<String, dynamic> json) {
    return PrayerTimesData(
      fajr: json['fajr'] ?? '04:39',
      sunrise: json['sunrise'] ?? '05:54',
      dhuhr: json['dhuhr'] ?? '11:45',
      asr: json['asr'] ?? '15:07',
      maghrib: json['maghrib'] ?? '17:35',
      isha: json['isha'] ?? '18:51',
      gregorianReadable: json['gregorianReadable'] ?? '',
      gregorianWeekdayEn: json['gregorianWeekdayEn'] ?? '',
      gregorianDay: json['gregorianDay'] ?? '',
      gregorianMonthEn: json['gregorianMonthEn'] ?? '',
      gregorianYear: json['gregorianYear'] ?? '',
      hijriDay: json['hijriDay'] ?? '',
      hijriMonthEn: json['hijriMonthEn'] ?? '',
      hijriMonthAr: json['hijriMonthAr'] ?? '',
      hijriYear: json['hijriYear'] ?? '',
      fetchedAt: json['fetchedAt'] != null
          ? DateTime.tryParse(json['fetchedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  factory PrayerTimesData.fromAladhan(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final timings = data['timings'] ?? {};
    final date = data['date'] ?? {};
    final greg = date['gregorian'] ?? {};
    final hijri = date['hijri'] ?? {};

    String cleanTime(dynamic val) {
      if (val == null) return '00:00';
      final s = val.toString();
      return s.split(' ')[0];
    }

    return PrayerTimesData(
      fajr: cleanTime(timings['Fajr']),
      sunrise: cleanTime(timings['Sunrise']),
      dhuhr: cleanTime(timings['Dhuhr']),
      asr: cleanTime(timings['Asr']),
      maghrib: cleanTime(timings['Maghrib']),
      isha: cleanTime(timings['Isha']),
      gregorianReadable: date['readable']?.toString() ?? '',
      gregorianWeekdayEn: greg['weekday']?['en']?.toString() ?? '',
      gregorianDay: greg['day']?.toString() ?? '',
      gregorianMonthEn: greg['month']?['en']?.toString() ?? '',
      gregorianYear: greg['year']?.toString() ?? '',
      hijriDay: hijri['day']?.toString() ?? '',
      hijriMonthEn: hijri['month']?['en']?.toString() ?? '',
      hijriMonthAr: hijri['month']?['ar']?.toString() ?? '',
      hijriYear: hijri['year']?.toString() ?? '',
      fetchedAt: DateTime.now(),
    );
  }

  // Sensible default fallback for Dhaka, Bangladesh (Karachi method)
  factory PrayerTimesData.dhakaFallback() {
    final now = DateTime.now();
    return PrayerTimesData(
      fajr: '04:39',
      sunrise: '05:54',
      dhuhr: '11:45',
      asr: '15:07',
      maghrib: '17:35',
      isha: '18:51',
      gregorianReadable: '${now.day} Oct ${now.year}',
      gregorianWeekdayEn: 'Today',
      gregorianDay: now.day.toString(),
      gregorianMonthEn: 'October',
      gregorianYear: now.year.toString(),
      hijriDay: '1',
      hijriMonthEn: 'Jumada al-Ula',
      hijriMonthAr: 'جمادى الأولى',
      hijriYear: '1448',
      fetchedAt: now,
    );
  }
}
