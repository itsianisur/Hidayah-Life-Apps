import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/calculation_method.dart';
import '../services/notification_service.dart';
import '../services/prayer_service.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback? onSettingsChanged;

  const SettingsScreen({super.key, this.onSettingsChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedMethod = 1;
  bool _notificationsEnabled = true;
  String _lang = 'bn';

  @override
  void initState() {
    super.initState();
    _selectedMethod = StorageService.getMethod();
    _notificationsEnabled = StorageService.getNotificationsEnabled();
    _lang = StorageService.getLanguage();
  }

  Future<void> _updateMethod(int methodId) async {
    setState(() => _selectedMethod = methodId);
    await StorageService.setMethod(methodId);
    widget.onSettingsChanged?.call();
  }

  Future<void> _toggleNotifications(bool enabled) async {
    setState(() => _notificationsEnabled = enabled);
    await StorageService.setNotificationsEnabled(enabled);

    if (enabled) {
      final currentData = PrayerService().currentData;
      if (currentData != null) {
        await NotificationService().schedulePrayerNotifications(currentData);
      }
    } else {
      await NotificationService().cancelAllNotifications();
    }
    widget.onSettingsChanged?.call();
  }

  Future<void> _updateLanguage(String newLang) async {
    setState(() => _lang = newLang);
    await StorageService.setLanguage(newLang);
    widget.onSettingsChanged?.call();
  }

  void _showCalculationMethodDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.get('calculationMethod', _lang),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textSecondary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: CalculationMethodOption.all.length,
                    itemBuilder: (context, index) {
                      final option = CalculationMethodOption.all[index];
                      final isSelected = option.id == _selectedMethod;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.cardElevated
                              : AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.gold
                                : AppColors.cardBorder.withOpacity(0.5),
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            option.getName(_lang),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.goldLight
                                  : AppColors.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            option.getDescription(_lang),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.gold,
                                )
                              : null,
                          onTap: () async {
                            Navigator.of(context).pop();
                            await _updateMethod(option.id);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentMethodObj = CalculationMethodOption.getById(_selectedMethod);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          AppStrings.get('settings', _lang),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section 1: Prayer Calculation
          _buildSectionHeader(AppStrings.get('prayerTimes', _lang)),
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder.withOpacity(0.5)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.calculate_rounded, color: AppColors.gold),
              ),
              title: Text(
                AppStrings.get('calculationMethod', _lang),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                currentMethodObj.getName(_lang),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.emeraldLight,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: _showCalculationMethodDialog,
            ),
          ),
          const SizedBox(height: 20),

          // Section 2: Notifications
          _buildSectionHeader(AppStrings.get('notifications', _lang)),
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  secondary: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _notificationsEnabled
                          ? Icons.notifications_active_rounded
                          : Icons.notifications_off_rounded,
                      color: _notificationsEnabled
                          ? AppColors.gold
                          : AppColors.textMuted,
                    ),
                  ),
                  title: Text(
                    AppStrings.get('notifications', _lang),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    AppStrings.get('notificationsDesc', _lang),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  value: _notificationsEnabled,
                  activeColor: AppColors.gold,
                  activeTrackColor: AppColors.gold.withOpacity(0.4),
                  onChanged: _toggleNotifications,
                ),
                const Divider(color: AppColors.divider, height: 1),

                // Manual Test Notifications
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.play_arrow_rounded, color: AppColors.emeraldLight),
                  ),
                  title: Text(
                    AppStrings.get('testNotification', _lang),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    _lang == 'bn'
                        ? 'তাৎক্ষণিক টেস্ট অ্যালার্ট পাঠান'
                        : 'Send instant test notification',
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                  trailing: TextButton(
                    onPressed: () async {
                      await NotificationService().showInstantTestNotification();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppStrings.get('testNotificationSent', _lang)),
                            backgroundColor: AppColors.emeraldDark,
                          ),
                        );
                      }
                    },
                    child: Text(
                      _lang == 'bn' ? 'পাঠান' : 'Test',
                      style: const TextStyle(color: AppColors.gold),
                    ),
                  ),
                ),
                const Divider(color: AppColors.divider, height: 1),

                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.timer_outlined, color: AppColors.goldLight),
                  ),
                  title: Text(
                    _lang == 'bn'
                        ? '২ মিনিট পর টেস্ট অ্যালার্ট'
                        : 'Test Alert (in 2 minutes)',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    _lang == 'bn'
                        ? 'স্ক্রিন লক করে ব্যাকগ্রাউন্ড নোটিফিকেশন পরীক্ষা করুন'
                        : 'Lock screen to verify background notification',
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                  trailing: TextButton(
                    onPressed: () async {
                      await NotificationService().scheduleTwoMinuteTestAlert();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppStrings.get('testNotificationScheduled', _lang)),
                            backgroundColor: AppColors.emeraldDark,
                          ),
                        );
                      }
                    },
                    child: Text(
                      _lang == 'bn' ? 'নির্ধারণ' : 'Schedule',
                      style: const TextStyle(color: AppColors.gold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section 3: Language
          _buildSectionHeader(AppStrings.get('language', _lang)),
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'bn',
                  groupValue: _lang,
                  activeColor: AppColors.gold,
                  title: const Text(
                    'বাংলা (ডিফল্ট)',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'Bangla-first interface with Bengali numbers',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  onChanged: (val) => _updateLanguage('bn'),
                ),
                const Divider(color: AppColors.divider, height: 1),
                RadioListTile<String>(
                  value: 'en',
                  groupValue: _lang,
                  activeColor: AppColors.gold,
                  title: const Text(
                    'English',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'English interface with Western numbers',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  onChanged: (val) => _updateLanguage('en'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section 4: About
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.gold.withOpacity(0.4)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'assets/images/app_icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Hidayah Life',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Version 1.0.0 (Native Flutter)',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textGold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _lang == 'bn'
                      ? 'সম্পূর্ণ বিনামূল্যে ইসলামিক শিক্ষা ও সোশ্যাল নেটওয়ার্কিং প্ল্যাটফর্ম'
                      : 'Free-forever Islamic learning & networking platform',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.goldLight,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
