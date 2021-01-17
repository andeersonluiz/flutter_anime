

import 'package:flutter/material.dart';
import 'package:project1/model/anime_model.dart';

class AnimeSearchTile extends StatelessWidget {
  final Anime anime;
  AnimeSearchTile({this.anime});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(flex:3,child: Image.network(anime.posterImage,height: height*0.2,fit: BoxFit.fill,)),
          Expanded(
            flex:7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text(anime.canonicalTitle,style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),textAlign: TextAlign.center,)),
              ],
            ),
          )
        ],
      ),
    );
  }
}