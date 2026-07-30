import 'dart:convert';
import 'package:flutter/services.dart';

class AppLocalization {
  static final Map<String, Map<String, String>> _localizedStrings = {};
  static String _currentLanguage = 'en';

  static String get currentLanguage => _currentLanguage;

  static Future<void> init([String initialLanguage = 'en']) async {
    _currentLanguage = initialLanguage;
    await _loadLanguage('en');
    await _loadLanguage('pt');
  }

  static Future<void> _loadLanguage(String lang) async {
    try {
      final jsonString = await rootBundle.loadString('assets/i18n/$lang.json');
      final Map<String, dynamic> jsonMap =
          jsonDecode(jsonString) as Map<String, dynamic>;

      final Map<String, String> flattened = {};
      _flattenJson(jsonMap, '', flattened);
      _localizedStrings[lang] = flattened;
    } on Exception catch (_) {
      _localizedStrings[lang] = {};
    }
  }

  static void _flattenJson(
      Map<String, dynamic> json, String prefix, Map<String, String> result) {
    json.forEach((key, value) {
      final newKey = prefix.isEmpty ? key : '$prefix.$key';
      if (value is Map<String, dynamic>) {
        _flattenJson(value, newKey, result);
      } else {
        result[newKey] = value.toString();
      }
    });
  }

  static void setLanguage(String lang) {
    if (_localizedStrings.containsKey(lang)) {
      _currentLanguage = lang;
    }
  }

  static String translate(String key) {
    return _localizedStrings[_currentLanguage]?[key] ?? key;
  }
}
