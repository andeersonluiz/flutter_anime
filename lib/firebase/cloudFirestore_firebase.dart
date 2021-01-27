import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:project1/model/anime_model.dart';
import 'package:project1/model/user_model.dart';

class CloudFirestore {
  static FirebaseFirestore instance;
  Key key;
  String keyValue;
  Encrypter encrypter;

  final iv = IV.fromLength(16);
  CloudFirestore() {
    if (instance == null) {
      instance = FirebaseFirestore.instance;
    }
  }
  void addUser(Person user) async {
    await instance.collection("Users").doc(user.email).set(user.toJson());
  }

  Future<Person> changeNickname(Person user, String newNickname) async {
    user.nickname = newNickname;
    await instance.collection("Users").doc(user.email).update(user.toJson());
    return user;
  }

  Future<Person> loadUser(String email) async {
    DocumentSnapshot doc = await instance.collection("Users").doc(email).get();
    return Person.fromJson(doc.data());
  }

  verifyIfUserExists(String email) async {
    DocumentSnapshot doc = await instance.collection("Users").doc(email).get();
    if (doc.data() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<Person> changeAvatar(Person user, String path) async {
    user.avatar = path;
    await instance.collection("Users").doc(user.email).update(user.toJson());
    return user;
  }

  Future<Person> changeBackground(Person user, String path) async {
    user.background = path;
    await instance.collection("Users").doc(user.email).update(user.toJson());
    return user;
  }

  Future<Person> updateListAnimes(Person user, Anime anime, bool delete) async {
    !delete
        ? await instance
            .collection("Users")
            .doc(user.email)
            .collection("favoriteAnimes")
            .doc(anime.id)
            .set(anime.toJson())
        : await instance
            .collection("Users")
            .doc(user.email)
            .collection("favoriteAnimes")
            .doc(anime.id)
            .delete();
    return user;
  }

  Future<String> getHashKey() async {
    DocumentSnapshot doc =
        await instance.collection("Hashes").doc("KeySha1").get();
    return doc.data()['value'];
  }

  getFavoritesAnimesId(String email) async {
    if (email == null) {
      return [];
    }
    await _initEncrypt();
    QuerySnapshot query = await instance
        ?.collection("Users")
        ?.doc(encrypter.encrypt(email, iv: iv).base64)
        ?.collection("favoriteAnimes")
        ?.get();
    List<String> favorites = query.docs.map((value) => value.id).toList();
    return favorites;
  }

  getFavoritesAnimes(String email) async {
    await _initEncrypt();
    QuerySnapshot query = await instance
        .collection("Users")
        .doc(encrypter.encrypt(email, iv: iv).base64)
        .collection("favoriteAnimes")
        .orderBy("canonicalTitle")
        .get();
    var favorites = query.docs.map((value) {
      return value.data();
    }).toList();
    return favorites;
  }

  _initEncrypt() async {
    keyValue ??= await getHashKey();
    key = Key.fromUtf8(keyValue);
    encrypter = Encrypter(AES(key));
  }
}
