import 'package:equatable/equatable.dart';
import '../../domain/entities/episode.dart';

sealed class EpisodeState extends Equatable {
  const EpisodeState();
  @override
  List<Object?> get props => [];
}

class EpisodeInitial extends EpisodeState {}

class EpisodeLoading extends EpisodeState {}

class EpisodeLoaded extends EpisodeState {
  final List<Episode> episodes;
  final bool hasMore;
  final bool isMovie;

  const EpisodeLoaded({
    required this.episodes,
    required this.hasMore,
    required this.isMovie,
  });

  @override
  List<Object?> get props => [episodes, hasMore, isMovie];
}

class EpisodeError extends EpisodeState {
  final String message;
  const EpisodeError(this.message);
  @override
  List<Object?> get props => [message];
}
