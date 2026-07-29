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

class MockGetCurrentlyAiringAnimes extends Mock
    implements GetCurrentlyAiringAnimes {}

class MockGetAnimeDetails extends Mock implements GetAnimeDetails {}

class MockSearchAnimes extends Mock implements SearchAnimes {}

class MockGetAnimesByCategory extends Mock implements GetAnimesByCategory {}

const tAnime = Anime(
  id: '1',
  title: 'Test Anime',
  synopsis: 'Test Synopsis',
  status: 'current',
);
const tAnimeList = [tAnime];
const tAnime10 = [
  tAnime,
  tAnime,
  tAnime,
  tAnime,
  tAnime,
  tAnime,
  tAnime,
  tAnime,
  tAnime,
  tAnime,
];

AnimeBloc buildBloc({
  MockGetTrendingAnimes? trending,
  MockGetMostPopularAnimes? popular,
  MockGetTopRatedAnimes? topRated,
  MockGetUpcomingAnimes? upcoming,
  MockGetCurrentlyAiringAnimes? airing,
  MockGetAnimeDetails? details,
  MockSearchAnimes? search,
  MockGetAnimesByCategory? byCategory,
}) {
  return AnimeBloc(
    getTrendingAnimes: trending ?? MockGetTrendingAnimes(),
    getMostPopularAnimes: popular ?? MockGetMostPopularAnimes(),
    getTopRatedAnimes: topRated ?? MockGetTopRatedAnimes(),
    getUpcomingAnimes: upcoming ?? MockGetUpcomingAnimes(),
    getCurrentlyAiringAnimes: airing ?? MockGetCurrentlyAiringAnimes(),
    getAnimeDetails: details ?? MockGetAnimeDetails(),
    searchAnimes: search ?? MockSearchAnimes(),
    getAnimesByCategory: byCategory ?? MockGetAnimesByCategory(),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(const GetTrendingAnimesParams(offset: 0, limit: 10));
    registerFallbackValue(
        const GetMostPopularAnimesParams(offset: 0, limit: 10));
    registerFallbackValue(const GetTopRatedAnimesParams(offset: 0, limit: 10));
    registerFallbackValue(const GetUpcomingAnimesParams(offset: 0, limit: 10));
    registerFallbackValue(
        const GetCurrentlyAiringAnimesParams(offset: 0, limit: 10));
    registerFallbackValue(const GetAnimeDetailsParams(id: '1'));
    registerFallbackValue(
        const SearchAnimesParams(query: 'test', offset: 0, limit: 10));
    registerFallbackValue(
        const GetAnimesByCategoryParams(categorySlug: 'action', limit: 10));
  });

  group('LoadTrendingAnimes', () {
    late MockGetTrendingAnimes mockTrending;
    setUp(() => mockTrending = MockGetTrendingAnimes());

    blocTest<AnimeBloc, AnimeState>(
      'emits [AnimeLoading, AnimeListLoaded] on success',
      build: () {
        when(() => mockTrending(any()))
            .thenAnswer((_) async => const Right(tAnimeList));
        return buildBloc(trending: mockTrending);
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
      'emits [AnimeLoading, AnimeError] on failure',
      build: () {
        when(() => mockTrending(any()))
            .thenAnswer((_) async => const Left(ServerFailure('error')));
        return buildBloc(trending: mockTrending);
      },
      act: (bloc) => bloc.add(const LoadTrendingAnimes()),
      expect: () => [
        const AnimeLoading(),
        const AnimeError(message: 'error'),
      ],
    );

    blocTest<AnimeBloc, AnimeState>(
      'hasMore is true when returned list length == 10',
      build: () {
        when(() => mockTrending(any()))
            .thenAnswer((_) async => const Right(tAnime10));
        return buildBloc(trending: mockTrending);
      },
      act: (bloc) => bloc.add(const LoadTrendingAnimes()),
      expect: () => [
        const AnimeLoading(),
        const AnimeListLoaded(
          animes: tAnime10,
          hasMore: true,
          listType: AnimeListType.trending,
        ),
      ],
    );
  });

  group('LoadMostPopularAnimes', () {
    late MockGetMostPopularAnimes mockPopular;
    setUp(() => mockPopular = MockGetMostPopularAnimes());

    blocTest<AnimeBloc, AnimeState>(
      'emits [AnimeLoading, AnimeListLoaded] on success',
      build: () {
        when(() => mockPopular(any()))
            .thenAnswer((_) async => const Right(tAnimeList));
        return buildBloc(popular: mockPopular);
      },
      act: (bloc) => bloc.add(const LoadMostPopularAnimes()),
      expect: () => [
        const AnimeLoading(),
        const AnimeListLoaded(
          animes: tAnimeList,
          hasMore: false,
          listType: AnimeListType.popular,
        ),
      ],
    );

    blocTest<AnimeBloc, AnimeState>(
      'emits [AnimeLoading, AnimeError] on failure',
      build: () {
        when(() => mockPopular(any()))
            .thenAnswer((_) async => const Left(ServerFailure('error')));
        return buildBloc(popular: mockPopular);
      },
      act: (bloc) => bloc.add(const LoadMostPopularAnimes()),
      expect: () => [
        const AnimeLoading(),
        const AnimeError(message: 'error'),
      ],
    );
  });

  group('LoadTopRatedAnimes', () {
    late MockGetTopRatedAnimes mockTopRated;
    setUp(() => mockTopRated = MockGetTopRatedAnimes());

    blocTest<AnimeBloc, AnimeState>(
      'emits [AnimeLoading, AnimeListLoaded] on success',
      build: () {
        when(() => mockTopRated(any()))
            .thenAnswer((_) async => const Right(tAnimeList));
        return buildBloc(topRated: mockTopRated);
      },
      act: (bloc) => bloc.add(const LoadTopRatedAnimes()),
      expect: () => [
        const AnimeLoading(),
        const AnimeListLoaded(
          animes: tAnimeList,
          hasMore: false,
          listType: AnimeListType.topRated,
        ),
      ],
    );
  });

  group('LoadUpcomingAnimes', () {
    late MockGetUpcomingAnimes mockUpcoming;
    setUp(() => mockUpcoming = MockGetUpcomingAnimes());

    blocTest<AnimeBloc, AnimeState>(
      'emits [AnimeLoading, AnimeListLoaded] on success',
      build: () {
        when(() => mockUpcoming(any()))
            .thenAnswer((_) async => const Right(tAnimeList));
        return buildBloc(upcoming: mockUpcoming);
      },
      act: (bloc) => bloc.add(const LoadUpcomingAnimes()),
      expect: () => [
        const AnimeLoading(),
        const AnimeListLoaded(
          animes: tAnimeList,
          hasMore: false,
          listType: AnimeListType.upcoming,
        ),
      ],
    );
  });

  group('LoadCurrentlyAiringAnimes', () {
    late MockGetCurrentlyAiringAnimes mockAiring;
    setUp(() => mockAiring = MockGetCurrentlyAiringAnimes());

    blocTest<AnimeBloc, AnimeState>(
      'emits [AnimeLoading, AnimeListLoaded] on success',
      build: () {
        when(() => mockAiring(any()))
            .thenAnswer((_) async => const Right(tAnimeList));
        return buildBloc(airing: mockAiring);
      },
      act: (bloc) => bloc.add(const LoadCurrentlyAiringAnimes()),
      expect: () => [
        const AnimeLoading(),
        const AnimeListLoaded(
          animes: tAnimeList,
          hasMore: false,
          listType: AnimeListType.airing,
        ),
      ],
    );
  });

  group('SearchAnimesEvent', () {
    late MockSearchAnimes mockSearch;
    setUp(() => mockSearch = MockSearchAnimes());

    blocTest<AnimeBloc, AnimeState>(
      'emits [AnimeLoading, AnimeSearchResults] on success',
      build: () {
        when(() => mockSearch(any()))
            .thenAnswer((_) async => const Right(tAnimeList));
        return buildBloc(search: mockSearch);
      },
      act: (bloc) => bloc.add(const SearchAnimesEvent('Naruto')),
      expect: () => [
        const AnimeLoading(),
        const AnimeSearchResults(results: tAnimeList),
      ],
    );

    blocTest<AnimeBloc, AnimeState>(
      'emits [AnimeLoading, AnimeError] on failure',
      build: () {
        when(() => mockSearch(any()))
            .thenAnswer((_) async => const Left(ServerFailure('error')));
        return buildBloc(search: mockSearch);
      },
      act: (bloc) => bloc.add(const SearchAnimesEvent('Naruto')),
      expect: () => [
        const AnimeLoading(),
        const AnimeError(message: 'error'),
      ],
    );
  });

  group('LoadAnimesByCategory', () {
    late MockGetAnimesByCategory mockByCategory;
    setUp(() => mockByCategory = MockGetAnimesByCategory());

    blocTest<AnimeBloc, AnimeState>(
      'emits [AnimeLoading, AnimeListLoaded] on success',
      build: () {
        when(() => mockByCategory(any()))
            .thenAnswer((_) async => const Right(tAnimeList));
        return buildBloc(byCategory: mockByCategory);
      },
      act: (bloc) => bloc.add(const LoadAnimesByCategory('action')),
      expect: () => [
        const AnimeLoading(),
        const AnimeListLoaded(
          animes: tAnimeList,
          hasMore: false,
          listType: AnimeListType.byCategory,
        ),
      ],
    );
  });

  group('LoadAnimeDetailsEvent', () {
    late MockGetAnimeDetails mockDetails;
    setUp(() => mockDetails = MockGetAnimeDetails());

    blocTest<AnimeBloc, AnimeState>(
      'emits [AnimeLoading, AnimeDetailLoaded] on success',
      build: () {
        when(() => mockDetails(any()))
            .thenAnswer((_) async => const Right(tAnime));
        return buildBloc(details: mockDetails);
      },
      act: (bloc) => bloc.add(const LoadAnimeDetailsEvent('1')),
      expect: () => [
        const AnimeLoading(),
        const AnimeDetailLoaded(anime: tAnime),
      ],
    );

    blocTest<AnimeBloc, AnimeState>(
      'emits [AnimeLoading, AnimeError] on failure',
      build: () {
        when(() => mockDetails(any()))
            .thenAnswer((_) async => const Left(ServerFailure('not found')));
        return buildBloc(details: mockDetails);
      },
      act: (bloc) => bloc.add(const LoadAnimeDetailsEvent('1')),
      expect: () => [
        const AnimeLoading(),
        const AnimeError(message: 'not found'),
      ],
    );
  });

  group('LoadMoreAnimes', () {
    late MockGetTrendingAnimes mockTrending;

    setUp(() {
      mockTrending = MockGetTrendingAnimes();
    });

    blocTest<AnimeBloc, AnimeState>(
      'emits AnimeLoadingMore then AnimeListLoaded with appended animes',
      build: () {
        // First call returns list of 10 (hasMore=true), second returns 1
        var callCount = 0;
        when(() => mockTrending(any())).thenAnswer((_) async {
          callCount++;
          return callCount == 1
              ? const Right(tAnime10)
              : const Right(tAnimeList);
        });
        return buildBloc(trending: mockTrending);
      },
      act: (bloc) async {
        bloc.add(const LoadTrendingAnimes());
        await Future<void>.delayed(const Duration(milliseconds: 100));
        bloc.add(const LoadMoreAnimes());
      },
      expect: () => [
        const AnimeLoading(),
        const AnimeListLoaded(
          animes: tAnime10,
          hasMore: true,
          listType: AnimeListType.trending,
        ),
        const AnimeLoadingMore(currentAnimes: tAnime10),
        AnimeListLoaded(
          animes: [...tAnime10, ...tAnimeList],
          hasMore: false,
          listType: AnimeListType.trending,
        ),
      ],
    );

    blocTest<AnimeBloc, AnimeState>(
      'does nothing when state is not AnimeListLoaded',
      build: () => buildBloc(trending: mockTrending),
      act: (bloc) => bloc.add(const LoadMoreAnimes()),
      expect: () => [],
    );

    blocTest<AnimeBloc, AnimeState>(
      'does nothing when hasMore is false',
      build: () {
        when(() => mockTrending(any()))
            .thenAnswer((_) async => const Right(tAnimeList));
        return buildBloc(trending: mockTrending);
      },
      act: (bloc) async {
        bloc.add(const LoadTrendingAnimes());
        await Future<void>.delayed(const Duration(milliseconds: 100));
        bloc.add(const LoadMoreAnimes());
      },
      expect: () => [
        const AnimeLoading(),
        const AnimeListLoaded(
          animes: tAnimeList,
          hasMore: false,
          listType: AnimeListType.trending,
        ),
        // LoadMoreAnimes is a no-op because hasMore == false
      ],
    );
  });
}
