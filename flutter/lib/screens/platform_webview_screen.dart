import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../services/storage_service.dart';

class PlatformWebviewScreen extends StatefulWidget {
  const PlatformWebviewScreen({super.key});

  @override
  State<PlatformWebviewScreen> createState() => _PlatformWebviewScreenState();
}

class _PlatformWebviewScreenState extends State<PlatformWebviewScreen> {
  static const String siteUrl = 'https://hidayah-life.vercel.app';
  WebViewController? _controller;
  double _progress = 0;
  bool _hasError = false;
  String _lang = 'bn';

  @override
  void initState() {
    super.initState();
    _lang = StorageService.getLanguage();

    if (!kIsWeb && !Platform.isWindows) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..setNavigationDelegate(NavigationDelegate(
          onProgress: (p) => setState(() => _progress = p / 100),
          onPageStarted: (_) => setState(() => _hasError = false),
          onPageFinished: (_) => setState(() => _progress = 1.0),
          onWebResourceError: (_) => setState(() => _hasError = true),
        ))
        ..loadRequest(Uri.parse(siteUrl));
    }
  }

  Future<void> _openExternal() async {
    final uri = Uri.parse(siteUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb && Platform.isWindows) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.get('platform', _lang),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Text(
                'hidayah-life.vercel.app',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.emeraldLight,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: AppStrings.get('openInBrowser', _lang),
              icon: const Icon(Icons.open_in_browser_rounded, color: AppColors.textPrimary),
              onPressed: _openExternal,
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.mosque_rounded,
                  size: 72,
                  color: AppColors.gold,
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.get('platform', _lang),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'hidayah-life.vercel.app',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.emeraldLight,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _lang == 'bn'
                      ? 'সম্পূর্ণ প্ল্যাটফর্ম ব্রাউজারে খুলুন'
                      : 'Open the full platform in your browser',
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: const Color(0xFF041A13),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _openExternal,
                  icon: const Icon(Icons.open_in_browser_rounded),
                  label: Text(AppStrings.get('openInBrowser', _lang)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.get('platform', _lang),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const Text(
              'hidayah-life.vercel.app',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.emeraldLight,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: AppStrings.get('refresh', _lang),
            icon: const Icon(Icons.refresh_rounded, color: AppColors.gold),
            onPressed: () {
              _controller?.reload();
            },
          ),
          IconButton(
            tooltip: AppStrings.get('openInBrowser', _lang),
            icon: const Icon(Icons.open_in_browser_rounded, color: AppColors.textPrimary),
            onPressed: _openExternal,
          ),
        ],
        bottom: _progress > 0 && _progress < 1.0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(3.0),
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: AppColors.surface,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                  minHeight: 3,
                ),
              )
            : null,
      ),
      body: Stack(
        children: [
          if (_controller != null)
            WebViewWidget(controller: _controller!),
          if (_hasError)
            Container(
              color: AppColors.background,
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off_rounded,
                      size: 64,
                      color: AppColors.gold,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _lang == 'bn'
                          ? 'ওয়েবসাইট লোড করা যায়নি'
                          : 'Unable to Load Platform',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _lang == 'bn'
                          ? 'ইন্টারনেট সংযোগ পরীক্ষা করুন অথবা ব্রাউজারে খুলুন।'
                          : 'Check internet connection or open in browser.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.surface,
                            foregroundColor: AppColors.gold,
                            side: const BorderSide(color: AppColors.gold),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () => _controller?.reload(),
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(AppStrings.get('refresh', _lang)),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: const Color(0xFF041A13),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onPressed: _openExternal,
                          icon: const Icon(Icons.open_in_browser_rounded),
                          label: Text(AppStrings.get('openInBrowser', _lang)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
