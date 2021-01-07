import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';

import 'dart:convert';
import 'package:project1/model/anime_model.dart';
part 'anime_store.g.dart';

class AnimeStore = _AnimeStore with _$AnimeStore;

abstract class _AnimeStore with Store {
  http.Response response;
  static String nextPage;
  int qtdAnim = 10;
  static ObservableFuture<List<Anime>> emptyResponse =
      ObservableFuture.value([]);
  List<Anime> localAnimes = [];
  
  @observable
  ObservableFuture<List<Anime>> animes = emptyResponse;

  bool loadedAllList = false;

  _AnimeStore() {
    getAnimes('Most Popular');
  }

  @action
  getAnimes(String filter) async {
    loadedAllList = false;
    switch (filter) {
      case "Most Popular":
        this.animes = ObservableFuture(_decode(
                "https://kitsu.io/api/edge/anime?sort=-userCount,-favoritesCount&page[limit]=$qtdAnim&page[offset]=0"))
            .then((animes) => animes);

        break;
      case "Highest Rated":
        this.animes = ObservableFuture(_decode(
                "https://kitsu.io/api/edge/anime?sort=-averageRating&page[limit]=$qtdAnim&page[offset]=0"))
            .then((animes) => animes);

        break;
      case "Top Upcoming":
        this.animes = ObservableFuture(_decode(
                "https://kitsu.io/api/edge/anime?sort=-userCount,-favoritesCount&filter[status]=upcoming&page[limit]=$qtdAnim&page[offset]=0"))
            .then((animes) => animes);
        break;
      case "Top Airing":
        this.animes = ObservableFuture(_decode(
                "https://kitsu.io/api/edge/anime?sort=-userCount,-favoritesCount&filter[status]=current&page[limit]=$qtdAnim&page[offset]=0"))
            .then((animes) => animes);

        break;
    }
  }

  @action
  loadMoreAnimes() async {
    this.animes = (animes.replace(ObservableFuture(_decode(nextPage))
        .then((anime) => animes.value + anime)));
  }

  _decode(String url) async {
    response = await http.get(url);
    var decoded = json.decode(response.body);
    nextPage = decoded['links']['next'];
    if(nextPage==null){
      loadedAllList=true;
    }

    localAnimes =
        decoded['data'].map<Anime>((value) => Anime.fromJson(value)).toList();

    return localAnimes;
  }
}
