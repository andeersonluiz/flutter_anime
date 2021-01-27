import 'package:flutter/material.dart';
import 'package:project1/widgets/tiles/animeTileFavorite_widget.dart';
import 'package:project1/support/global_variables.dart' as globals;

class AnimeListFavorite extends StatelessWidget {
  final animes;
  AnimeListFavorite({this.animes});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: [
          SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: globals.mainAxisSpacing,
                  crossAxisSpacing: globals.crossAxisSpacing,
                  childAspectRatio: 0.6,
                  crossAxisCount: globals.crossAxisCount),
              delegate: SliverChildBuilderDelegate(
                (ctx, index) => AnimeTileFavorite(
                  anime: animes[index],
                  index: index,
                ),
                childCount: animes.length,
              ))
        ],
      ),
    );
  }
}
