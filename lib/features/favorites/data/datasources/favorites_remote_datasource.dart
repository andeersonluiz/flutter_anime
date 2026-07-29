import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<String>> getFavorites(String userId);
  Future<void> addFavorite(String userId, String animeId);
  Future<void> removeFavorite(String userId, String animeId);
  Future<bool> isFavorite(String userId, String animeId);
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final FirebaseFirestore firestore;

  FavoritesRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<String>> getFavorites(String userId) async {
    try {
      final snapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('favoriteAnimes')
          .get();
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> addFavorite(String userId, String animeId) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('favoriteAnimes')
          .doc(animeId)
          .set({'addedAt': FieldValue.serverTimestamp()});
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> removeFavorite(String userId, String animeId) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('favoriteAnimes')
          .doc(animeId)
          .delete();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> isFavorite(String userId, String animeId) async {
    try {
      final doc = await firestore
          .collection('users')
          .doc(userId)
          .collection('favoriteAnimes')
          .doc(animeId)
          .get();
      return doc.exists;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
