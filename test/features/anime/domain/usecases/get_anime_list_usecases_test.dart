import 'package:animes_io/core/error/failures.dart';
import 'package:animes_io/features/anime/domain/entities/anime.dart';
import 'package:animes_io/features/anime/domain/repositories/anime_repository.dart';
import 'package:animes_io/features/anime/domain/usecases/get_most_popular_animes.dart';
import 'package:animes_io/features/anime/domain/usecases/get_top_rated_animes.dart';
import 'package:animes_io/features/anime/domain/usecases/get_upcoming_animes.dart';
import 'package:animes_io/features/anime/domain/usecases/get_currently_airing_animes.dart';
import 'package:animes_io/features/anime/domain/usecases/get_animes_by_category.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAnimeRepository extends Mock implements AnimeRepository {}

void main() {
  late MockAnimeRepository mockRepo;

  const tAnime = Anime(
    id: '1',
    title: 'Test Anime',
    synopsis: 'Test Synopsis',
    status: 'current',
  );
  const tList = [tAnime];

  setUp(() {
    mockRepo = MockAnimeRepository();
  });

  group('GetMostPopularAnimes', () {
    late GetMostPopularAnimes usecase;
    setUp(() => usecase = GetMostPopularAnimes(mockRepo));

    test('should return list from repository', () async {
      when(() => mockRepo.getMostPopularAnimes(offset: 0, limit: 10))
          .thenAnswer((_) async => const Right<Failure, List<Anime>>(tList));

      final result =
          await usecase(const GetMostPopularAnimesParams(offset: 0, limit: 10));

      expect(result, const Right<Failure, List<Anime>>(tList));
      verify(() => mockRepo.getMostPopularAnimes(offset: 0, limit: 10))
          .called(1);
    });

    test('should return failure when repository fails', () async {
      when(() => mockRepo.getMostPopularAnimes(offset: 0, limit: 10))
          .thenAnswer((_) async =>
              const Left<Failure, List<Anime>>(ServerFailure('error')));

      final result =
          await usecase(const GetMostPopularAnimesParams(offset: 0, limit: 10));

      expect(result, const Left<Failure, List<Anime>>(ServerFailure('error')));
    });
  });

  group('GetTopRatedAnimes', () {
    late GetTopRatedAnimes usecase;
    setUp(() => usecase = GetTopRatedAnimes(mockRepo));

    test('should return list from repository', () async {
      when(() => mockRepo.getTopRatedAnimes(offset: 0, limit: 10))
          .thenAnswer((_) async => const Right<Failure, List<Anime>>(tList));

      final result =
          await usecase(const GetTopRatedAnimesParams(offset: 0, limit: 10));

      expect(result, const Right<Failure, List<Anime>>(tList));
      verify(() => mockRepo.getTopRatedAnimes(offset: 0, limit: 10)).called(1);
    });
  });

  group('GetUpcomingAnimes', () {
    late GetUpcomingAnimes usecase;
    setUp(() => usecase = GetUpcomingAnimes(mockRepo));

    test('should return list from repository', () async {
      when(() => mockRepo.getUpcomingAnimes(offset: 0, limit: 10))
          .thenAnswer((_) async => const Right<Failure, List<Anime>>(tList));

      final result =
          await usecase(const GetUpcomingAnimesParams(offset: 0, limit: 10));

      expect(result, const Right<Failure, List<Anime>>(tList));
      verify(() => mockRepo.getUpcomingAnimes(offset: 0, limit: 10)).called(1);
    });
  });

  group('GetCurrentlyAiringAnimes', () {
    late GetCurrentlyAiringAnimes usecase;
    setUp(() => usecase = GetCurrentlyAiringAnimes(mockRepo));

    test('should return list from repository', () async {
      when(() => mockRepo.getCurrentlyAiringAnimes(offset: 0, limit: 10))
          .thenAnswer((_) async => const Right<Failure, List<Anime>>(tList));

      final result = await usecase(
          const GetCurrentlyAiringAnimesParams(offset: 0, limit: 10));

      expect(result, const Right<Failure, List<Anime>>(tList));
      verify(() => mockRepo.getCurrentlyAiringAnimes(offset: 0, limit: 10))
          .called(1);
    });
  });

  group('GetAnimesByCategory', () {
    late GetAnimesByCategory usecase;
    setUp(() => usecase = GetAnimesByCategory(mockRepo));

    test('should return list from repository', () async {
      when(() => mockRepo.getAnimesByCategory('action', offset: 0, limit: 10))
          .thenAnswer((_) async => const Right<Failure, List<Anime>>(tList));

      final result = await usecase(const GetAnimesByCategoryParams(
          categorySlug: 'action', offset: 0, limit: 10));

      expect(result, const Right<Failure, List<Anime>>(tList));
      verify(() => mockRepo.getAnimesByCategory('action', offset: 0, limit: 10))
          .called(1);
    });
  });
}
