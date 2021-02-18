import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:project1/model/anime_model.dart';
import 'package:http/http.dart' as http;
import 'package:project1/stores/favoriteAnime_store.dart';

part 'animeFilter_store.g.dart';

class AnimeFilterStore = _AnimeFilterStoreBase with _$AnimeFilterStore;

abstract class _AnimeFilterStoreBase with Store {
  @observable
  ObservableFuture<List<Anime>> listAnimes;

  @observable
  ObservableList<dynamic> favCategorie =
      ObservableList.of(List.filled(0, ["", false]));

  http.Response response;
  bool loadedAllList = false;
  String nextPage;
  bool lockLoad = false;

  @action
  getAnimesByCategorie(String categorie, FavoriteAnimeStore favStore) {
    listAnimes = ObservableFuture(_decode(
            "https://kitsu.io/api/edge/anime?sort=-userCount,-favoritesCount&filter[categories]=$categorie",
            favStore))
        .then((value) => value);
  }

  loadMoreAnimes(FavoriteAnimeStore favStore) {
    listAnimes = listAnimes
        .replace(ObservableFuture(_decode(nextPage, favStore)).then((value) {
      lockLoad = false;
      return listAnimes.value + value;
    }));
  }

  _decode(String url, FavoriteAnimeStore favStore) async {
    response = await http.get(url);
    var decoded = json.decode(utf8.decode(response.bodyBytes));
    decoded['links']['next'] == null
        ? loadedAllList = true
        : nextPage = decoded['links']['next'];
    List<Anime> animeResult =
        decoded['data'].map<Anime>((json) => Anime.fromJson(json)).toList();
    if (favStore.favoriteAnimes == null) {
      favStore.getFavoriteAnimes();
      await Future.delayed(Duration(seconds: 5));
    }
    if (animeResult.length == 0) {
      return animeResult;
    }

    for (int i = 0; i < animeResult.length; i++) {
      animeResult[i].isFavorite = true;

      List<Anime> localAnime = favStore.favoriteAnimes.value
          .where((item) => item.id == animeResult[i].id)
          .toList();
      if (localAnime.length > 0) {
        favCategorie.add([localAnime[0].id, true]);
      } else {
        favCategorie.add([animeResult[i].id, false]);
        animeResult[i].isFavorite = false;
      }
    }

    return animeResult;
  }

  changeStatusFav(int index) {
    this.favCategorie[index] = [
      favCategorie[index][0],
      !favCategorie[index][1]
    ];
  }
}
