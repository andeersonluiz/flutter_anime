import 'package:equatable/equatable.dart';
import '../../domain/entities/anime.dart';

enum AnimeListType {
  trending,
  popular,
  topRated,
  upcoming,
  airing,
  byCategory,
  search,
}

sealed class AnimeState extends Equatable {
  const AnimeState();
  
  @override
  List<Object?> get props => [];
}

class AnimeInitial extends AnimeState {
  const AnimeInitial();
}

class AnimeLoading extends AnimeState {
  const AnimeLoading();
}

class AnimeListLoaded extends AnimeState {
  const AnimeListLoaded({
    required this.animes,
    required this.hasMore,
    required this.listType,
  });

  final List<Anime> animes;
  final bool hasMore;
  final AnimeListType listType;

  @override
  List<Object?> get props => [animes, hasMore, listType];
}

class AnimeDetailLoaded extends AnimeState {
  const AnimeDetailLoaded({required this.anime});
  final Anime anime;

  @override
  List<Object?> get props => [anime];
}

class AnimeSearchResults extends AnimeState {
  const AnimeSearchResults({required this.results});
  final List<Anime> results;

  @override
  List<Object?> get props => [results];
}

class AnimeLoadingMore extends AnimeState {
  const AnimeLoadingMore({required this.currentAnimes});
  final List<Anime> currentAnimes;

  @override
  List<Object?> get props => [currentAnimes];
}

class AnimeError extends AnimeState {
  const AnimeError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
