import 'package:animes_io/core/error/exceptions.dart';
import 'package:animes_io/core/error/failures.dart';
import 'package:animes_io/features/anime/data/models/anime_model.dart';
import 'package:animes_io/features/anime/data/repositories/anime_repository_impl.dart';
import 'package:animes_io/features/anime/domain/usecases/get_animes_by_category.dart';
import 'package:animes_io/features/anime/domain/usecases/get_currently_airing_animes.dart';
import 'package:animes_io/features/anime/domain/usecases/get_most_popular_animes.dart';
import 'package:animes_io/features/anime/domain/usecases/get_top_rated_animes.dart';
import 'package:animes_io/features/anime/domain/usecases/get_upcoming_animes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'anime/data/repositories/anime_repository_impl_test.dart';

void main() {
  group('AnimeRepositoryImpl additional methods', () {
    late AnimeRepositoryImpl repository;
    late MockAnimeRemoteDataSource mockRemote;
    late MockAnimeLocalDataSource mockLocal;

    const tAnimeModel = AnimeModel(
      id: '1',
      title: 'Test Anime',
      synopsis: 'Synopsis',
      status: 'current',
    );
    final tModelList = [tAnimeModel];

    setUp(() {
      mockRemote = MockAnimeRemoteDataSource();
      mockLocal = MockAnimeLocalDataSource();
      repository = AnimeRepositoryImpl(
        remoteDataSource: mockRemote,
        localDataSource: mockLocal,
      );
    });

    test(
        'getMostPopularAnimes fetches from remote on cache miss and caches result',
        () async {
      when(() => mockLocal.getCachedAnimes('anime_popular_0'))
          .thenThrow(const CacheException('Cache miss'));
      when(() => mockRemote.getMostPopularAnimes(offset: 0, limit: 10))
          .thenAnswer((_) async => tModelList);
      when(() => mockLocal.cacheAnimes('anime_popular_0', tModelList))
          .thenAnswer((_) async {});

      final result =
          await repository.getMostPopularAnimes(offset: 0, limit: 10);
      expect(result.isRight(), true);
      verify(() => mockLocal.cacheAnimes('anime_popular_0', tModelList))
          .called(1);
    });

    test(
        'getTopRatedAnimes fetches from remote on cache miss and caches result',
        () async {
      when(() => mockLocal.getCachedAnimes('anime_top_rated_0'))
          .thenThrow(const CacheException('Cache miss'));
      when(() => mockRemote.getTopRatedAnimes(offset: 0, limit: 10))
          .thenAnswer((_) async => tModelList);
      when(() => mockLocal.cacheAnimes('anime_top_rated_0', tModelList))
          .thenAnswer((_) async {});

      final result = await repository.getTopRatedAnimes(offset: 0, limit: 10);
      expect(result.isRight(), true);
      verify(() => mockLocal.cacheAnimes('anime_top_rated_0', tModelList))
          .called(1);
    });

    test(
        'getUpcomingAnimes fetches from remote on cache miss and caches result',
        () async {
      when(() => mockLocal.getCachedAnimes('anime_upcoming_0'))
          .thenThrow(const CacheException('Cache miss'));
      when(() => mockRemote.getUpcomingAnimes(offset: 0, limit: 10))
          .thenAnswer((_) async => tModelList);
      when(() => mockLocal.cacheAnimes('anime_upcoming_0', tModelList))
          .thenAnswer((_) async {});

      final result = await repository.getUpcomingAnimes(offset: 0, limit: 10);
      expect(result.isRight(), true);
      verify(() => mockLocal.cacheAnimes('anime_upcoming_0', tModelList))
          .called(1);
    });

    test(
        'getCurrentlyAiringAnimes fetches from remote on cache miss and caches result',
        () async {
      when(() => mockLocal.getCachedAnimes('anime_airing_0'))
          .thenThrow(const CacheException('Cache miss'));
      when(() => mockRemote.getCurrentlyAiringAnimes(offset: 0, limit: 10))
          .thenAnswer((_) async => tModelList);
      when(() => mockLocal.cacheAnimes('anime_airing_0', tModelList))
          .thenAnswer((_) async {});

      final result =
          await repository.getCurrentlyAiringAnimes(offset: 0, limit: 10);
      expect(result.isRight(), true);
      verify(() => mockLocal.cacheAnimes('anime_airing_0', tModelList))
          .called(1);
    });

    test(
        'getAnimesByCategory fetches from remote on cache miss and caches result',
        () async {
      when(() => mockLocal.getCachedAnimes('anime_category_action_0'))
          .thenThrow(const CacheException('Cache miss'));
      when(() => mockRemote.getAnimesByCategory('action', offset: 0, limit: 10))
          .thenAnswer((_) async => tModelList);
      when(() => mockLocal.cacheAnimes('anime_category_action_0', tModelList))
          .thenAnswer((_) async {});

      final result =
          await repository.getAnimesByCategory('action', offset: 0, limit: 10);
      expect(result.isRight(), true);
      verify(() => mockLocal.cacheAnimes('anime_category_action_0', tModelList))
          .called(1);
    });

    test('returns Left(ServerFailure) on generic remote exception', () async {
      when(() => mockLocal.getCachedAnimes('anime_popular_0'))
          .thenThrow(const CacheException('Cache miss'));
      when(() => mockRemote.getMostPopularAnimes(offset: 0, limit: 10))
          .thenThrow(Exception('unexpected remote error'));

      final result =
          await repository.getMostPopularAnimes(offset: 0, limit: 10);
      expect(result.isLeft(), true);
    });
  });

  group('Anime UseCase Params props', () {
    test('GetMostPopularAnimesParams props', () {
      const params1 = GetMostPopularAnimesParams(offset: 0, limit: 10);
      const params2 = GetMostPopularAnimesParams(offset: 0, limit: 10);
      expect(params1.props, params2.props);
    });

    test('GetTopRatedAnimesParams props', () {
      const params1 = GetTopRatedAnimesParams(offset: 0, limit: 10);
      const params2 = GetTopRatedAnimesParams(offset: 0, limit: 10);
      expect(params1.props, params2.props);
    });

    test('GetUpcomingAnimesParams props', () {
      const params1 = GetUpcomingAnimesParams(offset: 0, limit: 10);
      const params2 = GetUpcomingAnimesParams(offset: 0, limit: 10);
      expect(params1.props, params2.props);
    });

    test('GetCurrentlyAiringAnimesParams props', () {
      const params1 = GetCurrentlyAiringAnimesParams(offset: 0, limit: 10);
      const params2 = GetCurrentlyAiringAnimesParams(offset: 0, limit: 10);
      expect(params1.props, params2.props);
    });

    test('GetAnimesByCategoryParams props', () {
      const params1 = GetAnimesByCategoryParams(
          categorySlug: 'action', offset: 0, limit: 10);
      const params2 = GetAnimesByCategoryParams(
          categorySlug: 'action', offset: 0, limit: 10);
      expect(params1.props, params2.props);
    });
  });
}
