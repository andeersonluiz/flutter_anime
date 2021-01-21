import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/stores/search_store.dart';
import 'package:project1/widgets/errorLoading_widget.dart';
import 'package:project1/widgets/loading_widget.dart';
import 'package:project1/widgets/tiles/animeSearchTile_widget.dart';

class ListSearchAnime extends StatelessWidget {
  final SearchStore storeSearch;
  final query;
  final actualBar;
  ListSearchAnime({this.storeSearch, this.query, this.actualBar});
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      if (storeSearch.searchResultsAnimes != null) {
        switch (storeSearch.searchResultsAnimes.status) {
          case FutureStatus.pending:
            return Loading();
          case FutureStatus.rejected:
            return ErrorLoading(
                msg: "Error to loading results, verify your connection",
                refresh: _refresh);
          case FutureStatus.fulfilled:
            if (storeSearch.searchResultsAnimes.value.isEmpty) {
              return ErrorLoading(msg: "Not found animes", refresh: _refresh);
            }
            return ListView.builder(
                itemCount: storeSearch.searchResultsAnimes.value.length,
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed("/animeInfo",
                          arguments:
                              storeSearch.searchResultsAnimes.value[index]);
                    },
                    child: AnimeSearchTile(
                        anime: storeSearch.searchResultsAnimes.value[index]),
                  );
                });
          default:
            return ErrorLoading(
                msg: "Error to load animes.", refresh: _refresh);
        }
      } else {
        return Loading();
      }
    });
  }

  Future<void> _refresh() async {
    return storeSearch.search(query, actualBar);
  }
}
