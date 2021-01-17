import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:project1/model/character_model.dart';
import 'package:http/http.dart' as http;
part 'character_store.g.dart';

class CharacterStore = _CharacterStoreBase with _$CharacterStore;

abstract class _CharacterStoreBase with Store {

    http.Response response;
    String nextPage;
    bool loadedAllList=false;
      bool lockLoad = false;


    @observable
    ObservableFuture<List<Character>> listCharacters;

  @action
  getListCharacters(){
    print("get list Character...");
    listCharacters =  ObservableFuture(_decode("https://kitsu.io/api/edge/characters?sort=slug&page[limit]=20")).then((listCharacters) => listCharacters);
  }
  @action
  loadMoreCharacters(){
    listCharacters = listCharacters.replace(ObservableFuture(_decode(nextPage)).then((value){ 
      lockLoad=false;
      return listCharacters.value + value;}));
  }

  _decode(String url) async{
    response = await http.get(url,headers:{'Content-Type':'application/json;charset=utf-8'});
    var decoded = json.decode(utf8.decode(response.bodyBytes));
    decoded['links']['next']==null?loadedAllList=true:nextPage=decoded['links']['next'];
    return decoded['data'].map<Character>((json)=> Character.fromJson(json)).toList();
  }
}