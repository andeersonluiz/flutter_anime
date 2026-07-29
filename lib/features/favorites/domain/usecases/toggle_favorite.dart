import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/favorites_repository.dart';

class ToggleFavorite {
  final FavoritesRepository repository;

  ToggleFavorite(this.repository);

  Future<Either<Failure, Unit>> call(String userId, String animeId) async {
    final isFavResult = await repository.isFavorite(userId, animeId);
    return isFavResult.fold(
      (failure) => Left(failure),
      (isFav) async {
        if (isFav) {
          return await repository.removeFavorite(userId, animeId);
        } else {
          return await repository.addFavorite(userId, animeId);
        }
      },
    );
  }
}
