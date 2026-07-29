import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/anime.dart';
import '../repositories/anime_repository.dart';

class GetAnimeDetails {
  const GetAnimeDetails(this._repository);
  final AnimeRepository _repository;

  Future<Either<Failure, Anime>> call(GetAnimeDetailsParams params) {
    return _repository.getAnimeDetails(params.id);
  }
}

class GetAnimeDetailsParams extends Equatable {
  const GetAnimeDetailsParams({required this.id});
  final String id;

  @override
  List<Object> get props => [id];
}
