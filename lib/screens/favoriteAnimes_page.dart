import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/stores/favoriteAnime_store.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:project1/widgets/drawerSideBar_widget.dart';
import 'package:project1/widgets/errorLoading_widget.dart';
import 'package:project1/widgets/lists/listAnimeFavorite_widget.dart';
import 'package:provider/provider.dart';
import 'package:project1/widgets/loading_widget.dart';
import 'package:flutter_translate/flutter_translate.dart';

class AnimeFavoritesPage extends StatefulWidget {
  @override
  _AnimeFavoritesPageState createState() => _AnimeFavoritesPageState();
}

class _AnimeFavoritesPageState extends State<AnimeFavoritesPage> {
  FavoriteAnimeStore storeAnimesFavorites;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    storeAnimesFavorites = Provider.of<FavoriteAnimeStore>(context);
    storeAnimesFavorites.getFavoriteAnimes();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseStore = Provider.of<FirebaseStore>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor:
            firebaseStore.isDarkTheme ? Colors.black : Colors.white,
        drawer: DrawerSideBar(),
        appBar: AppBar(
          centerTitle: true,
          title: SizedBox(
              width: width * 0.76,
              height: height * 0.76,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Image.asset(
                    firebaseStore.isDarkTheme
                        ? "assets/logo_white.png"
                        : "assets/logo_black.png",
                    fit: BoxFit.scaleDown),
              )),
        ),
        body: Observer(builder: (_) {
          storeAnimesFavorites.favoriteAnimes ??
              storeAnimesFavorites.getFavoriteAnimes();
          switch (storeAnimesFavorites.favoriteAnimes.status) {
            case FutureStatus.pending:
              return Loading();
            case FutureStatus.rejected:
              return ErrorLoading(
                  msg: translate('errors.error_load_page_favorite'),
                  refresh: _refresh(storeAnimesFavorites));
            case FutureStatus.fulfilled:
              return AnimeListFavorite(
                animes: storeAnimesFavorites.favoriteAnimes.value,
              );
            default:
              return ErrorLoading(
                  msg: translate('errors.error_default'),
                  refresh: _refresh(storeAnimesFavorites));
          }
        }));
  }

  Future<void> _refresh(FavoriteAnimeStore ref) async {
    return ref.getFavoriteAnimes();
  }
}
