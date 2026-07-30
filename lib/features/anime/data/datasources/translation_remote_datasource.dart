import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';

abstract class TranslationRemoteDataSource {
  Future<String> translateText({
    required String text,
    required String sourceLang,
    required String targetLang,
  });
}

class TranslationRemoteDataSourceImpl implements TranslationRemoteDataSource {
  final Dio dio;

  TranslationRemoteDataSourceImpl({required this.dio});

  @override
  Future<String> translateText({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    // Strategy 1: Google Translate Free GTX Endpoint (Fastest, Unlimited, No API Key)
    try {
      final response = await dio.get<dynamic>(
        'https://translate.googleapis.com/translate_a/single',
        queryParameters: {
          'client': 'gtx',
          'sl': sourceLang,
          'tl': targetLang,
          'dt': 't',
          'q': text,
        },
        options: Options(
          sendTimeout: const Duration(seconds: 6),
          receiveTimeout: const Duration(seconds: 6),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> outerList = response.data[0] as List<dynamic>;
        final StringBuffer buffer = StringBuffer();

        for (final item in outerList) {
          if (item is List && item.isNotEmpty && item[0] != null) {
            buffer.write(item[0].toString());
          }
        }

        final result = buffer.toString().trim();
        if (result.isNotEmpty) {
          return result;
        }
      }
    } catch (_) {
      // Fallback to strategy 2
    }

    // Strategy 2: MyMemory Translation API
    try {
      final response = await dio.get<Map<String, dynamic>>(
        'https://api.mymemory.translated.net/get',
        queryParameters: {
          'q': text,
          'langpair': '$sourceLang|$targetLang',
        },
        options: Options(
          sendTimeout: const Duration(seconds: 6),
          receiveTimeout: const Duration(seconds: 6),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final responseData =
            response.data!['responseData'] as Map<String, dynamic>?;
        final translated = responseData?['translatedText'] as String?;
        if (translated != null &&
            translated.isNotEmpty &&
            !translated.contains('MYMEMORY WARNING')) {
          return translated;
        }
      }
    } catch (_) {
      // Fallback to strategy 3
    }

    // Strategy 3: LibreTranslate Open Mirror (Argos OpenTech)
    try {
      final response = await dio.post<Map<String, dynamic>>(
        'https://translate.argosopentech.com/translate',
        data: {
          'q': text,
          'source': sourceLang,
          'target': targetLang,
          'format': 'text',
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: const Duration(seconds: 6),
          receiveTimeout: const Duration(seconds: 6),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final translated = response.data!['translatedText'] as String?;
        if (translated != null && translated.isNotEmpty) {
          return translated;
        }
      }
    } catch (_) {
      // All strategies exhausted
    }

    throw const ServerException(
        'Translation service unavailable at the moment. Please try again later.');
  }
}
