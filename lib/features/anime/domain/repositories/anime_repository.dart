import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/anime.dart';

abstract class AnimeRepository {
  Future<Either<Failure, List<Anime>>> getTrendingAnimes({int offset = 0, int limit = 10});
  Future<Either<Failure, List<Anime>>> getMostPopularAnimes({int offset = 0, int limit = 10});
  Future<Either<Failure, List<Anime>>> getTopRatedAnimes({int offset = 0, int limit = 10});
  Future<Either<Failure, List<Anime>>> getUpcomingAnimes({int offset = 0, int limit = 10});
  Future<Either<Failure, List<Anime>>> getCurrentlyAiringAnimes({int offset = 0, int limit = 10});
  Future<Either<Failure, Anime>> getAnimeDetails(String id);
  Future<Either<Failure, List<Anime>>> searchAnimes(String query, {int offset = 0, int limit = 10});
  Future<Either<Failure, List<Anime>>> getAnimesByCategory(String categorySlug, {int offset = 0, int limit = 10});
}
