import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/firebase/auth_firebase.dart';
import 'package:project1/firebase/cloudFirestore_firebase.dart';
import 'package:project1/model/anime_model.dart';
import 'package:project1/model/categorie_model.dart';
import 'package:project1/model/user_model.dart';

part 'firebase_store.g.dart';

class FirebaseStore = _FirebaseStoreBase with _$FirebaseStore;

abstract class _FirebaseStoreBase with Store {
  @observable
  bool isLogged = false;

  @observable
  String errorMsg = "";

  @observable
  Person user;
  
  @observable
  bool isDarkTheme=false;

  Auth auth;
  CloudFirestore cloud;
  Encrypter encrypter;
  final key = Key.fromUtf8("eu nao sei qual key escolher ent");
  final iv = IV.fromLength(16);


  _FirebaseStoreBase() {
    auth = Auth();
    cloud = CloudFirestore();
    encrypter = Encrypter(AES(key));
  }

  @computed
  set setLogged(bool value) => isLogged = value;

  @action
  changeLogged(bool value) {
    return this.isLogged = value;
  }

  @action
  registerWithEmailAndPassword(
      String email, String password, String nickname) async {
    String encryptedPassword = encrypter.encrypt(password, iv: iv).base64;
    String encryptedEmail = encrypter.encrypt(email, iv: iv).base64;

    String result = await auth.registerWithEmailAndPassword(
        email, password, encryptedEmail);
    if (result == "") {
      User currentUser = auth.getUser();
      this.user = new Person(
          id: currentUser.uid,
          email: encryptedEmail,
          password: encryptedPassword,
          nickname: nickname,
          avatar:"assets/avatars/default.jpg",
          background: "assets/no-thumbnail.jpg",
          favoritesAnimes: List<Anime>(),
          favoritesCategories: List<Categorie>());
      cloud.addUser(user);
      this.isLogged = true;
      return true;
    } else {
      this.isLogged = false;
      this.errorMsg = result;
      return false;
    }
  }

  registerWithCredentials(String name) async {
    String result;
    switch (name) {
      case "Google":
        result = await auth.registerWithGoogle();
        if (result == "") {
          User currentUser = auth.getUser();
          this.user = new Person(
              id: currentUser.uid,
              email: encrypter.encrypt(currentUser.email, iv: iv).base64,
              password: "",
              nickname: "",
              avatar:"assets/avatars/default.jpg",
              background: "assets/no-thumbnail.jpg",
              favoritesAnimes: List<Anime>(),
              favoritesCategories: List<Categorie>());
          cloud.addUser(user);
          this.isLogged = true;
          return true;
        } else {
          this.isLogged = false;
          this.errorMsg = result;
          return false;
        }
        break;
      case "Facebook":
        result = await auth.registerWithFacebook();
        if (result == "") {
          User currentUser = auth.getUser();
          this.user = new Person(
              id: currentUser.uid,
              email: encrypter.encrypt(currentUser.email, iv: iv).base64,
              password: "",
              nickname: "",
              avatar:"assets/avatars/default.jpg",
              background: "assets/no-thumbnail.jpg",
              favoritesAnimes: List<Anime>(),
              favoritesCategories: List<Categorie>());
          cloud.addUser(user);
          this.isLogged = true;
          return true;
        } else {
          this.isLogged = false;
          this.errorMsg = result;
          return false;
        }
        break;
      default:
        return null;
    }
  }

  @action
  loginWithEmailAndPassword(String email, String password) async {
    String msg = "";
    msg = await auth.loginWithEmailAndPassword(email, password);
    if (msg == "") {
      user = await loadUser();
      this.isLogged = true;
    } else {
      this.isLogged = false;
      errorMsg = msg;
    }
  }

  loginWithCredentials(String name) async {
    String result;
    switch (name) {
      case "Google":
        result = await auth.singInWithGoogle();
        if (result == "") {
          user = await loadUser();
          this.isLogged = true;
          return true;
        } else {
          this.isLogged = false;
          this.errorMsg = result;
          return false;
        }
        break;
      case "Facebook":
        result = await auth.singInWithFacebook();
        if (result == "") {
          user = await loadUser();
          this.isLogged = true;
          return true;
        } else {
          this.isLogged = false;
          this.errorMsg = result;
          return false;
        }
        break;
      default:
        return null;
    }
  }

  @action
  Future<Person> loadUser() async {
    return await cloud
        .loadUser(encrypter.encrypt(auth.getUser().email, iv: iv).base64);
  }

  getUser() => auth.getUser();

  @action
  signOut() {
    auth = Auth();
    auth.signOut();
    this.isLogged = false;
  }

  @action
  setAvatar(String path) async {
    user.avatar="assets/loading.gif";
    this.user = user;
    await Future.delayed(Duration(seconds: 1));
    user = await cloud.changeAvatar(this.user, path);
  }

  @action
  setBackground(String path) async {
    user.background="assets/loading.gif";
    this.user = user;
    await Future.delayed(Duration(seconds: 1));
    user = await cloud.changeBackground(this.user, path);
  }

  @action
  setNickname(String nickname) async {
    user = await cloud.changeNickname(this.user, nickname);
  }


}
