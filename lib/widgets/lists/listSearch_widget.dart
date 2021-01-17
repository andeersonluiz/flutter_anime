import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/widgets/errorLoading_widget.dart';
import 'package:project1/widgets/loading_widget.dart';
import 'package:project1/widgets/tiles/animeSearchTile_widget.dart';

class ListSearch extends StatelessWidget {
  final storeSearch;
  ListSearch({this.storeSearch});
//**consertar erros da parte amanha(consertar FutureStatus.rejected) */
  @override
  Widget build(BuildContext context) {
     return Observer(builder: (_) {
      if (storeSearch.searchResults != null) {
        switch (storeSearch.searchResults.status) {
          case FutureStatus.pending:
            return Loading();
          case FutureStatus.rejected:
            return Container(
              child: Text('error'),
            );
          case FutureStatus.fulfilled:
            if (storeSearch.searchResults.value.isEmpty) {
              return ErrorLoading(msg: "Not found animes", refresh: _refresh);
            }
            return ListView.builder(
                itemCount: storeSearch.searchResults.value.length,
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushNamed("/animeInfo",arguments:storeSearch.searchResults.value[index]);
                    },
                    child: AnimeSearchTile(
                        anime: storeSearch.searchResults.value[index]),
                  );
                });
          default:
            return ErrorLoading(msg: "Error to load animes.", refresh: _refresh);

              
        }
      } else {
        return Loading();
      }
    });
  }
  Future<void> _refresh() {
    return Future.delayed(Duration(seconds: 1));
  }
}