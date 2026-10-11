import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../models/dua_item.dart';
import '../services/dua_service.dart';

class DuaDetailScreen extends StatefulWidget {
  final DuaItem item;
  final VoidCallback? onFavouriteToggled;

  const DuaDetailScreen({
    super.key,
    required this.item,
    this.onFavouriteToggled,
  });

  @override
  State<DuaDetailScreen> createState() => _DuaDetailScreenState();
}

class _DuaDetailScreenState extends State<DuaDetailScreen> {
  final DuaService _duaService = DuaService();
  late bool _isFav;

  @override
  void initState() {
    super.initState();
    _isFav = _duaService.isFavourite(widget.item.slug);
  }

  Future<void> _handleToggleFav() async {
    final updated = await _duaService.toggleFavourite(widget.item.slug);
    if (mounted) {
      setState(() => _isFav = updated);
      widget.onFavouriteToggled?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            updated ? 'প্রিয় তালিকায় যোগ করা হয়েছে' : 'প্রিয় তালিকা থেকে সরানো হয়েছে',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: updated ? AppColors.emeraldDark : AppColors.cardElevated,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _copyToClipboard() {
    final buffer = StringBuffer();
    buffer.writeln(widget.item.titleBn);
    buffer.writeln();
    buffer.writeln('আরবি:');
    buffer.writeln(widget.item.arabic);
    buffer.writeln();
    if (widget.item.transliteration.isNotEmpty) {
      buffer.writeln('উচ্চারণ:');
      buffer.writeln(widget.item.transliteration);
      buffer.writeln();
    }
    buffer.writeln('বাংলা অর্থ:');
    buffer.writeln(widget.item.translationBn);
    buffer.writeln();
    buffer.writeln('সূত্র: ${widget.item.reference}');

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'ক্লিপবোর্ডে কপি করা হয়েছে!',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.emeraldDark,
        duration: Duration(seconds: 2),
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
        title: Text(
          widget.item.titleBn,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'কপি করুন',
            icon: const Icon(Icons.copy_rounded, color: AppColors.gold),
            onPressed: _copyToClipboard,
          ),
          IconButton(
            tooltip: _isFav ? 'বুকমার্ক সরান' : 'বুকমার্ক করুন',
            icon: Icon(
              _isFav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _isFav ? AppColors.goldLight : AppColors.textSecondary,
            ),
            onPressed: _handleToggleFav,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // Category & English title badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gold.withAlpha(40),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.gold.withAlpha(80)),
                ),
                child: Text(
                  widget.item.getCategoryTitleBn(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.goldLight,
                  ),
                ),
              ),
              Text(
                widget.item.titleEn,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // LARGE Arabic Text Card (Amiri Font)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F3E2F), Color(0xFF07241B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.gold.withAlpha(90),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withAlpha(180),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'আরবি পাঠ',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.goldLight,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.item.arabic,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 26,
                    height: 2.1,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Transliteration (উচ্চারণ) Card
          if (widget.item.transliteration.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.cardBorder.withAlpha(120)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.record_voice_over_rounded, size: 16, color: AppColors.emeraldLight),
                      SizedBox(width: 6),
                      Text(
                        'উচ্চারণ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.emeraldLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.item.transliteration,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Bangla Translation (বাংলা অর্থ) Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.cardBorder.withAlpha(150)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.translate_rounded, size: 16, color: AppColors.gold),
                    SizedBox(width: 6),
                    Text(
                      'বাংলা অর্থ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.item.translationBn,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.7,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Virtue (ফজিলত) Card if present
          if (widget.item.virtueBn != null && widget.item.virtueBn!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF062319),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.emeraldPrimary.withAlpha(90)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.star_rounded, size: 20, color: AppColors.goldLight),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ফজিলত ও গুরুত্ব',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.goldLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.item.virtueBn!,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: AppColors.textEmerald,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Reference (সূত্র) Card at bottom
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.card.withAlpha(150),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder.withAlpha(100)),
            ),
            child: Row(
              children: [
                const Icon(Icons.menu_book_rounded, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 8),
                const Text(
                  'রেফারেন্স / সূত্র: ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.item.reference,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Bottom Quick Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.goldLight,
                    side: BorderSide(color: AppColors.gold.withAlpha(100)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _copyToClipboard,
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: const Text(
                    'কপি করুন',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFav ? AppColors.gold : AppColors.cardElevated,
                    foregroundColor: _isFav ? const Color(0xFF041A13) : AppColors.goldLight,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _handleToggleFav,
                  icon: Icon(
                    _isFav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    size: 18,
                  ),
                  label: Text(
                    _isFav ? 'সংরক্ষিত' : 'বুকমার্ক করুন',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
