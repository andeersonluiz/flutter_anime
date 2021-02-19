import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/firebase/auth_firebase.dart';
import 'package:project1/firebase/cloudFirestore_firebase.dart';
import 'package:project1/model/anime_model.dart';
part 'favoriteAnime_store.g.dart';

class FavoriteAnimeStore = _FavoriteAnimeStoreBase with _$FavoriteAnimeStore;

abstract class _FavoriteAnimeStoreBase with Store {
  @observable
  ObservableFuture<List<Anime>> favoriteAnimes;

  @observable
  ObservableList<dynamic> favoriteList;

  int lastIndex;

  @observable
  bool localFavorite;
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
    if (FirebaseAuth.instance.currentUser == null) {
      return this.favoriteAnimes = ObservableFuture.value([]);
    }
    this.favoriteAnimes = ObservableFuture(_decode()).then((value) async {
      favoriteList = ObservableList.of(List.filled(0, ["", false]));
      for (int i = 0; i < value.length; i++) {
        favoriteList.add([value[i].id, true]);
      }
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
    lastIndex = listAnime.indexOf(anime);
    listAnime.remove(anime);
    this.favoriteAnimes = ObservableFuture.value(listAnime);
  }

  addItem(Anime anime) {
    List<Anime> listAnime = favoriteAnimes.value;
    listAnime.insert(lastIndex, anime);
    favoriteList.insert(lastIndex, [anime.id, true]);
    this.favoriteAnimes = ObservableFuture.value(listAnime);
  }

  @action
  changeFavorite(int index, Anime anime) {
    this.favoriteList[index] = [
      favoriteList[index][0],
      !favoriteList[index][1]
    ];

    if (favoriteList[index][1]) {
      addItem(anime);
    } else {
      removeItem(anime);
    }
  }
}
