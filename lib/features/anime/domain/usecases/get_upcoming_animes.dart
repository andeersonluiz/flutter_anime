import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/anime.dart';
import '../repositories/anime_repository.dart';

class GetUpcomingAnimes {
  const GetUpcomingAnimes(this._repository);
  final AnimeRepository _repository;

  Future<Either<Failure, List<Anime>>> call(GetUpcomingAnimesParams params) {
    return _repository.getUpcomingAnimes(
      offset: params.offset,
      limit: params.limit,
    );
  }
}

class GetUpcomingAnimesParams extends Equatable {
  const GetUpcomingAnimesParams({this.offset = 0, this.limit = 10});
  final int offset;
  final int limit;

  @override
  List<Object> get props => [offset, limit];
}
