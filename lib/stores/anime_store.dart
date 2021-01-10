import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';

import 'dart:convert';
import 'package:project1/model/anime_model.dart';
import 'package:project1/support/global_variables.dart';

part 'anime_store.g.dart';



class AnimeStore = _AnimeStore with _$AnimeStore;

abstract class _AnimeStore with Store {
  
  http.Response response;
  static String nextPage;
  int qtdAnim = 10;
  
  static ObservableFuture<List<Anime>> emptyResponse =
      ObservableFuture.value([]);


  
  @observable
  ObservableFuture<List<Anime>> animesPopular = emptyResponse;

  @observable
  ObservableFuture<List<Anime>> animesHighest = emptyResponse;

  @observable
  ObservableFuture<List<Anime>> animesUpcoming = emptyResponse;

  @observable
  ObservableFuture<List<Anime>> animesAiring = emptyResponse;

  @observable
  String actualBar = "Most Popular";


  bool loadedAllList = false;

  _AnimeStore() {
    getAnimes("Most Popular");
    getAnimes("Top Airing");
    getAnimes("Highest Rated");
    getAnimes("Top Upcoming");

  }

  @action
  getAnimes(String filter) async {
    loadedAllList = false;
    switch (filter) {
      case "Most Popular":
        this.animesPopular = ObservableFuture(_decode(
                "https://kitsu.io/api/edge/anime?sort=-userCount,-favoritesCount&page[limit]=$qtdAnim&page[offset]=0"))
            .then((animesPopular) => animesPopular);

        break;
      case "Highest Rated":
        this.animesHighest = ObservableFuture(_decode(
                "https://kitsu.io/api/edge/anime?sort=-averageRating&page[limit]=$qtdAnim&page[offset]=0"))
            .then((animesHighest) => animesHighest);

        break;
      case "Top Upcoming":
        this.animesUpcoming = ObservableFuture(_decode(
                "https://kitsu.io/api/edge/anime?sort=-userCount,-favoritesCount&filter[status]=upcoming&page[limit]=$qtdAnim&page[offset]=0"))
            .then((animesUpcoming) => animesUpcoming);
        break;
      case "Top Airing":
        this.animesAiring = ObservableFuture(_decode(
                "https://kitsu.io/api/edge/anime?sort=-userCount,-favoritesCount&filter[status]=current&page[limit]=$qtdAnim&page[offset]=0"))
            .then((animesAiring) => animesAiring);

        break;
    }
  }

  @action
  loadMoreAnimes() async {
    print("xx"+actualBar);
    switch(actualBar){
      case "Most Popular":
        this.animesPopular = (animesPopular.replace(ObservableFuture(_decode(nextPage))
        .then((anime) => animesPopular.value + anime)));
        break;
      case "Highest Rated":
        this.animesHighest = (animesHighest.replace(ObservableFuture(_decode(nextPage))
        .then((anime) => animesHighest.value + anime)));
        break;
      case "Top Upcoming":
        this.animesUpcoming = (animesUpcoming.replace(ObservableFuture(_decode(nextPage))
        .then((anime) => animesUpcoming.value + anime)));
        break;
      case "Top Airing":
        this.animesAiring = (animesAiring.replace(ObservableFuture(_decode(nextPage))
        .then((anime) => animesAiring.value + anime)));
        break;
    }
    
  }

  _decode(String url) async {
    response = await http.get(url);
    var decoded = json.decode(response.body);
    nextPage = decoded['links']['next'];
    if(nextPage==null){
      loadedAllList=true;
    }

    List<Anime> localAnimes =decoded['data'].map<Anime>((value) => Anime.fromJson(value)).toList();

    return localAnimes;
  }
}
