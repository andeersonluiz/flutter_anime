// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SearchStore on _SearchStoreBase, Store {
  final _$searchResultsAnimesAtom =
      Atom(name: '_SearchStoreBase.searchResultsAnimes');

  @override
  ObservableFuture<List<Anime>> get searchResultsAnimes {
    _$searchResultsAnimesAtom.reportRead();
    return super.searchResultsAnimes;
  }

  @override
  set searchResultsAnimes(ObservableFuture<List<Anime>> value) {
    _$searchResultsAnimesAtom.reportWrite(value, super.searchResultsAnimes, () {
      super.searchResultsAnimes = value;
    });
  }

  final _$searchResultsCharactersAtom =
      Atom(name: '_SearchStoreBase.searchResultsCharacters');

  @override
  ObservableFuture<List<Character>> get searchResultsCharacters {
    _$searchResultsCharactersAtom.reportRead();
    return super.searchResultsCharacters;
  }

  @override
  set searchResultsCharacters(ObservableFuture<List<Character>> value) {
    _$searchResultsCharactersAtom
        .reportWrite(value, super.searchResultsCharacters, () {
      super.searchResultsCharacters = value;
    });
  }

  final _$searchResultsCategoriesAtom =
      Atom(name: '_SearchStoreBase.searchResultsCategories');

  @override
  ObservableFuture<List<Categorie>> get searchResultsCategories {
    _$searchResultsCategoriesAtom.reportRead();
    return super.searchResultsCategories;
  }

  @override
  set searchResultsCategories(ObservableFuture<List<Categorie>> value) {
    _$searchResultsCategoriesAtom
        .reportWrite(value, super.searchResultsCategories, () {
      super.searchResultsCategories = value;
    });
  }

  final _$_SearchStoreBaseActionController =
      ActionController(name: '_SearchStoreBase');

  @override
  dynamic search(String query, String typeSearch) {
    final _$actionInfo = _$_SearchStoreBaseActionController.startAction(
        name: '_SearchStoreBase.search');
    try {
      return super.search(query, typeSearch);
    } finally {
      _$_SearchStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchResultsAnimes: ${searchResultsAnimes},
searchResultsCharacters: ${searchResultsCharacters},
searchResultsCategories: ${searchResultsCategories}
    ''';
  }
}
