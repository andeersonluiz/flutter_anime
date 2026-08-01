import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class TranslationRepository {
  Future<Either<Failure, String>> translateText({
    required String text,
    required String targetLang,
  });

  Future<Either<Failure, String>> translateSynopsis({
    required String animeId,
    required String synopsisText,
    required String targetLang,
  });
}
