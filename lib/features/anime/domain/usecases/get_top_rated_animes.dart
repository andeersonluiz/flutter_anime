import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/anime.dart';
import '../repositories/anime_repository.dart';

class GetTopRatedAnimes {
  const GetTopRatedAnimes(this._repository);
  final AnimeRepository _repository;

  Future<Either<Failure, List<Anime>>> call(GetTopRatedAnimesParams params) {
    return _repository.getTopRatedAnimes(
      offset: params.offset,
      limit: params.limit,
    );
  }
}

class GetTopRatedAnimesParams extends Equatable {
  const GetTopRatedAnimesParams({this.offset = 0, this.limit = 10});
  final int offset;
  final int limit;

  @override
  List<Object> get props => [offset, limit];
}
