import 'package:hive/hive.dart';

abstract class TranslationLocalDataSource {
  Future<void> cacheTranslation({
    required String animeId,
    required String targetLang,
    required String translatedText,
  });

  Future<String?> getCachedTranslation({
    required String animeId,
    required String targetLang,
  });
}

class TranslationLocalDataSourceImpl implements TranslationLocalDataSource {
  static const String boxName = 'synopsis_translations_box';

  Future<Box<String>> _getBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<String>(boxName);
    }
    return await Hive.openBox<String>(boxName);
  }

  @override
  Future<void> cacheTranslation({
    required String animeId,
    required String targetLang,
    required String translatedText,
  }) async {
    final box = await _getBox();
    await box.put('synopsis_${animeId}_$targetLang', translatedText);
  }

  @override
  Future<String?> getCachedTranslation({
    required String animeId,
    required String targetLang,
  }) async {
    final box = await _getBox();
    return box.get('synopsis_${animeId}_$targetLang');
  }
}
