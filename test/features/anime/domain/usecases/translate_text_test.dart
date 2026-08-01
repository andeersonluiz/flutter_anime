import 'package:animes_io/core/error/failures.dart';
import 'package:animes_io/features/anime/domain/repositories/translation_repository.dart';
import 'package:animes_io/features/anime/domain/usecases/translate_text.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTranslationRepository extends Mock implements TranslationRepository {}

void main() {
  late TranslateText usecase;
  late MockTranslationRepository repository;

  setUp(() {
    repository = MockTranslationRepository();
    usecase = TranslateText(repository);
  });

  const params = TranslateTextParams(text: 'Hello', targetLang: 'pt');

  test('returns the translated text from the repository', () async {
    when(() => repository.translateText(text: 'Hello', targetLang: 'pt'))
        .thenAnswer((_) async => const Right('Olá'));

    final result = await usecase(params);

    expect(result, equals(const Right('Olá')));
    verify(() => repository.translateText(text: 'Hello', targetLang: 'pt'))
        .called(1);
  });

  test('propagates a translation failure', () async {
    const failure = ServerFailure('Translation unavailable');
    when(() => repository.translateText(text: 'Hello', targetLang: 'pt'))
        .thenAnswer((_) async => const Left(failure));

    final result = await usecase(params);

    expect(result, equals(const Left(failure)));
  });
}
