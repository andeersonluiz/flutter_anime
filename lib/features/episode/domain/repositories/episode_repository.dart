import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/episode.dart';

abstract class EpisodeRepository {
  Future<Either<Failure, List<Episode>>> getEpisodes(String animeId,
      {int offset = 0, int limit = 20});
}
