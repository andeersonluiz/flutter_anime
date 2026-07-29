import 'package:animes_io/core/error/exceptions.dart';
import 'package:animes_io/core/error/failures.dart';
import 'package:animes_io/features/anime/data/datasources/anime_local_datasource.dart';
import 'package:animes_io/features/anime/data/datasources/anime_remote_datasource.dart';
import 'package:animes_io/features/anime/data/models/anime_model.dart';
import 'package:animes_io/features/anime/data/repositories/anime_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAnimeRemoteDataSource extends Mock implements AnimeRemoteDataSource {}
class MockAnimeLocalDataSource extends Mock implements AnimeLocalDataSource {}

void main() {
  late AnimeRepositoryImpl repository;
  late MockAnimeRemoteDataSource mockRemoteDataSource;
  late MockAnimeLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockAnimeRemoteDataSource();
    mockLocalDataSource = MockAnimeLocalDataSource();
    repository = AnimeRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tAnimeModel = AnimeModel(
    id: '1',
    title: 'Test Anime',
    synopsis: 'Test Synopsis',
    posterImage: 'test_url',
    rating: 9.0,
    episodeCount: 12,
    status: 'current',
  );

  final tAnimeModelList = [tAnimeModel];
  final tAnimeList = tAnimeModelList.map((m) => m.toEntity()).toList();

  group('getTrendingAnimes', () {
    test('should return remote data when remote call is successful', () async {
      when(() => mockLocalDataSource.getCachedAnimes(any()))
          .thenThrow(const CacheException('Expired'));
      when(() => mockRemoteDataSource.getTrendingAnimes(offset: 0, limit: 10))
          .thenAnswer((_) async => tAnimeModelList);
      when(() => mockLocalDataSource.cacheAnimes(any(), any()))
          .thenAnswer((_) async {});

      final result = await repository.getTrendingAnimes(offset: 0, limit: 10);

      verify(() => mockRemoteDataSource.getTrendingAnimes(offset: 0, limit: 10)).called(1);
      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r, equals(tAnimeList)),
      );
    });

    test('should return ServerFailure when remote call fails', () async {
      when(() => mockLocalDataSource.getCachedAnimes(any()))
          .thenThrow(const CacheException('Expired'));
      when(() => mockRemoteDataSource.getTrendingAnimes(offset: 0, limit: 10))
          .thenThrow(const ServerException('Server Error'));

      final result = await repository.getTrendingAnimes(offset: 0, limit: 10);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (r) => fail('Should be Left'),
      );
    });
  });
}
