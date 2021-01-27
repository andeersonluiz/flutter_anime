import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';
import 'package:project1/firebase/auth_firebase.dart';
import 'package:project1/firebase/cloudFirestore_firebase.dart';
import 'dart:async';
import 'dart:convert';
import 'package:project1/model/anime_model.dart';
import 'package:project1/support/global_variables.dart' as globals;
part 'anime_store.g.dart';

class AnimeStore = _AnimeStore with _$AnimeStore;

abstract class _AnimeStore with Store {
  http.Response response;
  static String nextPage;
  int qtdAnim = 10;

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

  @observable
  ObservableList<dynamic> favoriteListPopular =
      ObservableList.of(List.filled(10, ["", false]));
  @observable
  ObservableList<dynamic> favoriteListAiring =
      ObservableList.of(List.filled(10, ["", false]));
  @observable
  ObservableList<dynamic> favoriteListHighest =
      ObservableList.of(List.filled(10, ["", false]));
  @observable
  ObservableList<dynamic> favoriteListUpComing =
      ObservableList.of(List.filled(10, ["", false]));

  CloudFirestore cloud;
  Auth auth;
  _AnimeStore() {
    cloud = CloudFirestore();
    auth = Auth();
  }

  @action
  Future<void> getAnimes(String filter) async {
    var stopWatch = new Stopwatch()..start();
    switch (filter) {
      case globals.stringAnimesPopular:
        animesPopular = ObservableFuture(_decode(
                "https://kitsu.io/api/edge/anime?sort=-userCount,-favoritesCount&page[limit]=$qtdAnim&page[offset]=0",
                filter))
            .then((animesPop) {
          for (int i = 0; i < animesPop.length; i++) {
            favoriteListPopular[i] = [animesPop[i].id, animesPop[i].isFavorite];
          }

          print("getAnimes(animesPopular) executed in ${stopWatch.elapsed}");
          return animesPop;
        });

        break;
      case globals.stringAnimesHighest:
        animesHighest = ObservableFuture(_decode(
                "https://kitsu.io/api/edge/anime?sort=-averageRating&page[limit]=$qtdAnim&page[offset]=0",
                filter))
            .then((animesHighest) {
          print("getAnimes(animesHighest) executed in ${stopWatch.elapsed}");
          for (int i = 0; i < animesHighest.length; i++) {
            favoriteListHighest[i] = [
              animesHighest[i].id,
              animesHighest[i].isFavorite
            ];
          }
          return animesHighest;
        });

        break;
      case globals.stringAnimesUpcoming:
        animesUpcoming = ObservableFuture(_decode(
                "https://kitsu.io/api/edge/anime?sort=-userCount,-favoritesCount&filter[status]=upcoming&page[limit]=$qtdAnim&page[offset]=0",
                filter))
            .then((animesUpcoming) {
          print("getAnimes(animesUpcoming) executed in ${stopWatch.elapsed}");
          for (int i = 0; i < animesUpcoming.length; i++) {
            favoriteListUpComing[i] = [
              animesUpcoming[i].id,
              animesUpcoming[i].isFavorite
            ];
          }
          return animesUpcoming;
        });
        break;
      case globals.stringAnimesAiring:
        animesAiring = ObservableFuture(_decode(
                "https://kitsu.io/api/edge/anime?sort=-userCount,-favoritesCount&filter[status]=current&page[limit]=$qtdAnim&page[offset]=0",
                filter))
            .then((animesAiring) {
          for (int i = 0; i < animesAiring.length; i++) {
            favoriteListAiring[i] = [
              animesAiring[i].id,
              animesAiring[i].isFavorite
            ];
          }
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
    print("loading more animes...");
    switch (actualBar) {
      case "Most Popular":
        animesPopular = (animesPopular.replace(
            ObservableFuture(_decode(dataListPopular[1], actualBar))
                .then((anime) {
          print(
              "loadMoreAnimes(animesPopular) executed in ${stopWatch.elapsed}");
          for (int i = 0; i < anime.length; i++) {
            favoriteListPopular.add([anime[i].id, anime[i].isFavorite]);
          }
          return animesPopular.value + anime;
        })));
        break;
      case "Highest Rated":
        animesHighest = (animesHighest.replace(
            ObservableFuture(_decode(dataListHighest[1], actualBar))
                .then((anime) {
          print(
              "loadMoreAnimes(animesHighest) executed in ${stopWatch.elapsed}");
          for (int i = 0; i < anime.length; i++) {
            favoriteListHighest.add([anime[i].id, anime[i].isFavorite]);
          }

          return animesHighest.value + anime;
        })));
        break;
      case "Top Upcoming":
        animesUpcoming = (animesUpcoming.replace(
            ObservableFuture(_decode(dataListUpComing[1], actualBar))
                .then((anime) {
          print(
              "loadMoreAnimes(animesUpcoming) executed in ${stopWatch.elapsed}");
          for (int i = 0; i < anime.length; i++) {
            favoriteListUpComing.add([anime[i].id, anime[i].isFavorite]);
          }
          return animesUpcoming.value + anime;
        })));
        break;
      case "Top Airing":
        animesAiring = (animesAiring.replace(
            ObservableFuture(_decode(dataListAiring[1], actualBar))
                .then((anime) {
          print(
              "loadMoreAnimes(animesAiring) executed in ${stopWatch.elapsed}");
          for (int i = 0; i < anime.length; i++) {
            favoriteListAiring.add([anime[i].id, anime[i].isFavorite]);
          }
          return animesAiring.value + anime;
        })));
        break;
    }
  }

  _decode(String url, String nameBar) async {
    response = await http
        .get(url, headers: {'Content-Type': 'application/json;charset=utf-8'});
    var decoded = json.decode(utf8.decode(response.bodyBytes));
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
    String email = auth?.getUser()?.email;

    List<dynamic> favorites = await cloud.getFavoritesAnimesId(email);
    return decoded['data'].map<Anime>((value) {
      print(
          "${favorites.contains(value['id'])} ${value['id']} ${favorites.contains("210")}");

      if (favorites.contains(value['id'])) {
        return Anime.fromJson(value, isFavorite: true);
      } else {
        return Anime.fromJson(value);
      }
    }).toList();
  }

  @action
  setfavoriteListPopular(int index) {
    this.favoriteListPopular[index] = [
      favoriteListPopular[index][0],
      !favoriteListPopular[index][1]
    ];
    attListHighestIfExists(favoriteListPopular[index]);
    attListAiringIfExists(favoriteListPopular[index]);
    attListUpComingIfExists(favoriteListPopular[index]);
  }

  @action
  setfavoriteListHighest(int index) {
    this.favoriteListHighest[index] = [
      favoriteListHighest[index][0],
      !favoriteListHighest[index][1]
    ];
    attListPopularIfExists(favoriteListHighest[index]);
    attListAiringIfExists(favoriteListHighest[index]);
    attListUpComingIfExists(favoriteListHighest[index]);
  }

  @action
  setfavoriteListAiring(int index) {
    this.favoriteListAiring[index] = [
      favoriteListAiring[index][0],
      !favoriteListAiring[index][1]
    ];
    attListPopularIfExists(favoriteListAiring[index]);
    attListHighestIfExists(favoriteListAiring[index]);
    attListUpComingIfExists(favoriteListAiring[index]);
  }

  @action
  setfavoriteListUpComing(int index) {
    this.favoriteListUpComing[index] = [
      favoriteListUpComing[index][0],
      !favoriteListUpComing[index][1]
    ];
    attListPopularIfExists(favoriteListUpComing[index]);
    attListHighestIfExists(favoriteListUpComing[index]);
    attListAiringIfExists(favoriteListUpComing[index]);
  }

  attListPopularIfExists(List<dynamic> object) {
    for (int i = 0; i < favoriteListPopular.length; i++) {
      if (object[0] == favoriteListPopular[i][0] &&
          object[1] != favoriteListPopular[i][1]) {
        this.favoriteListPopular[i] = [favoriteListPopular[i][0], object[1]];
        return;
      }
    }
  }

  attListHighestIfExists(List<dynamic> object) {
    for (int i = 0; i < favoriteListHighest.length; i++) {
      if (object[0] == favoriteListHighest[i][0] &&
          object[1] != favoriteListHighest[i][1]) {
        this.favoriteListHighest[i] = [favoriteListHighest[i][0], object[1]];
        return;
      }
    }
  }

  attListAiringIfExists(List<dynamic> object) {
    for (int i = 0; i < favoriteListAiring.length; i++) {
      if (object[0] == favoriteListAiring[i][0] &&
          object[1] != favoriteListAiring[i][1]) {
        this.favoriteListAiring[i] = [favoriteListAiring[i][0], object[1]];
        return;
      }
    }
  }

  attListUpComingIfExists(List<dynamic> object) {
    for (int i = 0; i < favoriteListUpComing.length; i++) {
      if (object[0] == favoriteListUpComing[i][0] &&
          object[1] != favoriteListUpComing[i][1]) {
        this.favoriteListUpComing[i] = [favoriteListUpComing[i][0], object[1]];
        return;
      }
    }
  }

  removeFavoriteByName(String id) {
    for (int i = 0; i < favoriteListPopular.length; i++) {
      if (id == favoriteListPopular[i][0]) {
        this.favoriteListPopular[i] = [favoriteListPopular[i][0], false];
        break;
      }
    }

    for (int i = 0; i < favoriteListHighest.length; i++) {
      if (id == favoriteListHighest[i][0]) {
        this.favoriteListHighest[i] = [favoriteListHighest[i][0], false];
        break;
      }
    }

    for (int i = 0; i < favoriteListAiring.length; i++) {
      if (id == favoriteListAiring[i][0]) {
        this.favoriteListAiring[i] = [favoriteListAiring[i][0], false];
        break;
      }
    }

    for (int i = 0; i < favoriteListUpComing.length; i++) {
      if (id == favoriteListUpComing[i][0]) {
        this.favoriteListUpComing[i] = [favoriteListUpComing[i][0], false];
        break;
      }
    }
  }
}
