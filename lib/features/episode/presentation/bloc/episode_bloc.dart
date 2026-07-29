import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_episodes.dart';
import 'episode_event.dart';
import 'episode_state.dart';

class EpisodeBloc extends Bloc<EpisodeEvent, EpisodeState> {
  final GetEpisodes getEpisodes;
  static const int _limit = 20;

  EpisodeBloc({required this.getEpisodes}) : super(EpisodeInitial()) {
    on<LoadEpisodes>(_onLoadEpisodes);
    on<LoadMoreEpisodes>(_onLoadMoreEpisodes);
  }

  Future<void> _onLoadEpisodes(
      LoadEpisodes event, Emitter<EpisodeState> emit) async {
    emit(EpisodeLoading());
    final result = await getEpisodes(event.animeId, offset: 0, limit: _limit);
    result.fold(
      (failure) => emit(EpisodeError(failure.message)),
      (episodes) {
        final hasMore = episodes.length == _limit;
        // Determine if it's a movie (e.g. only 1 episode returned or specific flag)
        final isMovie = episodes.isNotEmpty &&
            episodes.length == 1 &&
            episodes.first.episodeNumber == null;
        emit(EpisodeLoaded(
            episodes: episodes, hasMore: hasMore, isMovie: isMovie));
      },
    );
  }

  Future<void> _onLoadMoreEpisodes(
      LoadMoreEpisodes event, Emitter<EpisodeState> emit) async {
    if (state is EpisodeLoaded) {
      final currentState = state as EpisodeLoaded;
      if (!currentState.hasMore) return;

      final result = await getEpisodes(
        event.animeId,
        offset: currentState.episodes.length,
        limit: _limit,
      );

      result.fold(
        (failure) => emit(EpisodeError(failure.message)),
        (newEpisodes) {
          final hasMore = newEpisodes.length == _limit;
          emit(EpisodeLoaded(
            episodes: List.of(currentState.episodes)..addAll(newEpisodes),
            hasMore: hasMore,
            isMovie: currentState.isMovie,
          ));
        },
      );
    }
  }
}
