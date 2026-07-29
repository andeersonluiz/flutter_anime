import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/anime.dart';
import '../repositories/anime_repository.dart';

class GetAnimesByCategory {
  const GetAnimesByCategory(this._repository);
  final AnimeRepository _repository;

  Future<Either<Failure, List<Anime>>> call(GetAnimesByCategoryParams params) {
    return _repository.getAnimesByCategory(
      params.categorySlug,
      offset: params.offset,
      limit: params.limit,
    );
  }
}

class GetAnimesByCategoryParams extends Equatable {
  const GetAnimesByCategoryParams(
      {required this.categorySlug, this.offset = 0, this.limit = 10});
  final String categorySlug;
  final int offset;
  final int limit;

  @override
  List<Object> get props => [categorySlug, offset, limit];
}
