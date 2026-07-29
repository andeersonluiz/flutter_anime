import 'package:animes_io/core/error/failures.dart';
import 'package:animes_io/features/anime/domain/entities/anime.dart';
import 'package:animes_io/features/anime/domain/repositories/anime_repository.dart';
import 'package:animes_io/features/anime/domain/usecases/get_anime_details.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAnimeRepository extends Mock implements AnimeRepository {}

void main() {
  late GetAnimeDetails usecase;
  late MockAnimeRepository mockAnimeRepository;

  setUp(() {
    mockAnimeRepository = MockAnimeRepository();
    usecase = GetAnimeDetails(mockAnimeRepository);
  });

  const tId = '1';
  const tAnime = Anime(
    id: tId,
    title: 'Test Anime',
    synopsis: 'Test Synopsis',
    status: 'current',
  );

  test('should get anime details from the repository', () async {
    when(() => mockAnimeRepository.getAnimeDetails(tId))
        .thenAnswer((_) async => const Right<Failure, Anime>(tAnime));

    final result = await usecase(const GetAnimeDetailsParams(id: tId));

    expect(result, const Right<Failure, Anime>(tAnime));
    verify(() => mockAnimeRepository.getAnimeDetails(tId)).called(1);
    verifyNoMoreInteractions(mockAnimeRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    when(() => mockAnimeRepository.getAnimeDetails(tId)).thenAnswer((_) async =>
        const Left<Failure, Anime>(ServerFailure('Server Failure')));

    final result = await usecase(const GetAnimeDetailsParams(id: tId));

    expect(result, const Left<Failure, Anime>(ServerFailure('Server Failure')));
    verify(() => mockAnimeRepository.getAnimeDetails(tId)).called(1);
  });
}
