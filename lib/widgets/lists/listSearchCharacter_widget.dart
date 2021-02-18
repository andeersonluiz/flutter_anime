import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/widgets/errorLoading_widget.dart';
import 'package:project1/widgets/loading_widget.dart';
import 'package:project1/widgets/tiles/characterSearchTile_widget.dart';
import 'package:provider/provider.dart';
import 'package:project1/stores/search_store.dart';

class ListSearchCharacter extends StatelessWidget {
  final query;
  final actualBar;
  final color;
  ListSearchCharacter({this.query, this.actualBar, this.color});
  @override
  Widget build(BuildContext context) {
    final storeSearch = Provider.of<SearchStore>(context);
    return Container(
      color: color,
      child: Observer(builder: (_) {
        if (storeSearch.searchResultsCharacters != null) {
          switch (storeSearch.searchResultsCharacters.status) {
            case FutureStatus.pending:
              return Loading();
            case FutureStatus.rejected:
              return ErrorLoading(
                  msg: "Error to loading results, verify your connection",
                  refresh: () => _refresh(context));

            case FutureStatus.fulfilled:
              if (storeSearch.searchResultsCharacters.value.isEmpty) {
                return ErrorLoading(
                    msg: "Not found character",
                    refresh: () => _refresh(context));
              }
              return ListView.builder(
                  itemCount: storeSearch.searchResultsCharacters.value.length,
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed("/characterInfo",
                            arguments: storeSearch
                                .searchResultsCharacters.value[index]);
                      },
                      child: CharacterSearchTile(
                          character:
                              storeSearch.searchResultsCharacters.value[index],
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
    return storeSearch.search(query, actualBar);
  }
}
