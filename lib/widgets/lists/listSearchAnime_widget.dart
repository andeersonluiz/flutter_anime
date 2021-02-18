import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/stores/search_store.dart';
import 'package:project1/widgets/errorLoading_widget.dart';
import 'package:project1/widgets/loading_widget.dart';
import 'package:project1/widgets/tiles/animeSearchTile_widget.dart';
import 'package:provider/provider.dart';
import 'package:project1/stores/favoriteAnime_store.dart';

class ListSearchAnime extends StatelessWidget {
  final query;
  final actualBar;
  final color;
  ListSearchAnime({this.query, this.actualBar, this.color});
  @override
  Widget build(BuildContext context) {
    final storeSearch = Provider.of<SearchStore>(context);
    return Container(
      color: color,
      child: Observer(builder: (_) {
        if (storeSearch.searchResultsAnimes != null) {
          switch (storeSearch.searchResultsAnimes.status) {
            case FutureStatus.pending:
              return Loading();
            case FutureStatus.rejected:
              return ErrorLoading(
                  msg: "Error to loading results, verify your connection",
                  refresh: () => _refresh(context));
            case FutureStatus.fulfilled:
              if (storeSearch.searchResultsAnimes.value.isEmpty) {
                return ErrorLoading(
                    msg: "Not found animes", refresh: () => _refresh(context));
              }
              return ListView.builder(
                  itemCount: storeSearch.searchResultsAnimes.value.length,
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed("/animeInfo",
                            arguments: [
                              storeSearch.searchResultsAnimes.value[index],
                              index,
                              actualBar,
                              true
                            ]);
                      },
                      child: AnimeSearchTile(
                          anime: storeSearch.searchResultsAnimes.value[index],
                          color: color),
                    );
                  });
            default:
              return ErrorLoading(
                  msg: "Error to load animes.",
                  refresh: () => _refresh(context));
          }
        } else {
          return Loading();
        }
      }),
    );
  }

  Future<void> _refresh(BuildContext context) async {
    final storeSearch = Provider.of<SearchStore>(context);
    final favStore = Provider.of<FavoriteAnimeStore>(context);
    storeSearch.search(query, actualBar, favStore: favStore);
  }
}
