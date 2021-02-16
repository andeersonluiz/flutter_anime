import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:project1/model/episode_model.dart';
import 'package:http/http.dart' as http;
import 'package:project1/stores/translation_store.dart';

part 'episode_store.g.dart';

class EpisodeStore = _EpisodeStoreBase with _$EpisodeStore;

abstract class _EpisodeStoreBase with Store {
  http.Response response;
  String nextPage;
  bool loadedAllList = false;
  bool lockLoad = false;
  bool isMovie = false;
  bool nullEps = false;

  @observable
  ObservableFuture<List<Episode>> listEpisodes;

  @action
  getEpisodes(String url) {
    print("get episodes...");
    var stopWatch = new Stopwatch()..start();
    listEpisodes = ObservableFuture(_decode(url)).then((listEpisodes) {
      print("getEpisodes executed in ${stopWatch.elapsed}");

      return listEpisodes;
    });
  }

  @action
  loadMoreEpisodes() {
    print("loading more episodes");
    listEpisodes = listEpisodes
        .replace(ObservableFuture(_decode(nextPage)).then((episodes) {
      lockLoad = false;
      return (listEpisodes.value + episodes);
    }));
  }

  _decode(String url) async {
    response = await http
        .get(url, headers: {'Content-Type': 'application/json;charset=utf-8'});
    var decoded = json.decode(utf8.decode((response.bodyBytes)));
    decoded['links']['next'] == null
        ? loadedAllList = true
        : nextPage = decoded['links']['next'];

    if (decoded['data'][0]['attributes']['seasonNumber'] == null) {
      isMovie = true;
      return [];
    } else if (decoded['data'][0]['attributes']['length'] == null) {
      nullEps = true;
    } else {
      TranslateStore translateStore = TranslateStore();
      var list= await translateStore.translateEpisodes(decoded['data']
          .map<Episode>((json) => Episode.fromJson(json))
          .toList());
      return list;
    }
  }
}
