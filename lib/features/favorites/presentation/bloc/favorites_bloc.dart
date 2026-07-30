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
    Set<String> currentIds = {};
    if (state is FavoritesLoaded) {
      currentIds = Set.from((state as FavoritesLoaded).favoriteIds);
    } else {
      final fetchResult = await getFavorites(event.userId);
      fetchResult.fold((_) {}, (favs) => currentIds = favs.toSet());
    }

    // Optimistic toggle update
    if (currentIds.contains(event.animeId)) {
      currentIds.remove(event.animeId);
    } else {
      currentIds.add(event.animeId);
    }
    emit(FavoritesLoaded(favoriteIds: currentIds));

    // Persist change to Firestore
    final result = await toggleFavorite(event.userId, event.animeId);

    // On failure, rollback by reloading favorites
    if (result.isLeft()) {
      add(LoadFavorites(event.userId));
    }
  }
}
