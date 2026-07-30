import 'package:animes_io/core/error/failures.dart';
import 'package:animes_io/features/anime/domain/repositories/translation_repository.dart';
import 'package:animes_io/features/anime/domain/usecases/translate_synopsis.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTranslationRepository extends Mock implements TranslationRepository {}

void main() {
  late TranslateSynopsis usecase;
  late MockTranslationRepository mockRepository;

  setUp(() {
    mockRepository = MockTranslationRepository();
    usecase = TranslateSynopsis(mockRepository);
  });

  const tAnimeId = '1';
  const tSynopsis = 'Naruto is a young ninja';
  const tTranslated = 'Naruto é um jovem ninja';
  const tParams = TranslateSynopsisParams(
    animeId: tAnimeId,
    synopsisText: tSynopsis,
    targetLang: 'pt',
  );

  test('should return translated text from repository', () async {
    when(() => mockRepository.translateSynopsis(
          animeId: tAnimeId,
          synopsisText: tSynopsis,
          targetLang: 'pt',
        )).thenAnswer((_) async => const Right(tTranslated));

    final result = await usecase(tParams);

    expect(result, equals(const Right(tTranslated)));
    verify(() => mockRepository.translateSynopsis(
          animeId: tAnimeId,
          synopsisText: tSynopsis,
          targetLang: 'pt',
        )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    when(() => mockRepository.translateSynopsis(
          animeId: tAnimeId,
          synopsisText: tSynopsis,
          targetLang: 'pt',
        )).thenAnswer((_) async => const Left(ServerFailure('Quota exceeded')));

    final result = await usecase(tParams);

    expect(result, equals(const Left(ServerFailure('Quota exceeded'))));
  });
}
