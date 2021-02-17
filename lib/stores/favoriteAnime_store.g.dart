// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favoriteAnime_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FavoriteAnimeStore on _FavoriteAnimeStoreBase, Store {
  final _$favoriteAnimesAtom =
      Atom(name: '_FavoriteAnimeStoreBase.favoriteAnimes');

  @override
  ObservableFuture<List<Anime>> get favoriteAnimes {
    _$favoriteAnimesAtom.reportRead();
    return super.favoriteAnimes;
  }

  @override
  set favoriteAnimes(ObservableFuture<List<Anime>> value) {
    _$favoriteAnimesAtom.reportWrite(value, super.favoriteAnimes, () {
      super.favoriteAnimes = value;
    });
  }

  final _$favoriteListAtom = Atom(name: '_FavoriteAnimeStoreBase.favoriteList');

  @override
  ObservableList<dynamic> get favoriteList {
    _$favoriteListAtom.reportRead();
    return super.favoriteList;
  }

  @override
  set favoriteList(ObservableList<dynamic> value) {
    _$favoriteListAtom.reportWrite(value, super.favoriteList, () {
      super.favoriteList = value;
    });
  }

  final _$localFavoriteAtom =
      Atom(name: '_FavoriteAnimeStoreBase.localFavorite');

  @override
  bool get localFavorite {
    _$localFavoriteAtom.reportRead();
    return super.localFavorite;
  }

  @override
  set localFavorite(bool value) {
    _$localFavoriteAtom.reportWrite(value, super.localFavorite, () {
      super.localFavorite = value;
    });
  }

  final _$getFavoriteAnimesAsyncAction =
      AsyncAction('_FavoriteAnimeStoreBase.getFavoriteAnimes');

  @override
  Future getFavoriteAnimes() {
    return _$getFavoriteAnimesAsyncAction.run(() => super.getFavoriteAnimes());
  }

  final _$_FavoriteAnimeStoreBaseActionController =
      ActionController(name: '_FavoriteAnimeStoreBase');

  @override
  dynamic changeFavorite(int index, Anime anime) {
    final _$actionInfo = _$_FavoriteAnimeStoreBaseActionController.startAction(
        name: '_FavoriteAnimeStoreBase.changeFavorite');
    try {
      return super.changeFavorite(index, anime);
    } finally {
      _$_FavoriteAnimeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
favoriteAnimes: ${favoriteAnimes},
favoriteList: ${favoriteList},
localFavorite: ${localFavorite}
    ''';
  }
}
