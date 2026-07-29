import 'package:animes_io/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:animes_io/features/favorites/domain/usecases/toggle_favorite.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late ToggleFavorite usecase;
  late MockFavoritesRepository mockFavoritesRepository;

  setUp(() {
    mockFavoritesRepository = MockFavoritesRepository();
    usecase = ToggleFavorite(mockFavoritesRepository);
  });

  const tUserId = 'user123';
  const tAnimeId = 'anime123';

  test('should call addFavorite when anime is not yet favorite', () async {
    when(() => mockFavoritesRepository.isFavorite(tUserId, tAnimeId))
        .thenAnswer((_) async => const Right(false));
    when(() => mockFavoritesRepository.addFavorite(tUserId, tAnimeId))
        .thenAnswer((_) async => const Right(unit));

    final result = await usecase(tUserId, tAnimeId);

    expect(result, const Right(unit));
    verify(() => mockFavoritesRepository.isFavorite(tUserId, tAnimeId)).called(1);
    verify(() => mockFavoritesRepository.addFavorite(tUserId, tAnimeId)).called(1);
  });

  test('should call removeFavorite when anime is already favorite', () async {
    when(() => mockFavoritesRepository.isFavorite(tUserId, tAnimeId))
        .thenAnswer((_) async => const Right(true));
    when(() => mockFavoritesRepository.removeFavorite(tUserId, tAnimeId))
        .thenAnswer((_) async => const Right(unit));

    final result = await usecase(tUserId, tAnimeId);

    expect(result, const Right(unit));
    verify(() => mockFavoritesRepository.isFavorite(tUserId, tAnimeId)).called(1);
    verify(() => mockFavoritesRepository.removeFavorite(tUserId, tAnimeId)).called(1);
  });
}
