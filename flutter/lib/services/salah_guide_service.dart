import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/salah_step.dart';

class SalahGuideService {
  static final SalahGuideService _instance = SalahGuideService._internal();
  factory SalahGuideService() => _instance;
  SalahGuideService._internal();

  List<SalahStep> _steps = [];
  bool _isLoaded = false;

  List<SalahStep> get steps => List.unmodifiable(_steps);
  bool get isLoaded => _isLoaded;

  Future<void> init() async {
    if (_isLoaded) return;

    final jsonString = await rootBundle.loadString('assets/data/salah_adhkar.json');
    final Map<String, dynamic> data = jsonDecode(jsonString);
    final List<dynamic> items = data['items'] as List<dynamic>;

    _steps = items.map((e) => SalahStep.fromJson(e as Map<String, dynamic>)).toList();
    _steps.sort((a, b) => a.order.compareTo(b.order));

    _isLoaded = true;
  }
}
