import 'package:equatable/equatable.dart';

abstract class AnimeEvent extends Equatable {
  const AnimeEvent();

  @override
  List<Object?> get props => [];
}

class LoadTrendingAnimes extends AnimeEvent {
  const LoadTrendingAnimes({this.offset = 0});
  final int offset;

  @override
  List<Object?> get props => [offset];
}

class LoadMostPopularAnimes extends AnimeEvent {
  const LoadMostPopularAnimes({this.offset = 0});
  final int offset;

  @override
  List<Object?> get props => [offset];
}

class LoadTopRatedAnimes extends AnimeEvent {
  const LoadTopRatedAnimes({this.offset = 0});
  final int offset;

  @override
  List<Object?> get props => [offset];
}

class LoadUpcomingAnimes extends AnimeEvent {
  const LoadUpcomingAnimes({this.offset = 0});
  final int offset;

  @override
  List<Object?> get props => [offset];
}

class LoadCurrentlyAiringAnimes extends AnimeEvent {
  const LoadCurrentlyAiringAnimes({this.offset = 0});
  final int offset;

  @override
  List<Object?> get props => [offset];
}

class SearchAnimesEvent extends AnimeEvent {
  const SearchAnimesEvent(this.query, {this.offset = 0});
  final String query;
  final int offset;

  @override
  List<Object?> get props => [query, offset];
}

class LoadAnimesByCategory extends AnimeEvent {
  const LoadAnimesByCategory(this.categorySlug, {this.offset = 0});
  final String categorySlug;
  final int offset;

  @override
  List<Object?> get props => [categorySlug, offset];
}

class LoadAnimeDetailsEvent extends AnimeEvent {
  const LoadAnimeDetailsEvent(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class LoadMoreAnimes extends AnimeEvent {
  const LoadMoreAnimes();
}
