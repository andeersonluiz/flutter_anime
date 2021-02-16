import 'dart:convert';
import 'package:project1/stores/translation_store.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/model/categorie_model.dart';
import 'package:http/http.dart' as http;
part 'categorie_store.g.dart';

class CategorieStore = _CategorieStoreBase with _$CategorieStore;

abstract class _CategorieStoreBase with Store {
  @observable
  ObservableFuture<List<Categorie>> listCategories;
  http.Response response;
  String nextPage;
  @observable
  bool checkedBox = false;
  bool loadedAllList = false;
  bool lockLoad = false;

  @action
  getCategoriesTrends() {
    listCategories = ObservableFuture(_decode(
            "https://kitsu.io/api/edge/categories?sort=-totalMediaCount&page[limit]=40"))
        .then((value) => value);
  }

  @action
  getAllCategories() {
    listCategories = ObservableFuture(_decode(
            "https://kitsu.io/api/edge/categories?sort=title&page[limit]=40"))
        .then((value) => value);
  }

  @action
  loadCategories() {
    listCategories = listCategories
        .replace(ObservableFuture(_decode(nextPage)).then((value) {
      lockLoad = false;
      return listCategories.value + value;
    }));
  }

  _decode(String url) async {
    response = await http.get(url);
    var decoded = json.decode(utf8.decode(response.bodyBytes));
    decoded['links']['next'] == null
        ? loadedAllList = true
        : nextPage = decoded['links']['next'];
    List<Categorie> list = decoded['data']
        .map<Categorie>((json) => Categorie.fromJson(json))
        .toList();
    TranslateStore translateStore = TranslateStore();
    list.sort((a, b) => a.name.compareTo(b.name));
    list = await translateStore.translateCategories(list);
    await Future.delayed(Duration(seconds: 2));
    return list;
  }
}
