import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/model/user_model.dart';

class CloudFirestore {
  static FirebaseFirestore instance;

  CloudFirestore() {
    if (instance == null) {
      instance = FirebaseFirestore.instance;
    }
  }

  void addUser(Person user) async {
    await instance.collection("Users").doc(user.email).set(user.toJson());
  }

  void changeNickname(Person user, String newNickname) async {
    user.nickname = newNickname;
    await instance.collection("Users").doc(user.email).update(user.toJson());
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
}
