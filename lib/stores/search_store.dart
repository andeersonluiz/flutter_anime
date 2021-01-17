import 'dart:convert';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/model/anime_model.dart';
import 'package:http/http.dart' as http;
part 'search_store.g.dart';

class SearchStore = _SearchStoreBase with _$SearchStore;

abstract class _SearchStoreBase with Store {
  @observable
  ObservableFuture<List<Anime>> searchResults;


  String lastQuery;
  http.Response response;

  @action
  searchAnime(String name) {
     EasyDebounce.debounce(
        "my-debounce",
        Duration(milliseconds: 500),
        () { 
          lastQuery=name;
          return searchResults=ObservableFuture(_decode(
                    "https://kitsu.io/api/edge/anime?filter[text]=$name"))
                .then((value) {
              return value;
            });
        }
          );
  }

  _decode(String url) async {
    response = await http
        .get(url, headers: {'Content-Type': 'application/json;charset=utf-8'});
    var decoded = json.decode(utf8.decode(response.bodyBytes));
    return decoded['data'].map<Anime>((json) => Anime.fromJson(json)).toList();
  }
}
