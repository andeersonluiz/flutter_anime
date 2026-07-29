import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/toggle_favorite.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites getFavorites;
  final ToggleFavorite toggleFavorite;

  FavoritesBloc({
    required this.getFavorites,
    required this.toggleFavorite,
  }) : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    // CheckIsFavorite might not change state fully, or you can implement it based on need.
  }

  Future<void> _onLoadFavorites(
      LoadFavorites event, Emitter<FavoritesState> emit) async {
    emit(FavoritesLoading());
    final result = await getFavorites(event.userId);
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (favorites) => emit(FavoritesLoaded(favoriteIds: favorites.toSet())),
    );
  }

  Future<void> _onToggleFavorite(
      ToggleFavoriteEvent event, Emitter<FavoritesState> emit) async {
    if (state is FavoritesLoaded) {
      final currentState = state as FavoritesLoaded;
      final Set<String> currentIds = Set.from(currentState.favoriteIds);

      // Optimistic update
      if (currentIds.contains(event.animeId)) {
        currentIds.remove(event.animeId);
      } else {
        currentIds.add(event.animeId);
      }
      emit(FavoritesLoaded(favoriteIds: currentIds));

      final result = await toggleFavorite(event.userId, event.animeId);

      // On failure, rollback by reloading favorites
      if (result.isLeft()) {
        add(LoadFavorites(event.userId));
      }
    }
  }
}
