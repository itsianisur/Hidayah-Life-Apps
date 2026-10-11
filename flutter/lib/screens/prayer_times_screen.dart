import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/prayer_times_data.dart';
import '../services/prayer_service.dart';
import '../services/storage_service.dart';
import '../widgets/countdown_card.dart';
import '../widgets/date_header.dart';
import '../widgets/prayer_time_row.dart';
import 'settings_screen.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  final PrayerService _prayerService = PrayerService();
  String _lang = 'bn';
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _lang = StorageService.getLanguage();
  }

  void _onLanguageChanged() {
    setState(() {
      _lang = StorageService.getLanguage();
    });
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await _prayerService.fetchPrayerTimes();
    if (mounted) {
      setState(() => _isRefreshing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _prayerService.isOffline
                ? AppStrings.get('offlineMode', _lang)
                : AppStrings.get('syncSuccess', _lang),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor:
              _prayerService.isOffline ? AppColors.error : AppColors.emeraldDark,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.gold.withOpacity(0.4)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/app_icon.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.get('appName', _lang),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  AppStrings.get('dhakaBangladesh', _lang),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.goldLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: AppStrings.get('refresh', _lang),
            icon: _isRefreshing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.gold,
                    ),
                  )
                : const Icon(Icons.refresh_rounded, color: AppColors.gold),
            onPressed: _isRefreshing ? null : _handleRefresh,
          ),
          IconButton(
            tooltip: AppStrings.get('settings', _lang),
            icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(
                    onSettingsChanged: () {
                      _onLanguageChanged();
                      _prayerService.fetchPrayerTimes();
                    },
                  ),
                ),
              );
              _onLanguageChanged();
            },
          ),
        ],
      ),
      body: StreamBuilder<PrayerTimesData>(
        stream: _prayerService.prayerTimesStream,
        initialData: _prayerService.currentData ?? PrayerTimesData.dhakaFallback(),
        builder: (context, snapshot) {
          final data = snapshot.data ?? PrayerTimesData.dhakaFallback();
          final nextPrayer = data.getNextPrayer(DateTime.now());

          return RefreshIndicator(
            color: AppColors.gold,
            backgroundColor: AppColors.surface,
            onRefresh: _handleRefresh,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                // Offline banner if applicable
                if (_prayerService.isOffline) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF451A03),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.gold.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.wifi_off_rounded,
                          color: AppColors.goldLight,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            AppStrings.get('offlineMode', _lang),
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.goldLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // 1. Gregorian & Hijri Date Header
                DateHeader(data: data, lang: _lang),
                const SizedBox(height: 16),

                // 2. Live Countdown Card ticking every second
                CountdownCard(
                  data: data,
                  lang: _lang,
                  onRefresh: _handleRefresh,
                ),
                const SizedBox(height: 20),

                // Section Title: Today's 6 Prayer Times
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.get('prayerTimes', _lang),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.cardBorder.withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        _lang == 'bn' ? '৬টি সময়সূচি' : '6 Daily Times',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 3. Panel showing today's 6 times with the next prayer highlighted
                ...data.allEntries.map((entry) {
                  final isNext = entry.key == nextPrayer.prayer.key;
                  return PrayerTimeRow(
                    entry: entry,
                    isNext: isNext,
                    lang: _lang,
                  );
                }),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
