// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CharacterStore on _CharacterStoreBase, Store {
  final _$listCharactersAtom = Atom(name: '_CharacterStoreBase.listCharacters');

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

  final _$_CharacterStoreBaseActionController =
      ActionController(name: '_CharacterStoreBase');

  @override
  dynamic getCharacters(String url) {
    final _$actionInfo = _$_CharacterStoreBaseActionController.startAction(
        name: '_CharacterStoreBase.getCharacters');
    try {
      return super.getCharacters(url);
    } finally {
      _$_CharacterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
listCharacters: ${listCharacters}
    ''';
  }
}
