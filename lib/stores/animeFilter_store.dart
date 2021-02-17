import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:project1/model/anime_model.dart';
import 'package:http/http.dart' as http;
part 'animeFilter_store.g.dart';

class AnimeFilterStore = _AnimeFilterStoreBase with _$AnimeFilterStore;

abstract class _AnimeFilterStoreBase with Store {
  @observable
  ObservableFuture<List<Anime>> listAnimes;
  http.Response response;
  bool loadedAllList = false;
  String nextPage;
  bool lockLoad = false;

  @action
  getAnimesByCategorie(String categorie) {
    listAnimes = ObservableFuture(_decode(
            "https://kitsu.io/api/edge/anime?sort=-userCount,-favoritesCount&filter[categories]=$categorie"))
        .then((value) => value);
  }

  loadMoreAnimes() {
    listAnimes =
        listAnimes.replace(ObservableFuture(_decode(nextPage)).then((value) {
      lockLoad = false;
      return listAnimes.value + value;
    }));
  }

  _decode(String url) async {
    response = await http.get(url);
    var decoded = json.decode(utf8.decode(response.bodyBytes));
    decoded['links']['next'] == null
        ? loadedAllList = true
        : nextPage = decoded['links']['next'];
    return decoded['data' ].map<Anime>((json) => Anime.fromJson(json)).toList();
  }
}
