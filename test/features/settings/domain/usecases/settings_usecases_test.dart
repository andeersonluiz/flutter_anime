import 'package:animes_io/core/error/failures.dart';
import 'package:animes_io/features/settings/domain/repositories/settings_repository.dart';
import 'package:animes_io/features/settings/domain/usecases/change_language.dart';
import 'package:animes_io/features/settings/domain/usecases/toggle_theme.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository mockRepo;

  setUp(() {
    mockRepo = MockSettingsRepository();
  });

  group('ChangeLanguage', () {
    late ChangeLanguage usecase;
    setUp(() => usecase = ChangeLanguage(mockRepo));

    test('should call saveLanguage on repository', () async {
      when(() => mockRepo.saveLanguage('pt'))
          .thenAnswer((_) async => const Right<Failure, Unit>(unit));

      final result = await usecase('pt');

      expect(result.isRight(), true);
      verify(() => mockRepo.saveLanguage('pt')).called(1);
    });

    test('should return failure when repo fails', () async {
      when(() => mockRepo.saveLanguage('pt')).thenAnswer(
          (_) async => const Left<Failure, Unit>(CacheFailure('error')));

      final result = await usecase('pt');

      expect(result.isLeft(), true);
    });
  });

  group('ToggleTheme', () {
    late ToggleTheme usecase;
    setUp(() => usecase = ToggleTheme(mockRepo));

    test('should call saveTheme on repository', () async {
      when(() => mockRepo.saveTheme(true))
          .thenAnswer((_) async => const Right<Failure, Unit>(unit));

      final result = await usecase(true);

      expect(result.isRight(), true);
      verify(() => mockRepo.saveTheme(true)).called(1);
    });

    test('should return failure when repo fails', () async {
      when(() => mockRepo.saveTheme(false)).thenAnswer(
          (_) async => const Left<Failure, Unit>(CacheFailure('error')));

      final result = await usecase(false);

      expect(result.isLeft(), true);
    });
  });
}
