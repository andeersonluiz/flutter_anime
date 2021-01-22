import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/widgets/errorLoading_widget.dart';
import 'package:project1/widgets/loading_widget.dart';
import 'package:project1/widgets/tiles/categorieSearchTile_widget.dart';

class ListSearchCategorie extends StatelessWidget {
  final storeSearch;
  final query;
  final actualBar;
  final color;
  ListSearchCategorie({this.storeSearch, this.query, this.actualBar,this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Observer(builder: (_) {
        if (storeSearch.searchResultsCategories != null) {
          switch (storeSearch.searchResultsCategories.status) {
            case FutureStatus.pending:
              return Loading();
            case FutureStatus.rejected:
              return ErrorLoading(
                  msg: "Error to loading results, verify your connection",
                  refresh: _refresh);

            case FutureStatus.fulfilled:
              if (storeSearch.searchResultsCategories.value.isEmpty) {
                return ErrorLoading(
                    msg: "Not found categories", refresh: _refresh);
              }
              return ListView.builder(
                  itemCount: storeSearch.searchResultsCategories.value.length,
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed("/animeListByCategorie",
                            arguments: storeSearch
                                .searchResultsCategories.value[index].name);
                      },
                      child: CategorieSearchTile(
                          categorie:
                              storeSearch.searchResultsCategories.value[index],color:color),
                    );
                  });
            default:
              return ErrorLoading(
                  msg: "Error to load animes.", refresh: _refresh);
          }
        } else {
          return Loading();
        }
      }),
    );
  }

  Future<void> _refresh() async {
    return storeSearch.search(query, actualBar);
  }
}
