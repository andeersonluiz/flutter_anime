import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:project1/model/episode_model.dart';
import 'package:http/http.dart' as http;

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
    response = await http.get(url);
    var decoded = json.decode(response.body);
    decoded['links']['next'] == null
        ? loadedAllList = true
        : nextPage = decoded['links']['next'];

    if (decoded['data'][0]['attributes']['seasonNumber'] == null) {
      isMovie = true;
      return [];
    } else if (decoded['data'][0]['attributes']['length'] == null) {
      nullEps = true;
    } else {
      return decoded['data']
          .map<Episode>((json) => Episode.fromJson(json))
          .toList();
    }
  }
}
