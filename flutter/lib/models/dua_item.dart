class DuaItem {
  final String slug;
  final String titleBn;
  final String titleEn;
  final String category;
  final String arabic;
  final String transliteration;
  final String translationBn;
  final String reference;
  final String? virtueBn;
  final String? audioUrl;
  final bool reviewed;

  const DuaItem({
    required this.slug,
    required this.titleBn,
    required this.titleEn,
    required this.category,
    required this.arabic,
    required this.transliteration,
    required this.translationBn,
    required this.reference,
    this.virtueBn,
    this.audioUrl,
    this.reviewed = false,
  });

  factory DuaItem.fromJson(Map<String, dynamic> json) {
    return DuaItem(
      slug: json['slug'] as String,
      titleBn: json['titleBn'] as String,
      titleEn: json['titleEn'] as String,
      category: json['category'] as String,
      arabic: json['arabic'] as String,
      transliteration: (json['transliteration'] as String?) ?? '',
      translationBn: json['translationBn'] as String,
      reference: json['reference'] as String,
      virtueBn: json['virtueBn'] as String?,
      audioUrl: json['audioUrl'] as String?,
      reviewed: (json['reviewed'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'slug': slug,
        'titleBn': titleBn,
        'titleEn': titleEn,
        'category': category,
        'arabic': arabic,
        'transliteration': transliteration,
        'translationBn': translationBn,
        'reference': reference,
        'virtueBn': virtueBn,
        'audioUrl': audioUrl,
        'reviewed': reviewed,
      };

  String getCategoryTitleBn() {
    switch (category) {
      case 'surah':
        return 'ছোট সূরা';
      case 'daily':
        return 'দৈনন্দিন দোয়া';
      case 'rabbana':
        return 'রাব্বানা দোয়া';
      case 'dorud':
        return 'দরুদ শরীফ';
      case 'qunut':
        return 'দোয়া কুনুত';
      case 'hisnul':
        return 'Hisnul Muslim';
      default:
        return category;
    }
  }
}
