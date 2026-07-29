import 'package:animes_io/core/error/failures.dart';
import 'package:animes_io/features/anime/domain/entities/anime.dart';
import 'package:animes_io/features/anime/domain/usecases/get_anime_details.dart';
import 'package:animes_io/features/anime/domain/usecases/get_animes_by_category.dart';
import 'package:animes_io/features/anime/domain/usecases/get_currently_airing_animes.dart';
import 'package:animes_io/features/anime/domain/usecases/get_most_popular_animes.dart';
import 'package:animes_io/features/anime/domain/usecases/get_top_rated_animes.dart';
import 'package:animes_io/features/anime/domain/usecases/get_trending_animes.dart';
import 'package:animes_io/features/anime/domain/usecases/get_upcoming_animes.dart';
import 'package:animes_io/features/anime/domain/usecases/search_animes.dart';
import 'package:animes_io/features/anime/presentation/bloc/anime_bloc.dart';
import 'package:animes_io/features/anime/presentation/bloc/anime_event.dart';
import 'package:animes_io/features/anime/presentation/bloc/anime_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTrendingAnimes extends Mock implements GetTrendingAnimes {}
class MockGetMostPopularAnimes extends Mock implements GetMostPopularAnimes {}
class MockGetTopRatedAnimes extends Mock implements GetTopRatedAnimes {}
class MockGetUpcomingAnimes extends Mock implements GetUpcomingAnimes {}
class MockGetCurrentlyAiringAnimes extends Mock implements GetCurrentlyAiringAnimes {}
class MockGetAnimeDetails extends Mock implements GetAnimeDetails {}
class MockSearchAnimes extends Mock implements SearchAnimes {}
class MockGetAnimesByCategory extends Mock implements GetAnimesByCategory {}

void main() {
  late AnimeBloc bloc;
  late MockGetTrendingAnimes mockGetTrendingAnimes;
  late MockSearchAnimes mockSearchAnimes;

  setUp(() {
    mockGetTrendingAnimes = MockGetTrendingAnimes();
    mockSearchAnimes = MockSearchAnimes();
    bloc = AnimeBloc(
      getTrendingAnimes: mockGetTrendingAnimes,
      getMostPopularAnimes: MockGetMostPopularAnimes(),
      getTopRatedAnimes: MockGetTopRatedAnimes(),
      getUpcomingAnimes: MockGetUpcomingAnimes(),
      getCurrentlyAiringAnimes: MockGetCurrentlyAiringAnimes(),
      getAnimeDetails: MockGetAnimeDetails(),
      searchAnimes: mockSearchAnimes,
      getAnimesByCategory: MockGetAnimesByCategory(),
    );

    registerFallbackValue(const GetTrendingAnimesParams(offset: 0, limit: 10));
    registerFallbackValue(const SearchAnimesParams(query: 'test', offset: 0, limit: 10));
  });

  const tAnime = Anime(
    id: '1',
    title: 'Test Anime',
    synopsis: 'Test Synopsis',
    status: 'current',
  );

  const tAnimeList = [tAnime];

  group('LoadTrendingAnimes', () {
    blocTest<AnimeBloc, AnimeState>(
      'should emit [AnimeLoading, AnimeListLoaded] when successful',
      build: () {
        when(() => mockGetTrendingAnimes(any()))
            .thenAnswer((_) async => const Right(tAnimeList));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadTrendingAnimes()),
      expect: () => [
        const AnimeLoading(),
        const AnimeListLoaded(
          animes: tAnimeList,
          hasMore: false,
          listType: AnimeListType.trending,
        ),
      ],
    );

    blocTest<AnimeBloc, AnimeState>(
      'should emit [AnimeLoading, AnimeError] when getting data fails',
      build: () {
        when(() => mockGetTrendingAnimes(any()))
            .thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadTrendingAnimes()),
      expect: () => [
        const AnimeLoading(),
        const AnimeError(message: 'Server Error'),
      ],
    );
  });
}
