import 'package:flutter/material.dart';
import 'package:project1/stores/search_store.dart';
import 'package:project1/widgets/lists/listSearchAnime_widget.dart';
import 'package:project1/widgets/lists/listSearchCategorie_widget.dart';
import 'package:project1/widgets/lists/listSearchCharacter_widget.dart';
import 'package:project1/support/global_variables.dart' as globals;

class Search extends SearchDelegate {
  final store = SearchStore();
  String lastQuery;
  String actualTab;
  Search({this.actualTab});
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          store.setListResult(actualTab, null);
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query == "") {
      return Container();
    } else {
      return listSearchByName();
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == "") {
      if (store.getListResult(actualTab) == null) {
        return Container();
      } else {
        return listSearchByName();
      }
    } else if (store.lastQuery != query) {
      store.search(query, actualTab);
      return listSearchByName();
    } else {
      if (store.getListResult(actualTab) == null) {
        return Container();
      } else {
        return listSearchByName();
      }
    }
  }

  Widget listSearchByName() {
    switch (actualTab) {
      case globals.stringTabSearchAnimes:
        return ListSearchAnime(
          storeSearch: store,
          query: query,
          actualBar: globals.stringTabSearchAnimes,
        );
      case globals.stringTabSearchCharacters:
        return ListSearchCharacter(
          storeSearch: store,
          query: query,
          actualBar: globals.stringTabSearchCharacters,
        );
      case globals.stringTabSearchCategories:
        return ListSearchCategorie(
          storeSearch: store,
          query: query,
          actualBar: globals.stringTabSearchCategories,
        );
      default:
        return Container();
    }
  }
}
