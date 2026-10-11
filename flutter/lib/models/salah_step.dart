class SalahStep {
  final int order;
  final String occasion;
  final String occasionEn;
  final String title;
  final String arabic;
  final String transliteration;
  final String banglaMeaning;

  const SalahStep({
    required this.order,
    required this.occasion,
    required this.occasionEn,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.banglaMeaning,
  });

  factory SalahStep.fromJson(Map<String, dynamic> json) {
    return SalahStep(
      order: json['order'] as int,
      occasion: json['occasion'] as String,
      occasionEn: json['occasionEn'] as String,
      title: json['title'] as String,
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      banglaMeaning: json['banglaMeaning'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'order': order,
        'occasion': occasion,
        'occasionEn': occasionEn,
        'title': title,
        'arabic': arabic,
        'transliteration': transliteration,
        'banglaMeaning': banglaMeaning,
      };
}
