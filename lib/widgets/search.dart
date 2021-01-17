import 'package:flutter/material.dart';
import 'package:project1/stores/search_store.dart';
import 'package:project1/widgets/lists/listSearch_widget.dart';

class Search extends SearchDelegate {
  final storeSearch = SearchStore();
  String lastQuery;
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          storeSearch.searchResults=null;
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
    }else {
     return ListSearch(storeSearch:storeSearch);
    } 
    
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == "") {
      if(storeSearch.searchResults==null){
        return Container();
      }else{
        return ListSearch(storeSearch:storeSearch);
      }
    } else if (storeSearch.lastQuery != query) {
      storeSearch.searchAnime(query);
      return ListSearch(storeSearch:storeSearch);
    } else{
     if(storeSearch.searchResults==null){
        return Container();
      }else{
        return ListSearch(storeSearch:storeSearch);
      }
    }
  }
  

}
