import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/character.dart';
import '../repositories/character_repository.dart';

class GetAnimeCharacters {
  final CharacterRepository repository;

  GetAnimeCharacters(this.repository);

  Future<Either<Failure, List<Character>>> call(String animeId,
      {int offset = 0, int limit = 20}) {
    return repository.getAnimeCharacters(animeId, offset: offset, limit: limit);
  }
}
