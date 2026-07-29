import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/anime.dart';
import '../../domain/repositories/anime_repository.dart';
import '../datasources/anime_local_datasource.dart';
import '../datasources/anime_remote_datasource.dart';
import '../models/anime_model.dart';

class AnimeRepositoryImpl implements AnimeRepository {
  const AnimeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final AnimeRemoteDataSource remoteDataSource;
  final AnimeLocalDataSource localDataSource;

  Future<Either<Failure, List<Anime>>> _fetchList(
    String cacheKey,
    Future<List<AnimeModel>> Function() remoteFetch,
  ) async {
    try {
      final localAnimes = await localDataSource.getCachedAnimes(cacheKey);
      return Right(localAnimes.map((e) => e.toEntity()).toList());
    } on CacheException {
      try {
        final remoteAnimes = await remoteFetch();
        await localDataSource.cacheAnimes(cacheKey, remoteAnimes);
        return Right(remoteAnimes.map((e) => e.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Server error occurred'));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<Anime>>> getTrendingAnimes({int offset = 0, int limit = 10}) async {
    return _fetchList(
      'anime_trending_$offset',
      () => remoteDataSource.getTrendingAnimes(offset: offset, limit: limit),
    );
  }

  @override
  Future<Either<Failure, List<Anime>>> getMostPopularAnimes({int offset = 0, int limit = 10}) async {
    return _fetchList(
      'anime_popular_$offset',
      () => remoteDataSource.getMostPopularAnimes(offset: offset, limit: limit),
    );
  }

  @override
  Future<Either<Failure, List<Anime>>> getTopRatedAnimes({int offset = 0, int limit = 10}) async {
    return _fetchList(
      'anime_top_rated_$offset',
      () => remoteDataSource.getTopRatedAnimes(offset: offset, limit: limit),
    );
  }

  @override
  Future<Either<Failure, List<Anime>>> getUpcomingAnimes({int offset = 0, int limit = 10}) async {
    return _fetchList(
      'anime_upcoming_$offset',
      () => remoteDataSource.getUpcomingAnimes(offset: offset, limit: limit),
    );
  }

  @override
  Future<Either<Failure, List<Anime>>> getCurrentlyAiringAnimes({int offset = 0, int limit = 10}) async {
    return _fetchList(
      'anime_airing_$offset',
      () => remoteDataSource.getCurrentlyAiringAnimes(offset: offset, limit: limit),
    );
  }

  @override
  Future<Either<Failure, List<Anime>>> searchAnimes(String query, {int offset = 0, int limit = 10}) async {
    try {
      final remoteAnimes = await remoteDataSource.searchAnimes(query, offset: offset, limit: limit);
      return Right(remoteAnimes.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Anime>>> getAnimesByCategory(String categorySlug, {int offset = 0, int limit = 10}) async {
    return _fetchList(
      'anime_category_${categorySlug}_$offset',
      () => remoteDataSource.getAnimesByCategory(categorySlug, offset: offset, limit: limit),
    );
  }

  @override
  Future<Either<Failure, Anime>> getAnimeDetails(String id) async {
    try {
      final remoteAnime = await remoteDataSource.getAnimeDetails(id);
      return Right(remoteAnime.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
