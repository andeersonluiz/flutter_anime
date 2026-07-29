import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {
  final String userId;
  const LoadFavorites(this.userId);
  @override
  List<Object?> get props => [userId];
}

class ToggleFavoriteEvent extends FavoritesEvent {
  final String userId;
  final String animeId;
  const ToggleFavoriteEvent(this.userId, this.animeId);
  @override
  List<Object?> get props => [userId, animeId];
}

class CheckIsFavorite extends FavoritesEvent {
  final String userId;
  final String animeId;
  const CheckIsFavorite(this.userId, this.animeId);
  @override
  List<Object?> get props => [userId, animeId];
}
