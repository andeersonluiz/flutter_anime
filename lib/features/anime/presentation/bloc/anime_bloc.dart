import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/anime.dart';
import '../../domain/usecases/get_anime_details.dart';
import '../../domain/usecases/get_animes_by_category.dart';
import '../../domain/usecases/get_currently_airing_animes.dart';
import '../../domain/usecases/get_most_popular_animes.dart';
import '../../domain/usecases/get_top_rated_animes.dart';
import '../../domain/usecases/get_trending_animes.dart';
import '../../domain/usecases/get_upcoming_animes.dart';
import '../../domain/usecases/search_animes.dart';
import 'anime_event.dart';
import 'anime_state.dart';

class AnimeBloc extends Bloc<AnimeEvent, AnimeState> {
  AnimeBloc({
    required this.getTrendingAnimes,
    required this.getMostPopularAnimes,
    required this.getTopRatedAnimes,
    required this.getUpcomingAnimes,
    required this.getCurrentlyAiringAnimes,
    required this.getAnimeDetails,
    required this.searchAnimes,
    required this.getAnimesByCategory,
  }) : super(const AnimeInitial()) {
    on<LoadTrendingAnimes>(_onLoadTrendingAnimes);
    on<LoadMostPopularAnimes>(_onLoadMostPopularAnimes);
    on<LoadTopRatedAnimes>(_onLoadTopRatedAnimes);
    on<LoadUpcomingAnimes>(_onLoadUpcomingAnimes);
    on<LoadCurrentlyAiringAnimes>(_onLoadCurrentlyAiringAnimes);
    on<SearchAnimesEvent>(_onSearchAnimes);
    on<LoadAnimesByCategory>(_onLoadAnimesByCategory);
    on<LoadAnimeDetailsEvent>(_onLoadAnimeDetails);
    on<LoadMoreAnimes>(_onLoadMoreAnimes);
  }

  final GetTrendingAnimes getTrendingAnimes;
  final GetMostPopularAnimes getMostPopularAnimes;
  final GetTopRatedAnimes getTopRatedAnimes;
  final GetUpcomingAnimes getUpcomingAnimes;
  final GetCurrentlyAiringAnimes getCurrentlyAiringAnimes;
  final GetAnimeDetails getAnimeDetails;
  final SearchAnimes searchAnimes;
  final GetAnimesByCategory getAnimesByCategory;

  int _currentOffset = 0;
  final int _limit = 10;
  AnimeListType? _currentListType;
  String? _currentQuery;
  String? _currentCategory;

  Future<void> _onLoadTrendingAnimes(
    LoadTrendingAnimes event,
    Emitter<AnimeState> emit,
  ) async {
    emit(const AnimeLoading());
    _currentListType = AnimeListType.trending;
    _currentOffset = event.offset;

    final result = await getTrendingAnimes(
      GetTrendingAnimesParams(offset: _currentOffset, limit: _limit),
    );

    result.fold(
      (failure) => emit(AnimeError(message: failure.message)),
      (animes) => emit(AnimeListLoaded(
        animes: animes,
        hasMore: animes.length == _limit,
        listType: AnimeListType.trending,
      )),
    );
  }

  Future<void> _onLoadMostPopularAnimes(
    LoadMostPopularAnimes event,
    Emitter<AnimeState> emit,
  ) async {
    emit(const AnimeLoading());
    _currentListType = AnimeListType.popular;
    _currentOffset = event.offset;

    final result = await getMostPopularAnimes(
      GetMostPopularAnimesParams(offset: _currentOffset, limit: _limit),
    );

    result.fold(
      (failure) => emit(AnimeError(message: failure.message)),
      (animes) => emit(AnimeListLoaded(
        animes: animes,
        hasMore: animes.length == _limit,
        listType: AnimeListType.popular,
      )),
    );
  }

  Future<void> _onLoadTopRatedAnimes(
    LoadTopRatedAnimes event,
    Emitter<AnimeState> emit,
  ) async {
    emit(const AnimeLoading());
    _currentListType = AnimeListType.topRated;
    _currentOffset = event.offset;

    final result = await getTopRatedAnimes(
      GetTopRatedAnimesParams(offset: _currentOffset, limit: _limit),
    );

    result.fold(
      (failure) => emit(AnimeError(message: failure.message)),
      (animes) => emit(AnimeListLoaded(
        animes: animes,
        hasMore: animes.length == _limit,
        listType: AnimeListType.topRated,
      )),
    );
  }

  Future<void> _onLoadUpcomingAnimes(
    LoadUpcomingAnimes event,
    Emitter<AnimeState> emit,
  ) async {
    emit(const AnimeLoading());
    _currentListType = AnimeListType.upcoming;
    _currentOffset = event.offset;

    final result = await getUpcomingAnimes(
      GetUpcomingAnimesParams(offset: _currentOffset, limit: _limit),
    );

    result.fold(
      (failure) => emit(AnimeError(message: failure.message)),
      (animes) => emit(AnimeListLoaded(
        animes: animes,
        hasMore: animes.length == _limit,
        listType: AnimeListType.upcoming,
      )),
    );
  }

  Future<void> _onLoadCurrentlyAiringAnimes(
    LoadCurrentlyAiringAnimes event,
    Emitter<AnimeState> emit,
  ) async {
    emit(const AnimeLoading());
    _currentListType = AnimeListType.airing;
    _currentOffset = event.offset;

    final result = await getCurrentlyAiringAnimes(
      GetCurrentlyAiringAnimesParams(offset: _currentOffset, limit: _limit),
    );

    result.fold(
      (failure) => emit(AnimeError(message: failure.message)),
      (animes) => emit(AnimeListLoaded(
        animes: animes,
        hasMore: animes.length == _limit,
        listType: AnimeListType.airing,
      )),
    );
  }

  Future<void> _onSearchAnimes(
    SearchAnimesEvent event,
    Emitter<AnimeState> emit,
  ) async {
    emit(const AnimeLoading());
    _currentListType = AnimeListType.search;
    _currentQuery = event.query;
    _currentOffset = event.offset;

    final result = await searchAnimes(
      SearchAnimesParams(
          query: event.query, offset: _currentOffset, limit: _limit),
    );

    result.fold(
      (failure) => emit(AnimeError(message: failure.message)),
      (results) => emit(AnimeSearchResults(results: results)),
    );
  }

  Future<void> _onLoadAnimesByCategory(
    LoadAnimesByCategory event,
    Emitter<AnimeState> emit,
  ) async {
    emit(const AnimeLoading());
    _currentListType = AnimeListType.byCategory;
    _currentCategory = event.categorySlug;
    _currentOffset = event.offset;

    final result = await getAnimesByCategory(
      GetAnimesByCategoryParams(
        categorySlug: event.categorySlug,
        offset: _currentOffset,
        limit: _limit,
      ),
    );

    result.fold(
      (failure) => emit(AnimeError(message: failure.message)),
      (animes) => emit(AnimeListLoaded(
        animes: animes,
        hasMore: animes.length == _limit,
        listType: AnimeListType.byCategory,
      )),
    );
  }

  Future<void> _onLoadAnimeDetails(
    LoadAnimeDetailsEvent event,
    Emitter<AnimeState> emit,
  ) async {
    emit(const AnimeLoading());
    final result = await getAnimeDetails(GetAnimeDetailsParams(id: event.id));

    result.fold(
      (failure) => emit(AnimeError(message: failure.message)),
      (anime) => emit(AnimeDetailLoaded(anime: anime)),
    );
  }

  Future<void> _onLoadMoreAnimes(
    LoadMoreAnimes event,
    Emitter<AnimeState> emit,
  ) async {
    final currentState = state;
    if (currentState is AnimeListLoaded && currentState.hasMore) {
      emit(AnimeLoadingMore(currentAnimes: currentState.animes));
      _currentOffset += _limit;

      Either<Failure, List<Anime>>? result;
      switch (_currentListType) {
        case AnimeListType.trending:
          result = await getTrendingAnimes(
            GetTrendingAnimesParams(offset: _currentOffset, limit: _limit),
          );
          break;
        case AnimeListType.popular:
          result = await getMostPopularAnimes(
            GetMostPopularAnimesParams(offset: _currentOffset, limit: _limit),
          );
          break;
        case AnimeListType.topRated:
          result = await getTopRatedAnimes(
            GetTopRatedAnimesParams(offset: _currentOffset, limit: _limit),
          );
          break;
        case AnimeListType.upcoming:
          result = await getUpcomingAnimes(
            GetUpcomingAnimesParams(offset: _currentOffset, limit: _limit),
          );
          break;
        case AnimeListType.airing:
          result = await getCurrentlyAiringAnimes(
            GetCurrentlyAiringAnimesParams(
                offset: _currentOffset, limit: _limit),
          );
          break;
        case AnimeListType.byCategory:
          if (_currentCategory != null) {
            result = await getAnimesByCategory(
              GetAnimesByCategoryParams(
                categorySlug: _currentCategory!,
                offset: _currentOffset,
                limit: _limit,
              ),
            );
          }
          break;
        case AnimeListType.search:
          if (_currentQuery != null) {
            result = await searchAnimes(
              SearchAnimesParams(
                query: _currentQuery!,
                offset: _currentOffset,
                limit: _limit,
              ),
            );
          }
          break;
        default:
          return;
      }

      result?.fold(
        (failure) => emit(AnimeError(message: failure.message)),
        (animes) {
          emit(AnimeListLoaded(
            animes: currentState.animes + animes,
            hasMore: animes.length == _limit,
            listType: _currentListType!,
          ));
        },
      );
    }
  }
}
