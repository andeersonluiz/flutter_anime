import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/episode.dart';
import '../repositories/episode_repository.dart';

class GetEpisodes {
  final EpisodeRepository repository;

  GetEpisodes(this.repository);

  Future<Either<Failure, List<Episode>>> call(String animeId,
      {int offset = 0, int limit = 20}) async {
    return await repository.getEpisodes(animeId, offset: offset, limit: limit);
  }
}
