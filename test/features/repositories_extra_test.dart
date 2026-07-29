import 'package:animes_io/core/error/exceptions.dart';
import 'package:animes_io/core/error/failures.dart';
import 'package:animes_io/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:animes_io/features/auth/domain/entities/app_user.dart';
import 'package:animes_io/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth/auth_test.dart';
import 'favorites/favorites_test.dart';

void main() {
  group('AuthRepositoryImpl edge cases', () {
    late AuthRepositoryImpl repository;
    late MockAuthRemoteDataSource mockRemote;

    setUp(() {
      mockRemote = MockAuthRemoteDataSource();
      repository = AuthRepositoryImpl(mockRemote);
    });

    test('signInWithEmail handles generic non-ServerException error', () async {
      when(() => mockRemote.signInWithEmail('a@b.com', '123'))
          .thenThrow(Exception('generic error'));

      final result = await repository.signInWithEmail('a@b.com', '123');
      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f.message, contains('generic error')),
        (_) => fail('should be left'),
      );
    });

    test('signInWithGoogle handles generic exception', () async {
      when(() => mockRemote.signInWithGoogle())
          .thenThrow(Exception('google error'));

      final result = await repository.signInWithGoogle();
      expect(result.isLeft(), true);
    });

    test('signInAsGuest handles ServerException and generic Exception',
        () async {
      when(() => mockRemote.signInAsGuest())
          .thenThrow(const ServerException('guest fail'));

      final result1 = await repository.signInAsGuest();
      expect(result1.isLeft(), true);

      when(() => mockRemote.signInAsGuest())
          .thenThrow(Exception('guest generic'));

      final result2 = await repository.signInAsGuest();
      expect(result2.isLeft(), true);
    });

    test('getCurrentUser handles exception and returns null', () {
      when(() => mockRemote.getCurrentUser())
          .thenThrow(Exception('storage error'));

      final user = repository.getCurrentUser();
      expect(user, isNull);
    });
  });

  group('FavoritesRepositoryImpl edge cases', () {
    late FavoritesRepositoryImpl repository;
    late MockFavoritesRemoteDataSource mockRemote;

    setUp(() {
      mockRemote = MockFavoritesRemoteDataSource();
      repository = FavoritesRepositoryImpl(mockRemote);
    });

    test('isFavorite handles ServerException and generic Exception', () async {
      when(() => mockRemote.isFavorite('u1', 'a1'))
          .thenThrow(const ServerException('fav check fail'));

      final res1 = await repository.isFavorite('u1', 'a1');
      expect(res1.isLeft(), true);

      when(() => mockRemote.isFavorite('u1', 'a1'))
          .thenThrow(Exception('generic fav error'));

      final res2 = await repository.isFavorite('u1', 'a1');
      expect(res2.isLeft(), true);
    });
  });
}
