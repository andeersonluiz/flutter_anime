import 'package:flutter/material.dart';
import 'package:project1/stores/search_store.dart';
import 'package:project1/widgets/lists/listSearchAnime_widget.dart';
import 'package:project1/widgets/lists/listSearchCategorie_widget.dart';
import 'package:project1/widgets/lists/listSearchCharacter_widget.dart';
import 'package:project1/support/global_variables.dart' as globals;
import 'package:project1/stores/firebase_store.dart';
import 'package:provider/provider.dart';
import 'package:project1/stores/favoriteAnime_store.dart';

class Search extends SearchDelegate {
  String lastQuery;
  String actualTab;
  ThemeData themeData;
  Search({this.actualTab});

  @override
  ThemeData appBarTheme(BuildContext context) {
    themeData = Theme.of(context);
    return ThemeData(
      primaryColor: themeData.primaryColor,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: themeData.indicatorColor),
        labelStyle: TextStyle(color: themeData.indicatorColor),
      ),
      appBarTheme: AppBarTheme(
        color: themeData.indicatorColor,
      ),
      textTheme: TextTheme(
          headline6: TextStyle(
        color: themeData.indicatorColor,
      )),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    final store = Provider.of<SearchStore>(context);

    return <Widget>[
      Container(
        color: themeData.primaryColor,
        child: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(Icons.close, color: themeData.indicatorColor),
          onPressed: () {
            store.setListResult(actualTab, null);
            query = "";
          },
        ),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: Icon(Icons.arrow_back, color: themeData.indicatorColor),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query == "") {
      return Container(color: themeData.primaryColor);
    } else {
      return listSearchByName();
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final store = Provider.of<SearchStore>(context);
    final favStore = Provider.of<FavoriteAnimeStore>(context);
    final firebaseStore = Provider.of<FirebaseStore>(context);

    if (query == "") {
      if (store.getListResult(actualTab) == null) {
        return Container(color: themeData.primaryColor);
      } else {
        return listSearchByName();
      }
    } else if (store.lastQuery != query) {
      store.search(query, actualTab, firebaseStore.isLogged,
          favStore: favStore);
      store.lastQuery = "";
      return listSearchByName();
    } else {
      if (store.getListResult(actualTab) == null) {
        return Container(color: themeData.primaryColor);
      } else {
        return listSearchByName();
      }
    }
  }

  Widget listSearchByName() {
    switch (actualTab) {
      case globals.stringTabSearchAnimes:
        return ListSearchAnime(
          query: query,
          actualBar: globals.stringTabSearchAnimes,
          color: themeData.primaryColor,
        );
      case globals.stringTabSearchCharacters:
        return ListSearchCharacter(
          query: query,
          actualBar: globals.stringTabSearchCharacters,
          color: themeData.primaryColor,
        );
      case globals.stringTabSearchCategories:
        return ListSearchCategorie(
          query: query,
          actualBar: globals.stringTabSearchCategories,
        );
      default:
        return Container(color: themeData.primaryColor);
    }
  }
}
