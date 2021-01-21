import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:project1/firebase/cloudFirestore_firebase.dart';

class Auth {
  static FirebaseAuth auth;
  CloudFirestore cloud;

  final key = Key.fromUtf8("eu nao sei qual key escolher ent");
  final iv = IV.fromLength(16);
  Encrypter encrypter;
  Auth() {
    cloud = CloudFirestore();
    encrypter = Encrypter(AES(key));

    if (auth == null) {
      auth = FirebaseAuth.instance;
      //auth.signOut();
    }
    auth.authStateChanges().listen(_listener);
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
        case 'weak-password':
          return "Password too weak";
          break;
        case 'email-already-in-use':
          return "Email already in use.";
          break;
        case 'invalid-email':
          return "Email invalid";
          break;
        default:
          return "Problems in database, try again.";
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
          return "The account already exists.";
        case 'invalid-credential':
          return "Credential invalid.";
        case 'operation-not-allowed':
          return "Method not enabled.";
        case 'user-disabled':
          return "The user is disabled.";
        case 'user-not-found':
          return "User not found.";
        case 'wrong-password':
          return "Wrong password.";
        default:
          return "Error to login with google, try again later";
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
          return "The account already exists.";
        case 'invalid-credential':
          return "Credential invalid.";
        case 'operation-not-allowed':
          return "Method not enabled.";
        case 'user-disabled':
          return "The user is disabled.";
        case 'user-not-found':
          return "User not found.";
        case 'wrong-password':
          return "Wrong password.";
        default:
          return "Error to login with facebbok, try again later";
      }
    }
  }

  loginWithEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          return "Password too weak";
          break;
        case 'email-already-in-use':
          return "Email already in use.";
          break;
        case 'invalid-email':
          return "Email invalid";
          break;
        default:
          return "Problems in database, try again.";
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
          return "The account already exists.";
        case 'invalid-credential':
          return "Credential invalid.";
        case 'operation-not-allowed':
          return "Method not enabled.";
        case 'user-disabled':
          return "The user is disabled.";
        case 'user-not-found':
          return "User not found.";
        case 'wrong-password':
          return "Wrong password.";
        default:
          return "Error to login with google, try again later";
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
          return "The account already exists.";
        case 'invalid-credential':
          return "Credential invalid.";
        case 'operation-not-allowed':
          return "Method not enabled.";
        case 'user-disabled':
          return "The user is disabled.";
        case 'user-not-found':
          return "User not found.";
        case 'wrong-password':
          return "Wrong password.";
        default:
          return "Error to login with facebook, try again later";
      }
    }
  }

  _listener(User user) {
    if (user == null) {
      print("not logged");
    } else {
      print("logged");
    }
  }

  Future<void> signOut() {
    return auth.signOut();
  }

  User getUser() {
    return auth.currentUser;
  }
}
