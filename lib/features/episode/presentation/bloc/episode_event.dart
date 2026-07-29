import 'package:equatable/equatable.dart';

abstract class EpisodeEvent extends Equatable {
  const EpisodeEvent();
  @override
  List<Object?> get props => [];
}

class LoadEpisodes extends EpisodeEvent {
  final String animeId;
  const LoadEpisodes(this.animeId);
  @override
  List<Object?> get props => [animeId];
}

class LoadMoreEpisodes extends EpisodeEvent {
  final String animeId;
  const LoadMoreEpisodes(this.animeId);
  @override
  List<Object?> get props => [animeId];
}
