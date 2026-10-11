class CalculationMethodOption {
  final int id;
  final String nameBn;
  final String nameEn;
  final String descriptionBn;
  final String descriptionEn;

  const CalculationMethodOption({
    required this.id,
    required this.nameBn,
    required this.nameEn,
    required this.descriptionBn,
    required this.descriptionEn,
  });

  String getName(String lang) => lang == 'bn' ? nameBn : nameEn;
  String getDescription(String lang) =>
      lang == 'bn' ? descriptionBn : descriptionEn;

  static const List<CalculationMethodOption> all = [
    CalculationMethodOption(
      id: 1,
      nameBn: 'ইসলামিক বিজ্ঞান বিশ্ববিদ্যালয়, করাচি (ডিফল্ট)',
      nameEn: 'University of Islamic Sciences, Karachi (Default)',
      descriptionBn: 'বাংলাদেশ ও উপমহাদেশের জন্য সর্বাধিক অনুসৃত হানাফি পদ্ধতি',
      descriptionEn: 'Widely used in Bangladesh and the Subcontinent (Hanafi)',
    ),
    CalculationMethodOption(
      id: 2,
      nameBn: 'ইসলামিক সোসাইটি অব নর্থ আমেরিকা (ISNA)',
      nameEn: 'Islamic Society of North America (ISNA)',
      descriptionBn: 'উত্তর আমেরিকা অঞ্চলে অনুসৃত পদ্ধতি',
      descriptionEn: 'Standard calculation method across North America',
    ),
    CalculationMethodOption(
      id: 3,
      nameBn: 'মুসলিম ওয়ার্ল্ড লিগ (MWL)',
      nameEn: 'Muslim World League (MWL)',
      descriptionBn: 'ইউরোপ, দূরপ্রাচ্য ও আমেরিকার অনেক দেশে অনুসৃত',
      descriptionEn: 'Common in Europe, Far East and parts of the US',
    ),
    CalculationMethodOption(
      id: 4,
      nameBn: 'উম্মুল কুরা বিশ্ববিদ্যালয়, মক্কা',
      nameEn: 'Umm al-Qura University, Makkah',
      descriptionBn: 'সৌদি আরব ও উপসাগরীয় দেশসমূহে অনুসৃত',
      descriptionEn: 'Standard method in Saudi Arabia and the Gulf',
    ),
    CalculationMethodOption(
      id: 5,
      nameBn: 'মিশরীয় জরিপ কর্তৃপক্ষ (Egyptian)',
      nameEn: 'Egyptian General Authority of Survey',
      descriptionBn: 'মিশর ও মধ্যপ্রাচ্যের একাংশে অনুসৃত',
      descriptionEn: 'Used in Egypt, parts of Africa and the Middle East',
    ),
    CalculationMethodOption(
      id: 13,
      nameBn: 'দিয়ানাত বিষয়াবলি (Diyanet, Turkey)',
      nameEn: 'Presidency of Religious Affairs, Turkey (Diyanet)',
      descriptionBn: 'তুরস্ক ও সংশ্লিষ্ট অঞ্চলে অনুসৃত পদ্ধতি',
      descriptionEn: 'Official method used in Turkey',
    ),
    CalculationMethodOption(
      id: 14,
      nameBn: 'মুনসাইটিং কমিটি ওয়ার্ল্ডওয়াইড',
      nameEn: 'Moonsighting Committee Worldwide',
      descriptionBn: 'আন্তর্জাতিক চাঁদ দেখা কমিটি ভিত্তিক গণনা',
      descriptionEn: 'Calculation based on Moonsighting Committee criteria',
    ),
  ];

  static CalculationMethodOption getById(int id) {
    return all.firstWhere((m) => m.id == id, orElse: () => all.first);
  }
}
