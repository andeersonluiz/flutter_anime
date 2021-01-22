import 'package:flutter/material.dart';
import 'package:project1/stores/search_store.dart';
import 'package:project1/widgets/lists/listSearchAnime_widget.dart';
import 'package:project1/widgets/lists/listSearchCategorie_widget.dart';
import 'package:project1/widgets/lists/listSearchCharacter_widget.dart';
import 'package:project1/support/global_variables.dart' as globals;
import 'package:project1/stores/firebase_store.dart';
import 'package:provider/provider.dart';

class Search extends SearchDelegate {
  final store = SearchStore();
  String lastQuery;
  String actualTab;
  final color;
  Search({this.actualTab, this.color});

  @override
  ThemeData appBarTheme(BuildContext context) {
    final firebaseStore = Provider.of<FirebaseStore>(context);
    final colorText = firebaseStore.isDarkTheme ? Colors.white : Colors.black;
    return ThemeData(
      primaryColor: firebaseStore.isDarkTheme ? Colors.black : Colors.white,
      inputDecorationTheme: InputDecorationTheme(hintStyle: TextStyle(color: colorText),labelStyle: TextStyle(color: colorText),),
      appBarTheme: AppBarTheme(color:colorText,),
      textTheme: TextTheme(
          headline6: TextStyle(
              color: firebaseStore.isDarkTheme ? Colors.white : Colors.black)),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      Container(
        color: color,
        child: IconButton(
          icon: Icon(Icons.close, color: color==Colors.black?Colors.white:Colors.black),
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
      icon: Icon(Icons.arrow_back, color: color==Colors.black?Colors.white:Colors.black),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query == "") {
      return Container(color:color);
    } else {
      return listSearchByName();
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == "") {
      if (store.getListResult(actualTab) == null) {
        return Container(color:color);
      } else {
        return listSearchByName();
      }
    } else if (store.lastQuery != query) {
      store.search(query, actualTab);
      return listSearchByName();
    } else {
      if (store.getListResult(actualTab) == null) {
        return Container(color:color);
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
          color:color,
        );
      case globals.stringTabSearchCharacters:
        return ListSearchCharacter(
          storeSearch: store,
          query: query,
          actualBar: globals.stringTabSearchCharacters,
          color:color,
        );
      case globals.stringTabSearchCategories:
        return ListSearchCategorie(
          storeSearch: store,
          query: query,
          actualBar: globals.stringTabSearchCategories,
          color:color,
        );
      default:
        return Container(color:color);
    }
  }
}
