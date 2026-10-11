import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/prayer_times_data.dart';

class DateHeader extends StatelessWidget {
  final PrayerTimesData data;
  final String lang;

  const DateHeader({
    super.key,
    required this.data,
    required this.lang,
  });

  String _getBanglaWeekday(String enDay) {
    switch (enDay.toLowerCase()) {
      case 'saturday':
        return 'শনিবার';
      case 'sunday':
        return 'রবিবার';
      case 'monday':
        return 'সোমবার';
      case 'tuesday':
        return 'মঙ্গলবার';
      case 'wednesday':
        return 'বুধবার';
      case 'thursday':
        return 'বৃহস্পতিবার';
      case 'friday':
        return 'শুক্রবার';
      default:
        return enDay;
    }
  }

  String _getBanglaMonth(String enMonth) {
    switch (enMonth.toLowerCase()) {
      case 'january':
        return 'জানুয়ারি';
      case 'february':
        return 'ফেব্রুয়ারি';
      case 'march':
        return 'মার্চ';
      case 'april':
        return 'এপ্রিল';
      case 'may':
        return 'মে';
      case 'june':
        return 'জুন';
      case 'july':
        return 'জুলাই';
      case 'august':
        return 'আগস্ট';
      case 'september':
        return 'সেপ্টেম্বর';
      case 'october':
        return 'অক্টোবর';
      case 'november':
        return 'নভেম্বর';
      case 'december':
        return 'ডিসেম্বর';
      default:
        return enMonth;
    }
  }

  String _getBanglaHijriMonth(String enMonth) {
    final lower = enMonth.toLowerCase();
    if (lower.contains('muharram')) return 'মুহাররম';
    if (lower.contains('safar')) return 'সফর';
    if (lower.contains('rabi') && lower.contains('awwal')) return 'রবিউল আউয়াল';
    if (lower.contains('rabi') && (lower.contains('thani') || lower.contains('akhir'))) return 'রবিউস সানি';
    if (lower.contains('jumad') && (lower.contains('ula') || lower.contains('awal') || lower.contains('1'))) return 'জুমাদাল উলা';
    if (lower.contains('jumad') && (lower.contains('thani') || lower.contains('akhir') || lower.contains('2'))) return 'জুমাদাস সানি';
    if (lower.contains('rajab')) return 'রজব';
    if (lower.contains('sha') && lower.contains('ban')) return 'শাবান';
    if (lower.contains('ramadan') || lower.contains('ramadhan')) return 'রমজান';
    if (lower.contains('shawwal')) return 'শাওয়াল';
    if (lower.contains('dhu') && lower.contains('qa')) return 'জিলকদ';
    if (lower.contains('dhu') && lower.contains('hij')) return 'জিলহজ';
    return enMonth;
  }

  @override
  Widget build(BuildContext context) {
    final isBn = lang == 'bn';

    final weekday = isBn
        ? _getBanglaWeekday(data.gregorianWeekdayEn)
        : data.gregorianWeekdayEn.toUpperCase();

    final day = isBn ? AppStrings.toBanglaNumber(data.gregorianDay) : data.gregorianDay;
    final month = isBn ? _getBanglaMonth(data.gregorianMonthEn) : data.gregorianMonthEn.toUpperCase();
    final year = isBn ? AppStrings.toBanglaNumber(data.gregorianYear) : data.gregorianYear;

    final gregorianText = '$weekday, $day $month $year';

    final hijriDay = isBn ? AppStrings.toBanglaNumber(data.hijriDay) : data.hijriDay;
    final hijriMonth = isBn ? _getBanglaHijriMonth(data.hijriMonthEn) : data.hijriMonthEn;
    final hijriYear = isBn ? AppStrings.toBanglaNumber(data.hijriYear) : data.hijriYear;
    final hijriText = isBn
        ? '$hijriDay $hijriMonth $hijriYear হিজরি'
        : '$hijriDay $hijriMonth $hijriYear AH';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: AppColors.gold,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  gregorianText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.goldGlow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.gold.withOpacity(0.3)),
            ),
            child: Text(
              hijriText,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textGold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
