import 'package:hive_flutter/hive_flutter.dart';
import 'package:translator/translator.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TranslationService {
  final GoogleTranslator _translator;
  final Box<String> _cacheBox;

  TranslationService({
    GoogleTranslator? translator,
    Box<String>? cacheBox,
  })  : _translator = translator ?? GoogleTranslator(),
        _cacheBox = cacheBox ?? Hive.box<String>('translations_box');

  /// Translates [text] to [targetLanguage]. Uses Hive cache to prevent repeated API calls.
  Future<String> translate(String text, {String targetLanguage = 'pt'}) async {
    if (text.trim().isEmpty) return text;

    final cacheKey = '${text.hashCode}_$targetLanguage';

    // Check cache
    if (_cacheBox.containsKey(cacheKey)) {
      return _cacheBox.get(cacheKey)!;
    }

    try {
      final translation = await _translator.translate(text, to: targetLanguage);
      final translatedText = translation.text;

      // Save to cache
      await _cacheBox.put(cacheKey, translatedText);
      return translatedText;
    } on Object {
      // If translation fails (network error, API limit), return original text
      return text;
    }
  }
}
