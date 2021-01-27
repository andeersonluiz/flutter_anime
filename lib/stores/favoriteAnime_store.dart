import 'package:mobx/mobx.dart';
import 'package:project1/firebase/auth_firebase.dart';
import 'package:project1/firebase/cloudFirestore_firebase.dart';
import 'package:project1/model/anime_model.dart';
part 'favoriteAnime_store.g.dart';

class FavoriteAnimeStore = _FavoriteAnimeStoreBase with _$FavoriteAnimeStore;

abstract class _FavoriteAnimeStoreBase with Store {
  @observable
  ObservableFuture<List<Anime>> favoriteAnimes;

  CloudFirestore cloud;
  Auth auth;

  bool lockLoad = false;
  bool loadedAllList = false;
  _FavoriteAnimeStoreBase() {
    cloud = CloudFirestore();
    auth = Auth();
  }

  @action
  getFavoriteAnimes() async {
    this.favoriteAnimes = ObservableFuture(_decode()).then((value) {
      return value;
    });
  }

  _decode() async {
    String email = auth?.getUser()?.email;
    List<dynamic> favorites = await cloud.getFavoritesAnimes(email);

    return favorites.map((json) => Anime.fromJsonFirebase(json)).toList();
  }

  removeItem(Anime anime) {
    List<Anime> listAnime = favoriteAnimes.value;
    listAnime.remove(anime);
    this.favoriteAnimes = ObservableFuture.value(listAnime);
  }
}
