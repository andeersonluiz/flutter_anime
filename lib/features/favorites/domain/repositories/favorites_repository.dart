import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<String>>> getFavorites(String userId);
  Future<Either<Failure, Unit>> addFavorite(String userId, String animeId);
  Future<Either<Failure, Unit>> removeFavorite(String userId, String animeId);
  Future<Either<Failure, bool>> isFavorite(String userId, String animeId);
}
