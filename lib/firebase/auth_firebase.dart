import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:project1/firebase/cloudFirestore_firebase.dart';

class Auth {
  static FirebaseAuth auth;
  CloudFirestore cloud;

  Key key;
  String keyValue;
  final iv = IV.fromLength(16);
  Encrypter encrypter;
  Auth() {
    cloud = CloudFirestore();
    encrypter = Encrypter(AES(key));
    cloud.getHashKey().then((value) => key = Key.fromUtf8(value));
    if (auth == null) {
      auth = FirebaseAuth.instance;
    }
  }

  registerWithEmailAndPassword(String email, String password, String id) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      bool userExists = await cloud.verifyIfUserExists(id);
      if (!userExists) {
        return "";
      } else {
        auth.signOut();
        return "You have an account registred in that email.";
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          return translate("errors.account_exists_with_different_credential");
        case 'invalid-credential':
          return translate("errors.invalid_credential");
        case 'operation-not-allowed':
          return translate("errors.operation_not_allowed");
        case 'user-disabled':
          return translate("errors.user_disabled");
        case 'user-not-found':
          return translate("errors.user_not_found");
        case 'wrong-password':
          return translate("errors.wrong_password");
        case 'weak-password':
          return translate("errors.weak_password");
          break;
        case 'email-already-in-use':
          return translate("errors.email_already_in_use");
          break;
        case 'invalid-email':
          return translate("errors.invalid_email");
          break;

        default:
          return translate("errors.default_email");
      }
    }
  }

  registerWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await auth.signInWithCredential(credential);
      await _initEncrypt();
      bool userExists = await cloud.verifyIfUserExists(
          encrypter.encrypt(auth.currentUser.email, iv: iv).base64);
      if (!userExists) {
        return "";
      } else {
        auth.signOut();
        return "You have an account registred in that email.";
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          return translate("errors.account_exists_with_different_credential");
        case 'invalid-credential':
          return translate("errors.invalid_credential");
        case 'operation-not-allowed':
          return translate("errors.operation_not_allowed");
        case 'user-disabled':
          return translate("errors.user_disabled");
        case 'user-not-found':
          return translate("errors.user_not_found");
        case 'wrong-password':
          return translate("errors.wrong_password");
        default:
          return translate("errors.default_credential");
      }
    }
  }

  registerWithFacebook() async {
    try {
      cloud = new CloudFirestore();
      final AccessToken result = await FacebookAuth.instance.login();
      final FacebookAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.token);
      await auth.signInWithCredential(facebookAuthCredential);
      await _initEncrypt();
      bool userExists = await cloud.verifyIfUserExists(
          encrypter.encrypt(auth.currentUser.email, iv: iv).base64);
      if (!userExists) {
        return "";
      } else {
        auth.signOut();
        return "You have an account registred in that email.";
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          return translate("errors.account_exists_with_different_credential");
        case 'invalid-credential':
          return translate("errors.invalid_credential");
        case 'operation-not-allowed':
          return translate("errors.operation_not_allowed");
        case 'user-disabled':
          return translate("errors.user_disabled");
        case 'user-not-found':
          return translate("errors.user_not_found");
        case 'wrong-password':
          return translate("errors.wrong_password");
        default:
          return translate("errors.default_credential");
      }
    }
  }

  loginWithEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          return translate("errors.account_exists_with_different_credential");
        case 'invalid-credential':
          return translate("errors.invalid_credential");
        case 'operation-not-allowed':
          return translate("errors.operation_not_allowed");
        case 'user-disabled':
          return translate("errors.user_disabled");
        case 'user-not-found':
          return translate("errors.user_not_found");
        case 'wrong-password':
          return translate("errors.wrong_password");
        case 'weak-password':
          return translate("errors.weak_password");
          break;
        case 'email-already-in-use':
          return translate("errors.email_already_in_use");
          break;
        case 'invalid-email':
          return translate("errors.invalid_email");
          break;

        default:
          return translate("errors.default_email");
      }
    }
  }

  singInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await auth.signInWithCredential(credential);
      return "";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          return translate("errors.account_exists_with_different_credential");
        case 'invalid-credential':
          return translate("errors.invalid_credential");
        case 'operation-not-allowed':
          return translate("errors.operation_not_allowed");
        case 'user-disabled':
          return translate("errors.user_disabled");
        case 'user-not-found':
          return translate("errors.user_not_found");
        case 'wrong-password':
          return translate("errors.wrong_password");
        default:
          return translate("errors.default_credential");
      }
    }
  }

  singInWithFacebook() async {
    try {
      cloud = new CloudFirestore();
      final AccessToken result = await FacebookAuth.instance.login();
      final FacebookAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.token);
      await auth.signInWithCredential(facebookAuthCredential);
      return "";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          return translate("errors.account_exists_with_different_credential");
        case 'invalid-credential':
          return translate("errors.invalid_credential");
        case 'operation-not-allowed':
          return translate("errors.operation_not_allowed");
        case 'user-disabled':
          return translate("errors.user_disabled");
        case 'user-not-found':
          return translate("errors.user_not_found");
        case 'wrong-password':
          return translate("errors.wrong_password");
        default:
          return translate("errors.default_credential");
      }
    }
  }

  Future<void> signOut() {
    return auth.signOut();
  }

  User getUser() {
    return auth.currentUser;
  }

  _initEncrypt() async {
    keyValue ??= await cloud.getHashKey();
    key = Key.fromUtf8(keyValue);
    encrypter = Encrypter(AES(key));
  }
}
