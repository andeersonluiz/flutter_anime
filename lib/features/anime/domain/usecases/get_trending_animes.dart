import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/anime.dart';
import '../repositories/anime_repository.dart';

class GetTrendingAnimes {
  const GetTrendingAnimes(this._repository);
  final AnimeRepository _repository;

  Future<Either<Failure, List<Anime>>> call(GetTrendingAnimesParams params) {
    return _repository.getTrendingAnimes(
      offset: params.offset,
      limit: params.limit,
    );
  }
}

class GetTrendingAnimesParams extends Equatable {
  const GetTrendingAnimesParams({this.offset = 0, this.limit = 10});
  final int offset;
  final int limit;

  @override
  List<Object> get props => [offset, limit];
}
