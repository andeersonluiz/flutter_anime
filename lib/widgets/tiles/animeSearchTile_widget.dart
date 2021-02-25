import 'package:flutter/material.dart';
import 'package:project1/model/anime_model.dart';

class AnimeSearchTile extends StatelessWidget {
  final Anime anime;
  final color;
  AnimeSearchTile({this.anime, this.color});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final themeData = Theme.of(context);

    return Card(
      color: color,
      elevation: 5,
      shadowColor: themeData.indicatorColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: Image.network(
                anime.posterImage,
                height: height * 0.2,
                fit: BoxFit.fill,
              )),
          Expanded(
            flex: 7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Text(
                  anime.canonicalTitle,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: themeData.indicatorColor),
                  textAlign: TextAlign.center,
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
