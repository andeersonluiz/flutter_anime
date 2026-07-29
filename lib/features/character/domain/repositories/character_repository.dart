import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/character.dart';

abstract class CharacterRepository {
  Future<Either<Failure, List<Character>>> getCharacters({int offset = 0, int limit = 20});
  Future<Either<Failure, List<Character>>> getAnimeCharacters(String animeId, {int offset = 0, int limit = 20});
}
