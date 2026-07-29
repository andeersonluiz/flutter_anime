import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/character.dart';
import '../repositories/character_repository.dart';

class GetCharacters {
  final CharacterRepository repository;

  GetCharacters(this.repository);

  Future<Either<Failure, List<Character>>> call(
      {int offset = 0, int limit = 20}) {
    return repository.getCharacters(offset: offset, limit: limit);
  }
}
