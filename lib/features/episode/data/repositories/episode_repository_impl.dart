import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/episode.dart';
import '../../domain/repositories/episode_repository.dart';
import '../datasources/episode_remote_datasource.dart';

class EpisodeRepositoryImpl implements EpisodeRepository {
  final EpisodeRemoteDataSource remoteDataSource;

  EpisodeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Episode>>> getEpisodes(String animeId,
      {int offset = 0, int limit = 20}) async {
    try {
      final episodeModels = await remoteDataSource.getEpisodes(animeId,
          offset: offset, limit: limit);
      return Right(episodeModels.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
