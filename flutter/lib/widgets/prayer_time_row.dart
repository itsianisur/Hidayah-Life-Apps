import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/prayer_times_data.dart';

class PrayerTimeRow extends StatelessWidget {
  final PrayerEntry entry;
  final bool isNext;
  final String lang;

  const PrayerTimeRow({
    super.key,
    required this.entry,
    required this.isNext,
    required this.lang,
  });

  IconData _getIcon(String key) {
    switch (key) {
      case 'Fajr':
        return Icons.nights_stay_rounded;
      case 'Sunrise':
        return Icons.wb_twilight_rounded;
      case 'Dhuhr':
        return Icons.wb_sunny_rounded;
      case 'Asr':
        return Icons.wb_sunny_outlined;
      case 'Maghrib':
        return Icons.wb_twilight_outlined;
      case 'Isha':
        return Icons.bedtime_rounded;
      default:
        return Icons.access_time_rounded;
    }
  }

  String _getDescription(String key, String lang) {
    final lowerKey = key.toLowerCase();
    return AppStrings.get('${lowerKey}Desc', lang);
  }

  @override
  Widget build(BuildContext context) {
    final isBn = lang == 'bn';
    final name = entry.getName(lang);
    final desc = _getDescription(entry.key, lang);
    final formattedTime = AppStrings.formatPrayerTime(entry.time, lang);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isNext ? const Color(0xFF144535) : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNext ? AppColors.gold : AppColors.cardBorder.withOpacity(0.5),
          width: isNext ? 1.8 : 1.0,
        ),
        boxShadow: isNext
            ? [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isNext
                  ? AppColors.gold.withOpacity(0.2)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isNext ? AppColors.gold.withOpacity(0.5) : Colors.transparent,
              ),
            ),
            child: Icon(
              _getIcon(entry.key),
              color: isNext ? AppColors.goldLight : AppColors.emeraldLight,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          // Prayer Name & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: isNext ? FontWeight.bold : FontWeight.w600,
                        color: isNext ? AppColors.goldLight : AppColors.textPrimary,
                      ),
                    ),
                    if (isNext) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isBn ? 'পরবর্তী' : 'NEXT',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF041A13),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: isNext ? AppColors.textGold.withOpacity(0.8) : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          // Time Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formattedTime,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isNext ? AppColors.goldLight : AppColors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              if (!entry.isWaqt)
                Text(
                  isBn ? 'সূর্য ওঠার সময়' : 'Sun time',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
