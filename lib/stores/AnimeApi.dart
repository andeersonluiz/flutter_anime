import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';

import 'dart:convert';
import 'package:project1/model/Anime.dart';
part 'AnimeApi.g.dart';

class AnimeApi = _AnimeApi with _$AnimeApi;

abstract class _AnimeApi with Store {
  http.Response response;
  static String nextPage;
  int qtdAnim = 10;
  static ObservableFuture<List<Anime>> emptyResponse =
      ObservableFuture.value([]);
  List<Anime> localAnimes = [];
  @observable
  ObservableFuture<List<Anime>> animes = emptyResponse;

  _AnimeApi() {
    getAnimes('Most Popular');
  }

  @action
  getAnimes(String filter) async {
    switch (filter) {
      case "Most Popular":
        animes = ObservableFuture.value([]);
        this.animes = ObservableFuture(decode(
                "https://kitsu.io/api/edge/anime?sort=-userCount,-favoritesCount&page[limit]=$qtdAnim&page[offset]=0"))
            .then((animes) => animes);

        break;
      case "Mais Votados":
        this.animes = ObservableFuture(decode(
                "https://kitsu.io/api/edge/anime?sort=-averageRating&page[limit]=$qtdAnim&page[offset]=0"))
            .then((animes) => animes);

        break;
      case "Lançamentos Futuros":
        this.animes = ObservableFuture(decode(
                "https://kitsu.io/api/edge/anime?sort=-userCount,-favoritesCount&filter[status]=upcoming&page[limit]=$qtdAnim&page[offset]=0"))
            .then((animes) => animes);
        break;
      case "Top Airing":
        animes = ObservableFuture.value([]);

        this.animes = ObservableFuture(decode(
                "https://kitsu.io/api/edge/anime?sort=-userCount,-favoritesCount&filter[status]=current&page[limit]=$qtdAnim&page[offset]=0"))
            .then((animes) => animes);

        break;
    }
  }

  @action
  loadMoreAnimes() async {
    this.animes = (animes.replace(ObservableFuture(decode(nextPage))
        .then((anime) => animes.value + anime)));
  }

  decode(String url) async {
    response = await http.get(url);
    var decoded = json.decode(response.body);
    nextPage = decoded['links']['next'];
    localAnimes =
        decoded['data'].map<Anime>((value) => Anime.fromJson(value)).toList();

    return localAnimes;
  }
}
