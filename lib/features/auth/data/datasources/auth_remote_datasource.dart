import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmail(String email, String password);
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInAsGuest();
  Future<void> signOut();
  UserModel? getCurrentUser();
  Future<UserModel> updateUserProfile({
    String? username,
    String? avatarUrl,
    String? backgroundUrl,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
    required this.googleSignIn,
  });

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) throw const ServerException('User is null after sign in.');

      final doc = await firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        final newUser = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          username: user.email?.split('@').first ?? 'User',
        );
        await firestore.collection('users').doc(user.uid).set(newUser.toJson());
        return newUser;
      }
      return UserModel.fromJson(doc.data()!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Firebase Auth Error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) throw const ServerException('Google sign in cancelled.');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) throw const ServerException('User is null after sign in.');

      final doc = await firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        final newUser = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          username: user.displayName ?? 'User',
          avatarUrl: user.photoURL,
        );
        await firestore.collection('users').doc(user.uid).set(newUser.toJson());
        return newUser;
      }
      return UserModel.fromJson(doc.data()!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Firebase Auth Error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signInAsGuest() async {
    try {
      final userCredential = await firebaseAuth.signInAnonymously();
      final user = userCredential.user;
      if (user == null) throw const ServerException('User is null after sign in.');

      final newUser = UserModel(
        uid: user.uid,
        email: '',
        username: 'Guest',
        isAnonymous: true,
      );
      await firestore.collection('users').doc(user.uid).set(newUser.toJson());
      return newUser;
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Firebase Auth Error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
      await firebaseAuth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  UserModel? getCurrentUser() {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      username: user.displayName ?? 'User',
      isAnonymous: user.isAnonymous,
    );
  }

  @override
  Future<UserModel> updateUserProfile({
    String? username,
    String? avatarUrl,
    String? backgroundUrl,
  }) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) throw const ServerException('Not logged in');

      final docRef = firestore.collection('users').doc(user.uid);
      final doc = await docRef.get();
      if (!doc.exists) throw const ServerException('User document not found');

      final Map<String, dynamic> updates = {};
      if (username != null) updates['username'] = username;
      if (avatarUrl != null) updates['avatarUrl'] = avatarUrl;
      if (backgroundUrl != null) updates['backgroundUrl'] = backgroundUrl;

      await docRef.update(updates);

      final updatedDoc = await docRef.get();
      return UserModel.fromJson(updatedDoc.data()!);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
