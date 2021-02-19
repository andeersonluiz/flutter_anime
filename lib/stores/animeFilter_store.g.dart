// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animeFilter_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AnimeFilterStore on _AnimeFilterStoreBase, Store {
  final _$listAnimesAtom = Atom(name: '_AnimeFilterStoreBase.listAnimes');

  @override
  ObservableFuture<List<Anime>> get listAnimes {
    _$listAnimesAtom.reportRead();
    return super.listAnimes;
  }

  @override
  set listAnimes(ObservableFuture<List<Anime>> value) {
    _$listAnimesAtom.reportWrite(value, super.listAnimes, () {
      super.listAnimes = value;
    });
  }

  final _$favCategorieAtom = Atom(name: '_AnimeFilterStoreBase.favCategorie');

  @override
  ObservableList<dynamic> get favCategorie {
    _$favCategorieAtom.reportRead();
    return super.favCategorie;
  }

  @override
  set favCategorie(ObservableList<dynamic> value) {
    _$favCategorieAtom.reportWrite(value, super.favCategorie, () {
      super.favCategorie = value;
    });
  }

  final _$_AnimeFilterStoreBaseActionController =
      ActionController(name: '_AnimeFilterStoreBase');

  @override
  dynamic getAnimesByCategorie(
      String categorie, FavoriteAnimeStore favStore, bool isLogged) {
    final _$actionInfo = _$_AnimeFilterStoreBaseActionController.startAction(
        name: '_AnimeFilterStoreBase.getAnimesByCategorie');
    try {
      return super.getAnimesByCategorie(categorie, favStore, isLogged);
    } finally {
      _$_AnimeFilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
listAnimes: ${listAnimes},
favCategorie: ${favCategorie}
    ''';
  }
}
