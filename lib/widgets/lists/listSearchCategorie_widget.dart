import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/widgets/errorLoading_widget.dart';
import 'package:project1/widgets/loading_widget.dart';
import 'package:project1/widgets/tiles/categorieSearchTile_widget.dart';
import 'package:provider/provider.dart';
import 'package:project1/stores/search_store.dart';
import 'package:project1/stores/firebase_store.dart';

class ListSearchCategorie extends StatelessWidget {
  final query;
  final actualBar;
  ListSearchCategorie({this.query, this.actualBar});
  @override
  Widget build(BuildContext context) {
    final storeSearch = Provider.of<SearchStore>(context);
    final themeData = Theme.of(context);

    return Container(
      color: themeData.primaryColor,
      child: Observer(builder: (_) {
        if (storeSearch.searchResultsCategories != null) {
          switch (storeSearch.searchResultsCategories.status) {
            case FutureStatus.pending:
              return Loading();
            case FutureStatus.rejected:
              return ErrorLoading(
                  msg: "Error to loading results, verify your connection",
                  refresh: () => _refresh(context));

            case FutureStatus.fulfilled:
              if (storeSearch.searchResultsCategories.value.isEmpty) {
                return ErrorLoading(
                    msg: "Not found categories",
                    refresh: () => _refresh(context));
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
                        storeSearch.searchResultsCategories.value[index],
                      ),
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
    final firebaseStore = Provider.of<FirebaseStore>(context);

    return storeSearch.search(query, actualBar, firebaseStore.isLogged);
  }
}
