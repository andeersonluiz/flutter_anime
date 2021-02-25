import 'package:flutter/material.dart';
import 'package:project1/support/global_variables.dart' as globals;
import 'package:project1/widgets/tiles/animeTile_widget.dart';

class AnimeList extends StatelessWidget {
  final keyName;
  final scrollController;
  final animes;
  final loadedAllList;
  final actualBar;
  AnimeList(
      {this.keyName,
      this.scrollController,
      this.animes,
      this.loadedAllList,
      this.actualBar});
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return CustomScrollView(
      scrollDirection: Axis.vertical,
      key: PageStorageKey(keyName),
      controller: scrollController,
      slivers: <Widget>[
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: globals.mainAxisSpacing,
              crossAxisSpacing: globals.crossAxisSpacing,
              childAspectRatio: 0.6,
              crossAxisCount: globals.crossAxisCount),
          delegate: SliverChildBuilderDelegate(
              (ctx, index) => AnimeTile(
                  index: index, anime: animes[index], actualBar: actualBar),
              childCount: animes.length ?? 0),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (ctx, index) => Center(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: loadedAllList
                          ? Container()
                          : CircularProgressIndicator(
                              backgroundColor: themeData.indicatorColor,
                            ))),
              childCount: 1),
        ),
      ],
    );
  }
}
