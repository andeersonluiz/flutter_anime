import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:project1/model/character_model.dart';
import 'package:http/http.dart' as http;

part 'animeCharacter_store.g.dart';

class AnimeCharacterStore = _AnimeCharacterStoreBase with _$AnimeCharacterStore;

abstract class _AnimeCharacterStoreBase with Store {
  http.Response response;
  bool loadedAllList = false;
  bool lockLoad = false;
  String nextPage;
  @observable
  ObservableFuture<List<Character>> listCharacters;

  @action
  getCharacters(String url) {
    var stopWatch = new Stopwatch()..start();

    listCharacters = ObservableFuture(_decode(url + "?page[limit]=15"))
        .then((listCharacters) {
      print("getCharacters executed in ${stopWatch.elapsed}");
      return listCharacters;
    });
  }

  @action
  loadMoreCharacters() {
    var stopWatch = new Stopwatch()..start();
    listCharacters = listCharacters
        .replace(ObservableFuture(_decode(nextPage)).then((value) {
      print("loadMoreCharacters executed in ${stopWatch.elapsed}");
      lockLoad = false;
      return listCharacters.value + value;
    }));
  }

  _decode(String url) async {
    response = await http
        .get(url, headers: {'Content-Type': 'application/json;charset=utf-8'});
    var decoded = json.decode(utf8.decode(response.bodyBytes));
    if (decoded['data'] == null) {
      return [];
    }
    decoded['links']['next'] == null
        ? loadedAllList = true
        : nextPage = decoded['links']['next'];
    var urls = decoded['data']
        .map((value) {
          return value['relationships']['character']['links']['related'];
        })
        .cast<String>()
        .toList();
    List<Future<Character>> futureListCharacter;
    List<Character> listCharacter = [];
    futureListCharacter = await (urls).map<Future<Character>>((element) async {
      http.Response resp = await http.get(element,
          headers: {'Content-Type': 'application/json;charset=utf-8'});
      var decode = json.decode(utf8.decode(resp.bodyBytes));
      return (Character.fromJson(decode['data']));
    }).toList();
    for (int i = 0; i < futureListCharacter.length; i++) {
      await futureListCharacter[i].then((value) => listCharacter.add(value));
    }
    return listCharacter;
  }
}
