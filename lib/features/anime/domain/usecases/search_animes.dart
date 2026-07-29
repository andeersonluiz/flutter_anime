import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/anime.dart';
import '../repositories/anime_repository.dart';

class SearchAnimes {
  const SearchAnimes(this._repository);
  final AnimeRepository _repository;

  Future<Either<Failure, List<Anime>>> call(SearchAnimesParams params) {
    return _repository.searchAnimes(
      params.query,
      offset: params.offset,
      limit: params.limit,
    );
  }
}

class SearchAnimesParams extends Equatable {
  const SearchAnimesParams({required this.query, this.offset = 0, this.limit = 10});
  final String query;
  final int offset;
  final int limit;

  @override
  List<Object> get props => [query, offset, limit];
}
