import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_anime_characters.dart';
import '../../domain/usecases/get_characters.dart';
import 'character_event.dart';
import 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final GetCharacters getCharacters;
  final GetAnimeCharacters getAnimeCharacters;

  int _offset = 0;
  final int _limit = 20;

  CharacterBloc({
    required this.getCharacters,
    required this.getAnimeCharacters,
  }) : super(CharacterInitial()) {
    on<LoadCharacters>(_onLoadCharacters);
    on<LoadMoreCharacters>(_onLoadMoreCharacters);
    on<LoadAnimeCharacters>(_onLoadAnimeCharacters);
  }

  Future<void> _onLoadCharacters(
      LoadCharacters event, Emitter<CharacterState> emit) async {
    emit(CharacterLoading());
    _offset = 0;

    final result = await getCharacters(offset: _offset, limit: _limit);

    result.fold(
      (failure) => emit(CharacterError(message: failure.message)),
      (characters) {
        _offset += _limit;
        emit(CharacterLoaded(
            characters: characters, hasMore: characters.length == _limit));
      },
    );
  }

  Future<void> _onLoadMoreCharacters(
      LoadMoreCharacters event, Emitter<CharacterState> emit) async {
    final currentState = state;
    if (currentState is CharacterLoaded && currentState.hasMore) {
      final result = await getCharacters(offset: _offset, limit: _limit);

      result.fold(
        (failure) => emit(CharacterError(message: failure.message)),
        (newCharacters) {
          _offset += _limit;
          emit(CharacterLoaded(
            characters: List.of(currentState.characters)..addAll(newCharacters),
            hasMore: newCharacters.length == _limit,
          ));
        },
      );
    }
  }

  Future<void> _onLoadAnimeCharacters(
      LoadAnimeCharacters event, Emitter<CharacterState> emit) async {
    emit(CharacterLoading());
    _offset = 0;

    final result =
        await getAnimeCharacters(event.animeId, offset: _offset, limit: _limit);

    result.fold(
      (failure) => emit(CharacterError(message: failure.message)),
      (characters) {
        _offset += _limit;
        emit(CharacterLoaded(
            characters: characters, hasMore: characters.length == _limit));
      },
    );
  }
}
