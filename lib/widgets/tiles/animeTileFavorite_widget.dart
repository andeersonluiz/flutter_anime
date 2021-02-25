import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:project1/model/anime_model.dart';
import 'package:project1/stores/favoriteAnime_store.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:project1/support/circle_painter.dart';
import 'package:project1/support/global_variables.dart' as globals;
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:project1/stores/anime_store.dart';

class AnimeTileFavorite extends StatelessWidget {
  final Anime anime;
  final index;
  AnimeTileFavorite({this.index, this.anime});
  @override
  Widget build(BuildContext context) {
    final firebaseStore = Provider.of<FirebaseStore>(context);
    final storeAnimes = Provider.of<AnimeStore>(context);
    final storeAnimesFavorites = Provider.of<FavoriteAnimeStore>(context);
    final themeData = Theme.of(context);

    final size = MediaQuery.of(context).size;
    final width = (size.width -
            ((globals.crossAxisCount - 1) * globals.crossAxisSpacing)) /
        globals.crossAxisCount;
    final height = width / globals.childAspectRatio;

    return Hero(
      tag: anime.id,
      child: Scaffold(
        backgroundColor: themeData.primaryColor,
        body: GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/animeInfoFavorite',
              arguments: [anime, index]),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              decoration:
                  BoxDecoration(color: themeData.primaryColor, boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: Offset(0, 3),
                )
              ]),
              child: Center(
                  child: Stack(
                children: [
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                          height: height * 0.7,
                          width: width,
                          child: FadeInImage.memoryNetwork(
                            image: anime.posterImage,
                            placeholder: kTransparentImage,
                            fit: BoxFit.cover,
                          ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: firebaseStore.isDarkTheme
                                    ? AssetImage(
                                        "assets/loading_white.gif",
                                      )
                                    : AssetImage(
                                        "assets/loading_black.gif",
                                      ),
                                fit: BoxFit.contain),
                            border: Border.all(
                                color: themeData.primaryColor, width: 2),
                          )),
                    ),
                  ),
                  Positioned(
                      child: Center(
                          child: Circle(
                              center: {"x": width / 2.12, "y": height / 1.4},
                              radius: 20))),
                  Positioned(
                    bottom: height * 0.14,
                    right: 0,
                    left: 8,
                    child: Container(
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: AutoSizeText('${index + 1}º',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1)),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: width,
                        height: height * 0.135,
                        decoration: BoxDecoration(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text('${anime.canonicalTitle}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: themeData.indicatorColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: height * 0.785,
                    left: width * 0.71,
                    child: Container(
                        width: width * 0.2,
                        height: width * 0.2,
                        decoration: BoxDecoration(
                          color: themeData.primaryColor,
                        ),
                        child: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          onPressed: () {
                            firebaseStore.setFavorite(anime, true);
                            storeAnimesFavorites.removeItem(anime);
                            storeAnimes.removeFavoriteByName(anime.id);
                          },
                        )),
                  ),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }
}
