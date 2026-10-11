import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../services/storage_service.dart';
import 'prayer_times_screen.dart';
import 'platform_webview_screen.dart';

class HomeNavScreen extends StatefulWidget {
  const HomeNavScreen({super.key});

  @override
  State<HomeNavScreen> createState() => _HomeNavScreenState();
}

class _HomeNavScreenState extends State<HomeNavScreen> {
  int _currentIndex = 0;
  String _lang = 'bn';

  @override
  void initState() {
    super.initState();
    _lang = StorageService.getLanguage();
  }

  void refreshLanguage() {
    setState(() {
      _lang = StorageService.getLanguage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          PrayerTimesScreen(),
          PlatformWebviewScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(
              color: AppColors.cardBorder.withOpacity(0.5),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: AppColors.gold.withOpacity(0.2),
              labelTextStyle: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.goldLight,
                  );
                }
                return const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                );
              }),
              iconTheme: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return const IconThemeData(color: AppColors.goldLight, size: 24);
                }
                return const IconThemeData(color: AppColors.textSecondary, size: 22);
              }),
            ),
            child: NavigationBar(
              backgroundColor: AppColors.surface,
              selectedIndex: _currentIndex,
              height: 64,
              elevation: 0,
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                  _lang = StorageService.getLanguage();
                });
              },
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.access_time_rounded),
                  selectedIcon: const Icon(Icons.access_time_filled_rounded),
                  label: AppStrings.get('prayerTimes', _lang),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.public_rounded),
                  selectedIcon: const Icon(Icons.public_rounded),
                  label: AppStrings.get('platform', _lang),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
