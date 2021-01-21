import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/widgets/errorLoading_widget.dart';
import 'package:project1/widgets/loading_widget.dart';
import 'package:project1/widgets/tiles/characterSearchTile_widget.dart';

class ListSearchCharacter extends StatelessWidget {
  final storeSearch;
  final query;
  final actualBar;
  ListSearchCharacter({this.storeSearch, this.query, this.actualBar});
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      if (storeSearch.searchResultsCharacters != null) {
        switch (storeSearch.searchResultsCharacters.status) {
          case FutureStatus.pending:
            return Loading();
          case FutureStatus.rejected:
            return ErrorLoading(
                msg: "Error to loading results, verify your connection",
                refresh: _refresh);

          case FutureStatus.fulfilled:
            if (storeSearch.searchResultsCharacters.value.isEmpty) {
              return ErrorLoading(
                  msg: "Not found character", refresh: _refresh);
            }
            return ListView.builder(
                itemCount: storeSearch.searchResultsCharacters.value.length,
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed("/characterInfo",
                          arguments:
                              storeSearch.searchResultsCharacters.value[index]);
                    },
                    child: CharacterSearchTile(
                        character:
                            storeSearch.searchResultsCharacters.value[index]),
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
