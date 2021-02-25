import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:project1/model/anime_model.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:project1/support/circle_painter.dart';
import 'package:project1/support/global_variables.dart' as globals;
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:project1/stores/anime_store.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:project1/stores/search_store.dart';
import 'package:project1/stores/animeFilter_store.dart';

class AnimeTile extends StatelessWidget {
  final Anime anime;
  final index;
  final actualBar;
  AnimeTile({this.index, this.anime, this.actualBar});
  @override
  Widget build(BuildContext context) {
    final firebaseStore = Provider.of<FirebaseStore>(context);
    final storeAnimes = Provider.of<AnimeStore>(context);
    final storeSearch = Provider.of<SearchStore>(context);
    final storeAnimesCategories = Provider.of<AnimeFilterStore>(context);
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
          onTap: () => Navigator.pushNamed(context, '/animeInfo',
              arguments: [anime, index, actualBar]),
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
                    bottom: 48,
                    right: 0,
                    left: 0,
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
                  Observer(builder: (_) {
                    return Positioned(
                      bottom: height * 0.78,
                      left: width * 0.75,
                      child: Container(
                          width: width * 0.2,
                          height: width * 0.2,
                          decoration: BoxDecoration(
                            color: themeData.primaryColor,
                          ),
                          child: actualBar == globals.stringAnimesPopular
                              ? Center(
                                  child: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: Icon(
                                    storeAnimes.favoriteListPopular[index][1]
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.yellow,
                                  ),
                                  onPressed: () async {
                                    if (firebaseStore.isLogged) {
                                      await firebaseStore.setFavorite(
                                          anime,
                                          storeAnimes.favoriteListPopular[index]
                                              [1]);
                                      storeAnimes.setfavoriteListPopular(index);
                                      storeSearch.changeStatusById(anime);
                                    } else {
                                      return Toast.show(
                                          translate(
                                              'anime_info.error_favorite'),
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM);
                                    }
                                  },
                                ))
                              : actualBar == globals.stringAnimesHighest
                                  ? Center(
                                      child: IconButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      icon: Icon(
                                        storeAnimes.favoriteListHighest[index]
                                                [1]
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.yellow,
                                      ),
                                      onPressed: () {
                                        if (firebaseStore.isLogged) {
                                          firebaseStore.setFavorite(
                                              anime,
                                              storeAnimes.favoriteListHighest[
                                                  index][1]);
                                          storeAnimes
                                              .setfavoriteListHighest(index);
                                          storeSearch.changeStatusById(anime);
                                        } else {
                                          return Toast.show(
                                              translate(
                                                  'anime_info.error_favorite'),
                                              context,
                                              duration: Toast.LENGTH_LONG,
                                              gravity: Toast.BOTTOM);
                                        }
                                      },
                                    ))
                                  : actualBar == globals.stringAnimesAiring
                                      ? Center(
                                          child: IconButton(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            icon: Icon(
                                              storeAnimes.favoriteListAiring[
                                                      index][1]
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.yellow,
                                            ),
                                            onPressed: () {
                                              if (firebaseStore.isLogged) {
                                                firebaseStore.setFavorite(
                                                    anime,
                                                    storeAnimes
                                                            .favoriteListAiring[
                                                        index][1]);
                                                storeAnimes
                                                    .setfavoriteListAiring(
                                                        index);
                                                storeSearch
                                                    .changeStatusById(anime);
                                              } else {
                                                return Toast.show(
                                                    translate(
                                                        'anime_info.error_favorite'),
                                                    context,
                                                    duration: Toast.LENGTH_LONG,
                                                    gravity: Toast.BOTTOM);
                                              }
                                            },
                                          ),
                                        )
                                      : actualBar ==
                                              globals.stringAnimesUpcoming
                                          ? Center(
                                              child: IconButton(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                icon: Icon(
                                                  storeAnimes.favoriteListUpComing[
                                                          index][1]
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  color: Colors.yellow,
                                                ),
                                                onPressed: () {
                                                  if (firebaseStore.isLogged) {
                                                    firebaseStore.setFavorite(
                                                        anime,
                                                        storeAnimes
                                                                .favoriteListUpComing[
                                                            index][1]);
                                                    storeAnimes
                                                        .setfavoriteListUpComing(
                                                            index);
                                                    storeSearch
                                                        .changeStatusById(
                                                            anime);
                                                  } else {
                                                    return Toast.show(
                                                        translate(
                                                            'anime_info.error_favorite'),
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_LONG,
                                                        gravity: Toast.BOTTOM);
                                                  }
                                                },
                                              ),
                                            )
                                          : Center(
                                              child: IconButton(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                icon: Icon(
                                                  firebaseStore.isLogged
                                                      ? (storeAnimesCategories
                                                                  .favCategorie[
                                                              index][1]
                                                          ? Icons.star
                                                          : Icons.star_border)
                                                      : Icons.star_border,
                                                  color: Colors.yellow,
                                                ),
                                                onPressed: () {
                                                  if (firebaseStore.isLogged) {
                                                    firebaseStore.setFavorite(
                                                        anime,
                                                        storeAnimesCategories
                                                                .favCategorie[
                                                            index][1]);
                                                    if (storeAnimesCategories
                                                            .favCategorie[index]
                                                        [1]) {
                                                      storeAnimes
                                                          .removeFavoriteByName(
                                                              anime.id);
                                                    } else {
                                                      storeAnimes
                                                          .addFavoriteByName(
                                                              anime.id);
                                                    }
                                                    storeSearch
                                                        .changeStatusById(
                                                            anime);
                                                    storeAnimesCategories
                                                        .changeStatusFav(index);
                                                  } else {
                                                    return Toast.show(
                                                        translate(
                                                            'anime_info.error_favorite'),
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_LONG,
                                                        gravity: Toast.BOTTOM);
                                                  }
                                                },
                                              ),
                                            )),
                    );
                  }),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }
}
