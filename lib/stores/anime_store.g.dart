// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AnimeStore on _AnimeStore, Store {
  Computed<ObservableFuture<List<Anime>>> _$getAnimesPopularComputed;

  @override
  ObservableFuture<List<Anime>> get getAnimesPopular =>
      (_$getAnimesPopularComputed ??= Computed<ObservableFuture<List<Anime>>>(
              () => super.getAnimesPopular,
              name: '_AnimeStore.getAnimesPopular'))
          .value;
  Computed<ObservableFuture<List<Anime>>> _$getAnimesHighestComputed;

  @override
  ObservableFuture<List<Anime>> get getAnimesHighest =>
      (_$getAnimesHighestComputed ??= Computed<ObservableFuture<List<Anime>>>(
              () => super.getAnimesHighest,
              name: '_AnimeStore.getAnimesHighest'))
          .value;
  Computed<ObservableFuture<List<Anime>>> _$getAnimesUpcomingComputed;

  @override
  ObservableFuture<List<Anime>> get getAnimesUpcoming =>
      (_$getAnimesUpcomingComputed ??= Computed<ObservableFuture<List<Anime>>>(
              () => super.getAnimesUpcoming,
              name: '_AnimeStore.getAnimesUpcoming'))
          .value;
  Computed<ObservableFuture<List<Anime>>> _$getAnimesAiringComputed;

  @override
  ObservableFuture<List<Anime>> get getAnimesAiring =>
      (_$getAnimesAiringComputed ??= Computed<ObservableFuture<List<Anime>>>(
              () => super.getAnimesAiring,
              name: '_AnimeStore.getAnimesAiring'))
          .value;

  final _$animesPopularAtom = Atom(name: '_AnimeStore.animesPopular');

  @override
  ObservableFuture<List<Anime>> get animesPopular {
    _$animesPopularAtom.reportRead();
    return super.animesPopular;
  }

  @override
  set animesPopular(ObservableFuture<List<Anime>> value) {
    _$animesPopularAtom.reportWrite(value, super.animesPopular, () {
      super.animesPopular = value;
    });
  }

  final _$animesHighestAtom = Atom(name: '_AnimeStore.animesHighest');

  @override
  ObservableFuture<List<Anime>> get animesHighest {
    _$animesHighestAtom.reportRead();
    return super.animesHighest;
  }

  @override
  set animesHighest(ObservableFuture<List<Anime>> value) {
    _$animesHighestAtom.reportWrite(value, super.animesHighest, () {
      super.animesHighest = value;
    });
  }

  final _$animesUpcomingAtom = Atom(name: '_AnimeStore.animesUpcoming');

  @override
  ObservableFuture<List<Anime>> get animesUpcoming {
    _$animesUpcomingAtom.reportRead();
    return super.animesUpcoming;
  }

  @override
  set animesUpcoming(ObservableFuture<List<Anime>> value) {
    _$animesUpcomingAtom.reportWrite(value, super.animesUpcoming, () {
      super.animesUpcoming = value;
    });
  }

  final _$animesAiringAtom = Atom(name: '_AnimeStore.animesAiring');

  @override
  ObservableFuture<List<Anime>> get animesAiring {
    _$animesAiringAtom.reportRead();
    return super.animesAiring;
  }

  @override
  set animesAiring(ObservableFuture<List<Anime>> value) {
    _$animesAiringAtom.reportWrite(value, super.animesAiring, () {
      super.animesAiring = value;
    });
  }

  final _$actualBarAtom = Atom(name: '_AnimeStore.actualBar');

  @override
  String get actualBar {
    _$actualBarAtom.reportRead();
    return super.actualBar;
  }

  @override
  set actualBar(String value) {
    _$actualBarAtom.reportWrite(value, super.actualBar, () {
      super.actualBar = value;
    });
  }

  final _$favoriteListPopularAtom =
      Atom(name: '_AnimeStore.favoriteListPopular');

  @override
  ObservableList<dynamic> get favoriteListPopular {
    _$favoriteListPopularAtom.reportRead();
    return super.favoriteListPopular;
  }

  @override
  set favoriteListPopular(ObservableList<dynamic> value) {
    _$favoriteListPopularAtom.reportWrite(value, super.favoriteListPopular, () {
      super.favoriteListPopular = value;
    });
  }

  final _$favoriteListAiringAtom = Atom(name: '_AnimeStore.favoriteListAiring');

  @override
  ObservableList<dynamic> get favoriteListAiring {
    _$favoriteListAiringAtom.reportRead();
    return super.favoriteListAiring;
  }

  @override
  set favoriteListAiring(ObservableList<dynamic> value) {
    _$favoriteListAiringAtom.reportWrite(value, super.favoriteListAiring, () {
      super.favoriteListAiring = value;
    });
  }

  final _$favoriteListHighestAtom =
      Atom(name: '_AnimeStore.favoriteListHighest');

  @override
  ObservableList<dynamic> get favoriteListHighest {
    _$favoriteListHighestAtom.reportRead();
    return super.favoriteListHighest;
  }

  @override
  set favoriteListHighest(ObservableList<dynamic> value) {
    _$favoriteListHighestAtom.reportWrite(value, super.favoriteListHighest, () {
      super.favoriteListHighest = value;
    });
  }

  final _$favoriteListUpComingAtom =
      Atom(name: '_AnimeStore.favoriteListUpComing');

  @override
  ObservableList<dynamic> get favoriteListUpComing {
    _$favoriteListUpComingAtom.reportRead();
    return super.favoriteListUpComing;
  }

  @override
  set favoriteListUpComing(ObservableList<dynamic> value) {
    _$favoriteListUpComingAtom.reportWrite(value, super.favoriteListUpComing,
        () {
      super.favoriteListUpComing = value;
    });
  }

  final _$getAnimesAsyncAction = AsyncAction('_AnimeStore.getAnimes');

  @override
  Future<void> getAnimes(String filter) {
    return _$getAnimesAsyncAction.run(() => super.getAnimes(filter));
  }

  final _$loadMoreAnimesAsyncAction = AsyncAction('_AnimeStore.loadMoreAnimes');

  @override
  Future loadMoreAnimes(String actualBar) {
    return _$loadMoreAnimesAsyncAction
        .run(() => super.loadMoreAnimes(actualBar));
  }

  final _$_AnimeStoreActionController = ActionController(name: '_AnimeStore');

  @override
  dynamic setfavoriteListPopular(int index) {
    final _$actionInfo = _$_AnimeStoreActionController.startAction(
        name: '_AnimeStore.setfavoriteListPopular');
    try {
      return super.setfavoriteListPopular(index);
    } finally {
      _$_AnimeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setfavoriteListHighest(int index) {
    final _$actionInfo = _$_AnimeStoreActionController.startAction(
        name: '_AnimeStore.setfavoriteListHighest');
    try {
      return super.setfavoriteListHighest(index);
    } finally {
      _$_AnimeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setfavoriteListAiring(int index) {
    final _$actionInfo = _$_AnimeStoreActionController.startAction(
        name: '_AnimeStore.setfavoriteListAiring');
    try {
      return super.setfavoriteListAiring(index);
    } finally {
      _$_AnimeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setfavoriteListUpComing(int index) {
    final _$actionInfo = _$_AnimeStoreActionController.startAction(
        name: '_AnimeStore.setfavoriteListUpComing');
    try {
      return super.setfavoriteListUpComing(index);
    } finally {
      _$_AnimeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
animesPopular: ${animesPopular},
animesHighest: ${animesHighest},
animesUpcoming: ${animesUpcoming},
animesAiring: ${animesAiring},
actualBar: ${actualBar},
favoriteListPopular: ${favoriteListPopular},
favoriteListAiring: ${favoriteListAiring},
favoriteListHighest: ${favoriteListHighest},
favoriteListUpComing: ${favoriteListUpComing},
getAnimesPopular: ${getAnimesPopular},
getAnimesHighest: ${getAnimesHighest},
getAnimesUpcoming: ${getAnimesUpcoming},
getAnimesAiring: ${getAnimesAiring}
    ''';
  }
}
