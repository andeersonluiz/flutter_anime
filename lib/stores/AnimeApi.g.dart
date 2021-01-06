// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AnimeApi.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AnimeApi on _AnimeApi, Store {
  final _$animesAtom = Atom(name: '_AnimeApi.animes');

  @override
  ObservableFuture<List<Anime>> get animes {
    _$animesAtom.reportRead();
    return super.animes;
  }

  @override
  set animes(ObservableFuture<List<Anime>> value) {
    _$animesAtom.reportWrite(value, super.animes, () {
      super.animes = value;
    });
  }

  final _$getAnimesAsyncAction = AsyncAction('_AnimeApi.getAnimes');

  @override
  Future getAnimes(String filter) {
    return _$getAnimesAsyncAction.run(() => super.getAnimes(filter));
  }

  final _$loadMoreAnimesAsyncAction = AsyncAction('_AnimeApi.loadMoreAnimes');

  @override
  Future loadMoreAnimes() {
    return _$loadMoreAnimesAsyncAction.run(() => super.loadMoreAnimes());
  }

  @override
  String toString() {
    return '''
animes: ${animes}
    ''';
  }
}
