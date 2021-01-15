// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$EpisodeStore on _EpisodeStoreBase, Store {
  final _$listEpisodesAtom = Atom(name: '_EpisodeStoreBase.listEpisodes');

  @override
  ObservableFuture<List<Episode>> get listEpisodes {
    _$listEpisodesAtom.reportRead();
    return super.listEpisodes;
  }

  @override
  set listEpisodes(ObservableFuture<List<Episode>> value) {
    _$listEpisodesAtom.reportWrite(value, super.listEpisodes, () {
      super.listEpisodes = value;
    });
  }

  final _$_EpisodeStoreBaseActionController =
      ActionController(name: '_EpisodeStoreBase');

  @override
  dynamic getEpisodes(String url) {
    final _$actionInfo = _$_EpisodeStoreBaseActionController.startAction(
        name: '_EpisodeStoreBase.getEpisodes');
    try {
      return super.getEpisodes(url);
    } finally {
      _$_EpisodeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
listEpisodes: ${listEpisodes}
    ''';
  }
}
