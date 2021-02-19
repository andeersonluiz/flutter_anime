import 'dart:convert';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';
import 'package:project1/model/anime_model.dart';
import 'package:project1/model/categorie_model.dart';
import 'package:project1/model/character_model.dart';
import 'package:project1/support/global_variables.dart' as globals;
import 'package:project1/stores/favoriteAnime_store.dart';

part 'search_store.g.dart';

class SearchStore = _SearchStoreBase with _$SearchStore;

abstract class _SearchStoreBase with Store {
  @observable
  ObservableFuture<List<Anime>> searchResultsAnimes;

  @observable
  ObservableFuture<List<Character>> searchResultsCharacters;

  @observable
  ObservableFuture<List<Categorie>> searchResultsCategories;

  @observable
  ObservableList<dynamic> favStatus;

  ObservableFuture<List<Object>> getListResult(String tab) {
    if (tab == globals.stringTabSearchAnimes) {
      return searchResultsAnimes;
    } else if (tab == globals.stringTabSearchCharacters) {
      return searchResultsCharacters;
    } else if (tab == globals.stringTabSearchCategories) {
      return searchResultsCategories;
    }
    return null;
  }

  ObservableFuture<List<Object>> setListResult(
      String tab, ObservableFuture<List<Object>> value) {
    if (tab == globals.stringTabSearchAnimes) {
      return searchResultsAnimes = value;
    } else if (tab == globals.stringTabSearchCharacters) {
      return searchResultsCharacters = value;
    } else if (tab == globals.stringTabSearchCategories) {
      return searchResultsCategories = value;
    }
    return null;
  }

  String lastQuery;
  http.Response response;

  @action
  search(String query, String typeSearch, bool isLogged,
      {FavoriteAnimeStore favStore}) async {
    switch (typeSearch) {
      case "Anime":
        EasyDebounce.debounce("my-debounce", Duration(milliseconds: 750), () {
          lastQuery = query;
          return searchResultsAnimes = ObservableFuture(_decodeAnime(
                  "https://kitsu.io/api/edge/anime?filter[text]=$query",
                  favStore,
                  isLogged))
              .then((value) {
            return value;
          });
        });
        break;
      case "Character":
        EasyDebounce.debounce("my-debounce", Duration(milliseconds: 750), () {
          lastQuery = query;
          return searchResultsCharacters = ObservableFuture(_decodeCharacter(
                  "https://kitsu.io/api/edge/characters?filter[name]=$query"))
              .then((value) {
            return value;
          });
        });
        break;
      case "Categorie":
        EasyDebounce.debounce("my-debounce", Duration(milliseconds: 750), () {
          lastQuery = query;
          return searchResultsCategories = ObservableFuture(_decodeCategorie(
                  "https://kitsu.io/api/edge/categories?filter[slug]=$query"))
              .then((value) {
            return value;
          });
        });
        break;
    }
  }

  _decodeAnime(String url, FavoriteAnimeStore favStore, bool isLogged) async {
    response = await http
        .get(url, headers: {'Content-Type': 'application/json;charset=utf-8'});
    var decoded = json.decode(utf8.decode(response.bodyBytes));

    List<Anime> animesResult =
        decoded['data'].map<Anime>((json) => Anime.fromJson(json)).toList();
    if (animesResult.length == 0) {
      return animesResult;
    }
    if (favStore.favoriteAnimes == null) {
      favStore.getFavoriteAnimes();
      await Future.delayed(Duration(seconds: 5));
    }
    favStatus =
        ObservableList.of(List.filled(animesResult.length, ["", false]));

    for (int i = 0; i < animesResult.length; i++) {
      animesResult[i].isFavorite = true;

      List<Anime> localAnime = favStore.favoriteAnimes.value
          .where((item) => item.id == animesResult[i].id)
          .toList();
      if (localAnime.length > 0) {
        favStatus[i] = [localAnime[0].id, true];
      } else {
        favStatus[i] = [animesResult[i].id, false];
        animesResult[i].isFavorite = false;
      }
    }

    return animesResult;
  }

  _decodeCharacter(String url) async {
    response = await http
        .get(url, headers: {'Content-Type': 'application/json;charset=utf-8'});
    var decoded = json.decode(utf8.decode(response.bodyBytes));
    return decoded['data']
        .map<Character>((json) => Character.fromJson(json))
        .toList();
  }

  _decodeCategorie(String url) async {
    response = await http
        .get(url, headers: {'Content-Type': 'application/json;charset=utf-8'});
    var decoded = json.decode(utf8.decode(response.bodyBytes));
    return decoded['data']
        .map<Categorie>((json) => Categorie.fromJson(json))
        .toList();
  }

  changeStatus(int index) {
    this.favStatus[index] = [favStatus[index][0], !favStatus[index][1]];
  }

  changeStatusById(Anime anime) {
    if (favStatus != null) {
      for (int i = 0; i < favStatus.length; i++) {
        if (favStatus[i][0] == anime.id) {
          this.favStatus[i] = [favStatus[i][0], !favStatus[i][1]];
          return;
        }
      }
    }
  }
}
