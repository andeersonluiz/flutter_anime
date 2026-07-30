import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/translation_repository.dart';
import '../datasources/translation_local_datasource.dart';
import '../datasources/translation_remote_datasource.dart';

class TranslationRepositoryImpl implements TranslationRepository {
  final TranslationRemoteDataSource remoteDataSource;
  final TranslationLocalDataSource localDataSource;

  TranslationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, String>> translateSynopsis({
    required String animeId,
    required String synopsisText,
    required String targetLang,
  }) async {
    try {
      // 1. Try local cache first
      final cached = await localDataSource.getCachedTranslation(
        animeId: animeId,
        targetLang: targetLang,
      );

      if (cached != null && cached.isNotEmpty) {
        return Right(cached);
      }

      // 2. Fetch from remote LibreTranslate API
      final translated = await remoteDataSource.translateText(
        text: synopsisText,
        sourceLang: 'en',
        targetLang: targetLang,
      );

      // 3. Save to Hive local cache
      await localDataSource.cacheTranslation(
        animeId: animeId,
        targetLang: targetLang,
        translatedText: translated,
      );

      return Right(translated);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
