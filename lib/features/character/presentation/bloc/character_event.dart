import 'package:equatable/equatable.dart';

sealed class CharacterEvent extends Equatable {
  const CharacterEvent();

  @override
  List<Object?> get props => [];
}

class LoadCharacters extends CharacterEvent {}

class LoadMoreCharacters extends CharacterEvent {}

class LoadAnimeCharacters extends CharacterEvent {
  final String animeId;

  const LoadAnimeCharacters(this.animeId);

  @override
  List<Object?> get props => [animeId];
}
