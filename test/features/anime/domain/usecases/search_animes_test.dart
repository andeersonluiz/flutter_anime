import 'package:animes_io/core/error/failures.dart';
import 'package:animes_io/features/anime/domain/entities/anime.dart';
import 'package:animes_io/features/anime/domain/repositories/anime_repository.dart';
import 'package:animes_io/features/anime/domain/usecases/search_animes.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAnimeRepository extends Mock implements AnimeRepository {}

void main() {
  late SearchAnimes usecase;
  late MockAnimeRepository mockAnimeRepository;

  setUp(() {
    mockAnimeRepository = MockAnimeRepository();
    usecase = SearchAnimes(mockAnimeRepository);
  });

  const tQuery = 'Naruto';
  const tAnime = Anime(
    id: '1',
    title: 'Naruto',
    synopsis: 'Test Synopsis',
    status: 'current',
  );
  const tAnimeList = [tAnime];

  test('should search animes from repository', () async {
    when(() => mockAnimeRepository.searchAnimes(tQuery, offset: 0, limit: 10))
        .thenAnswer((_) async => const Right<Failure, List<Anime>>(tAnimeList));

    final result = await usecase(
        const SearchAnimesParams(query: tQuery, offset: 0, limit: 10));

    expect(result, const Right<Failure, List<Anime>>(tAnimeList));
    verify(() => mockAnimeRepository.searchAnimes(tQuery, offset: 0, limit: 10))
        .called(1);
  });
}
