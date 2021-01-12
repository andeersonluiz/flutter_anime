import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';
import 'dart:math';
import 'dart:async';

import 'dart:convert';
import 'package:project1/model/anime_model.dart';
import 'package:project1/support/global_variables.dart' as globals;
import 'package:project1/support/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;

part 'anime_store.g.dart';

class AnimeStore = _AnimeStore with _$AnimeStore;

abstract class _AnimeStore with Store {
  http.Response response;
  static String nextPage;
  int qtdAnim = 10;

  static ObservableFuture<List<Anime>> emptyResponse =
      ObservableFuture.value([]);

  @observable
  ObservableFuture<List<Anime>> animesPopular;

  @observable
  ObservableFuture<List<Anime>> animesHighest;

  @observable
  ObservableFuture<List<Anime>> animesUpcoming;

  @observable
  ObservableFuture<List<Anime>> animesAiring;

  @computed
  ObservableFuture<List<Anime>> get getAnimesPopular => animesPopular;

  @computed
  ObservableFuture<List<Anime>> get getAnimesHighest => animesHighest;

  @computed
  ObservableFuture<List<Anime>> get getAnimesUpcoming => animesUpcoming;

  @computed
  ObservableFuture<List<Anime>> get getAnimesAiring => animesAiring;

  @observable
  String actualBar = "Most Popular";

  List<dynamic> dataListPopular = [false, ""];

  List<dynamic> dataListAiring = [false, ""];

  List<dynamic> dataListHighest = [false, ""];

  List<dynamic> dataListUpComing = [false, ""];

  _AnimeStore() {}

  @action
  Future<void> getAnimes(String filter) async {
    var stopWatch = new Stopwatch()..start();
    switch (filter) {
      case globals.stringAnimesPopular:
        animesPopular = ObservableFuture(_decode(
                "https://kitsu.io/api/edge/anime?sort=-userCount,-favoritesCount&page[limit]=$qtdAnim&page[offset]=0",
                filter))
            .then((animesPopular) {
          print("getAnimes(animesPopular) executed in ${stopWatch.elapsed}");
          return animesPopular;
        });

        break;
      case globals.stringAnimesHighest:
        animesHighest = ObservableFuture(_decode(
                "https://kitsu.io/api/edge/anime?sort=-averageRating&page[limit]=$qtdAnim&page[offset]=0",
                filter))
            .then((animesHighest) {
          print("getAnimes(animesHighest) executed in ${stopWatch.elapsed}");
          return animesHighest;
        });

        break;
      case globals.stringAnimesUpcoming:
        animesUpcoming = ObservableFuture(_decode(
                "https://kitsu.io/api/edge/anime?sort=-userCount,-favoritesCount&filter[status]=upcoming&page[limit]=$qtdAnim&page[offset]=0",
                filter))
            .then((animesUpcoming) {
          print("getAnimes(animesUpcoming) executed in ${stopWatch.elapsed}");
          return animesUpcoming;
        });
        break;
      case globals.stringAnimesAiring:
        animesAiring = ObservableFuture(_decode(
                "https://kitsu.io/api/edge/anime?sort=-userCount,-favoritesCount&filter[status]=current&page[limit]=$qtdAnim&page[offset]=0",
                filter))
            .then((animesAiring) {
          print("getAnimes(animesAiring) executed in ${stopWatch.elapsed}");
          return animesAiring;
        });

        break;
      default:
        return null;
    }
  }

  @action
  loadMoreAnimes(String actualBar) async {
    var stopWatch = new Stopwatch()..start();
    switch (actualBar) {
      case "Most Popular":
        animesPopular = (animesPopular.replace(
            ObservableFuture(_decode(dataListPopular[1], actualBar))
                .then((anime) {
          print(
              "loadMoreAnimes(animesPopular) executed in ${stopWatch.elapsed}");
          return animesPopular.value + anime;
        })));
        break;
      case "Highest Rated":
        animesHighest = (animesHighest.replace(
            ObservableFuture(_decode(dataListHighest[1], actualBar))
                .then((anime) {
          print(
              "loadMoreAnimes(animesHighest) executed in ${stopWatch.elapsed}");
          return animesHighest.value + anime;
        })));
        break;
      case "Top Upcoming":
        animesUpcoming = (animesUpcoming.replace(
            ObservableFuture(_decode(dataListUpComing[1], actualBar))
                .then((anime) {
          print(
              "loadMoreAnimes(animesUpcoming) executed in ${stopWatch.elapsed}");
          return animesUpcoming.value + anime;
        })));
        break;
      case "Top Airing":
        animesAiring = (animesAiring.replace(
            ObservableFuture(_decode(dataListAiring[1], actualBar))
                .then((anime) {
          print(
              "loadMoreAnimes(animesAiring) executed in ${stopWatch.elapsed}");
          return animesAiring.value + anime;
        })));
        break;
    }
  }

  _decode(String url, String nameBar) async {
    response = await http.get(url);
    var decoded = json.decode(response.body);
    nextPage = decoded['links']['next'];
    switch (nameBar) {
      case globals.stringAnimesHighest:
        dataListHighest[1] = nextPage;
        if (nextPage == null) {
          dataListHighest[0] = true;
        }
        break;
      case globals.stringAnimesPopular:
        dataListPopular[1] = nextPage;
        if (nextPage == null) {
          dataListPopular[0] = true;
        }
        break;
      case globals.stringAnimesAiring:
        dataListAiring[1] = nextPage;
        if (nextPage == null) {
          dataListAiring[0] = true;
        }
        break;
      case globals.stringAnimesUpcoming:
        dataListUpComing[1] = nextPage;
        if (nextPage == null) {
          dataListUpComing[0] = true;
        }
        break;
    }

    return decoded['data']
        .map<Anime>((value) => Anime.fromJson(value))
        .toList();
  }
}
