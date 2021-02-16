import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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

    final size = MediaQuery.of(context).size;
    final width = (size.width -
            ((globals.crossAxisCount - 1) * globals.crossAxisSpacing)) /
        globals.crossAxisCount;
    final height = width / globals.childAspectRatio;

    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/animeInfo', arguments: [anime, index]),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
              color: firebaseStore.isDarkTheme ? Colors.black : Colors.white,
              boxShadow: [
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
                              image: AssetImage("assets/loading.gif"),
                              fit: BoxFit.fill),
                          border: Border.all(
                              color: firebaseStore.isDarkTheme
                                  ? Colors.black
                                  : Colors.white,
                              width: 2),
                        )
                  ),
                ),
              ),
              Positioned(
                  child: Center(
                      child: Circle(
                          center: {"x": width / 2.12, "y": height / 1.4},
                          radius: 20))),
              Positioned(
                bottom: height * 0.1,
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
                                color: firebaseStore.isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2)),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: height * 0.77,
                left: width * 0.735,
                child: Container(
                    width: width * 0.2,
                    height: width * 0.2,
                    decoration: BoxDecoration(
                      color: firebaseStore.isDarkTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                    child:  IconButton(
                        icon: Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        onPressed: () {
                          firebaseStore.setFavorite(anime);
                          storeAnimesFavorites.removeItem(anime);
                          storeAnimes.removeFavoriteByName(anime.id);
                        },
                      
                    )),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
