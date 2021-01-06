import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:project1/model/Anime.dart';

class AnimeTile extends StatelessWidget {
  Anime anime;
  AnimeTile({this.anime});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Expanded(
            child: Image.network(
          anime.posterImage,
          fit: BoxFit.contain,
        )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: AutoSizeText('${anime.canonicalTitle}',
                  style: TextStyle(fontSize: 15),
                  minFontSize: 10,
                  maxLines: 1)),
        )
      ],
    ));
  }
}
