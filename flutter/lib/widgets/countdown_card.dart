import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/prayer_times_data.dart';

class CountdownCard extends StatefulWidget {
  final PrayerTimesData data;
  final String lang;
  final VoidCallback? onRefresh;

  const CountdownCard({
    super.key,
    required this.data,
    required this.lang,
    this.onRefresh,
  });

  @override
  State<CountdownCard> createState() => _CountdownCardState();
}

class _CountdownCardState extends State<CountdownCard> {
  Timer? _ticker;
  late NextPrayerInfo _nextPrayer;

  @override
  void initState() {
    super.initState();
    _updateNextPrayer();
    _startTicker();
  }

  @override
  void didUpdateWidget(covariant CountdownCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _updateNextPrayer();
    }
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _updateNextPrayer();
        });
      }
    });
  }

  void _updateNextPrayer() {
    _nextPrayer = widget.data.getNextPrayer(DateTime.now());
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  IconData _getPrayerIcon(String key) {
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

  @override
  Widget build(BuildContext context) {
    final isBn = widget.lang == 'bn';
    final prayerName = _nextPrayer.prayer.getName(widget.lang);
    final countdownStr = AppStrings.formatCountdown(
      _nextPrayer.timeRemaining,
      widget.lang,
    );
    final formattedTime = AppStrings.formatPrayerTime(
      _nextPrayer.prayer.time,
      widget.lang,
    );

    // Format text: "Fajr in 2:08:25" or "ফজর শুরু হতে বাকি ২:০৮:২৫"
    final statusHeadline = isBn
        ? '$prayerName শুরু হতে বাকি $countdownStr'
        : '$prayerName in $countdownStr';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F3E2F),
            Color(0xFF08271E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.gold.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.gold.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getPrayerIcon(_nextPrayer.prayer.key),
                      size: 16,
                      color: AppColors.goldLight,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.get('nextPrayer', widget.lang),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.textGold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Main Prayer Name
          Text(
            prayerName,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),

          // Prayer time badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                formattedTime,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.emeraldLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Live Countdown ticking every second
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder.withOpacity(0.6)),
            ),
            child: Column(
              children: [
                Text(
                  statusHeadline,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.goldLight,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  isBn
                      ? 'প্রতি সেকেন্ডে আপডেট হচ্ছে'
                      : 'Live countdown updating every second',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
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
