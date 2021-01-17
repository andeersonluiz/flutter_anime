// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animeCharacter_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AnimeCharacterStore on _AnimeCharacterStoreBase, Store {
  final _$listCharactersAtom =
      Atom(name: '_AnimeCharacterStoreBase.listCharacters');

  @override
  ObservableFuture<List<Character>> get listCharacters {
    _$listCharactersAtom.reportRead();
    return super.listCharacters;
  }

  @override
  set listCharacters(ObservableFuture<List<Character>> value) {
    _$listCharactersAtom.reportWrite(value, super.listCharacters, () {
      super.listCharacters = value;
    });
  }

  final _$_AnimeCharacterStoreBaseActionController =
      ActionController(name: '_AnimeCharacterStoreBase');

  @override
  dynamic getCharacters(String url) {
    final _$actionInfo = _$_AnimeCharacterStoreBaseActionController.startAction(
        name: '_AnimeCharacterStoreBase.getCharacters');
    try {
      return super.getCharacters(url);
    } finally {
      _$_AnimeCharacterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic loadMoreCharacters() {
    final _$actionInfo = _$_AnimeCharacterStoreBaseActionController.startAction(
        name: '_AnimeCharacterStoreBase.loadMoreCharacters');
    try {
      return super.loadMoreCharacters();
    } finally {
      _$_AnimeCharacterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
listCharacters: ${listCharacters}
    ''';
  }
}
