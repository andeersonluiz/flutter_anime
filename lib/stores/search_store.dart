import 'dart:convert';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/model/anime_model.dart';
import 'package:http/http.dart' as http;
import 'package:project1/model/categorie_model.dart';
import 'package:project1/model/character_model.dart';
import 'package:project1/support/global_variables.dart' as globals;

part 'search_store.g.dart';

class SearchStore = _SearchStoreBase with _$SearchStore;

abstract class _SearchStoreBase with Store {
  @observable
  ObservableFuture<List<Anime>> searchResultsAnimes;

  @observable
  ObservableFuture<List<Character>> searchResultsCharacters;

  @observable
  ObservableFuture<List<Categorie>> searchResultsCategories;

  ObservableFuture<List<Object>> getListResult(String tab){
    if(tab==globals.stringTabSearchAnimes){
      return searchResultsAnimes;
    }else if(tab==globals.stringTabSearchCharacters){
      return searchResultsAnimes;
    }else if(tab==globals.stringTabSearchCategories){
     return searchResultsCategories;
    }
    return null;
  }

  ObservableFuture<List<Object>> setListResult(String tab,ObservableFuture<List<Object>> value){
    if(tab==globals.stringTabSearchAnimes){
      return searchResultsAnimes=value;
    }else if(tab==globals.stringTabSearchCharacters){
      return searchResultsAnimes=value;
    }else if(tab == globals.stringTabSearchCategories){
      return searchResultsCategories=value;
    }
    return null;
  }

  String lastQuery;
  http.Response response;

  @action
  search(String query,String typeSearch) {

    switch(typeSearch){
      case "Anime":
        EasyDebounce.debounce(
        "my-debounce",
        Duration(milliseconds: 500),
        () { 
          lastQuery=query;
          return searchResultsAnimes=ObservableFuture(_decodeAnime(
                    "https://kitsu.io/api/edge/anime?filter[text]=$query"))
                .then((value) {
              return value;
            });
        }
          );
          break;
  
      case "Character":
      EasyDebounce.debounce(
        "my-debounce",
        Duration(milliseconds: 500),
        () { 
          lastQuery=query;
          return searchResultsCharacters=ObservableFuture(_decodeCharacter(
                    "https://kitsu.io/api/edge/characters?filter[name]=$query"))
                .then((value) {
              return value;
            });
        }
        
          );
          break;
    case "Categorie":
        EasyDebounce.debounce(
        "my-debounce",
        Duration(milliseconds: 500),
        () { 
          lastQuery=query;
          return searchResultsCategories=ObservableFuture(_decodeCategorie(
                    "https://kitsu.io/api/edge/categories?filter[slug]=$query"))
                .then((value) {
              return value;
            });
        }
          );
        break;
    }
  }

  _decodeAnime(String url) async {
    response = await http
        .get(url, headers: {'Content-Type': 'application/json;charset=utf-8'});
    var decoded = json.decode(utf8.decode(response.bodyBytes));
    return decoded['data'].map<Anime>((json) => Anime.fromJson(json)).toList();
  }

  
  _decodeCharacter(String url) async {
    response = await http.get(url, headers: {'Content-Type': 'application/json;charset=utf-8'});
    var decoded = json.decode(utf8.decode(response.bodyBytes));
    return decoded['data'].map<Character>((json) => Character.fromJson(json)).toList();
 
  }

  _decodeCategorie(String url) async {
    response = await http.get(url, headers: {'Content-Type': 'application/json;charset=utf-8'});
    var decoded = json.decode(utf8.decode(response.bodyBytes));
    return decoded['data'].map<Categorie>((json) => Categorie.fromJson(json)).toList();
 
  }
}
