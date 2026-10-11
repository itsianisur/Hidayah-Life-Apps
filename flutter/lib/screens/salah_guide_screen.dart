import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/salah_step.dart';
import '../services/salah_guide_service.dart';

class SalahGuideScreen extends StatefulWidget {
  const SalahGuideScreen({super.key});

  @override
  State<SalahGuideScreen> createState() => _SalahGuideScreenState();
}

class _SalahGuideScreenState extends State<SalahGuideScreen> {
  final SalahGuideService _service = SalahGuideService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSteps();
  }

  Future<void> _loadSteps() async {
    await _service.init();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _copyStepToClipboard(SalahStep step) {
    final buffer = StringBuffer();
    buffer.writeln('ধাপ ${step.order}: ${step.occasion} — ${step.title}');
    buffer.writeln();
    buffer.writeln('আরবি:');
    buffer.writeln(step.arabic);
    buffer.writeln();
    buffer.writeln('উচ্চারণ:');
    buffer.writeln(step.transliteration);
    buffer.writeln();
    buffer.writeln('বাংলা অর্থ:');
    buffer.writeln(step.banglaMeaning);

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${step.title} ক্লিপবোর্ডে কপি করা হয়েছে!',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.emeraldDark,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.mosque_rounded, color: AppColors.gold, size: 22),
            SizedBox(width: 10),
            Text(
              'নামাজ শিক্ষা',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                // Header Banner
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F3E2F), Color(0xFF07241B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.gold.withAlpha(90),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(90),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withAlpha(40),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.gold.withAlpha(80)),
                        ),
                        child: const Text(
                          'সহীহ নামাজ পদ্ধতি ও তাসবীহ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.goldLight,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'তাকবীরে তাহরিমা থেকে সালাম পর্যন্ত — ১৩টি ধাপ',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'নামাজে পঠিত প্রতিটি তাসবীহ ও দোয়ার বিশুদ্ধ আরবি, উচ্চারণ ও গভীর ভাবার্থ বুঝে নামাজ আদায় করুন।',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // 13 Steps in Salah Order
                ..._service.steps.map((step) => _buildStepCard(step)),

                const SizedBox(height: 24),
              ],
            ),
    );
  }

  Widget _buildStepCard(SalahStep step) {
    final bnOrder = AppStrings.toBanglaNumber(step.order.toString());

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder.withAlpha(120)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(70),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Step Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(
                bottom: BorderSide(color: AppColors.cardBorder.withAlpha(80)),
              ),
            ),
            child: Row(
              children: [
                // Step Number Circle
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withAlpha(80),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      bnOrder,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF041A13),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Gold Occasion Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withAlpha(35),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.gold.withAlpha(90)),
                  ),
                  child: Text(
                    step.occasion,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.goldLight,
                    ),
                  ),
                ),
                const Spacer(),

                // Copy Button
                IconButton(
                  tooltip: 'কপি করুন',
                  icon: const Icon(Icons.copy_rounded, color: AppColors.gold, size: 18),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _copyStepToClipboard(step),
                ),
              ],
            ),
          ),

          // Content Body
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Text(
                  step.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),

                // LARGE Arabic Text (Amiri Font)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF062319),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.emeraldPrimary.withAlpha(60)),
                  ),
                  child: Text(
                    step.arabic,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 24,
                      height: 2.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Transliteration (Muted font)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withAlpha(120),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    step.transliteration,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Bangla Meaning Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder.withAlpha(90)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.lightbulb_outline_rounded, size: 14, color: AppColors.gold),
                          SizedBox(width: 6),
                          Text(
                            'বাংলা অর্থ ও গভীর ভাবার্থ',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.goldLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        step.banglaMeaning,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
