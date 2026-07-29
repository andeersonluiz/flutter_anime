import 'package:equatable/equatable.dart';
import 'package:animes_io/features/character/domain/entities/character.dart';

sealed class CharacterState extends Equatable {
  const CharacterState();

  @override
  List<Object?> get props => [];
}

class CharacterInitial extends CharacterState {}

class CharacterLoading extends CharacterState {}

class CharacterLoaded extends CharacterState {
  final List<Character> characters;
  final bool hasMore;

  const CharacterLoaded({required this.characters, this.hasMore = true});

  @override
  List<Object?> get props => [characters, hasMore];
}

class CharacterError extends CharacterState {
  final String message;

  const CharacterError({required this.message});

  @override
  List<Object?> get props => [message];
}
