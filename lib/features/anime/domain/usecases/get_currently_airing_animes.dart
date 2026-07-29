import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/anime.dart';
import '../repositories/anime_repository.dart';

class GetCurrentlyAiringAnimes {
  const GetCurrentlyAiringAnimes(this._repository);
  final AnimeRepository _repository;

  Future<Either<Failure, List<Anime>>> call(GetCurrentlyAiringAnimesParams params) {
    return _repository.getCurrentlyAiringAnimes(
      offset: params.offset,
      limit: params.limit,
    );
  }
}

class GetCurrentlyAiringAnimesParams extends Equatable {
  const GetCurrentlyAiringAnimesParams({this.offset = 0, this.limit = 10});
  final int offset;
  final int limit;

  @override
  List<Object> get props => [offset, limit];
}
