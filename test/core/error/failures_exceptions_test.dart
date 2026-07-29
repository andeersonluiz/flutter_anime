import 'package:animes_io/core/error/exceptions.dart';
import 'package:animes_io/core/error/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failures', () {
    test('ServerFailure stores message correctly', () {
      const failure = ServerFailure('Server is down');
      expect(failure.message, 'Server is down');
      expect(failure, isA<Failure>());
    });

    test('CacheFailure stores message correctly', () {
      const failure = CacheFailure('Cache miss');
      expect(failure.message, 'Cache miss');
      expect(failure, isA<Failure>());
    });

    test('NetworkFailure uses default message when no arg provided', () {
      const failure = NetworkFailure();
      expect(failure.message, 'No internet connection.');
    });

    test('NetworkFailure stores custom message', () {
      const failure = NetworkFailure('offline');
      expect(failure.message, 'offline');
    });

    test('AuthFailure stores message correctly', () {
      const failure = AuthFailure('Invalid credentials');
      expect(failure.message, 'Invalid credentials');
    });

    test('FirestoreFailure stores message correctly', () {
      const failure = FirestoreFailure('Document not found');
      expect(failure.message, 'Document not found');
    });

    test('UnexpectedFailure uses default message', () {
      const failure = UnexpectedFailure();
      expect(failure.message, 'An unexpected error occurred.');
    });

    test('UnexpectedFailure stores custom message', () {
      const failure = UnexpectedFailure('weird error');
      expect(failure.message, 'weird error');
    });
  });

  group('Exceptions', () {
    test('ServerException stores message and toString correctly', () {
      const e = ServerException('503 unavailable');
      expect(e.message, '503 unavailable');
      expect(e.toString(), 'ServerException: 503 unavailable');
    });

    test('CacheException stores message and toString correctly', () {
      const e = CacheException('read error');
      expect(e.message, 'read error');
      expect(e.toString(), 'CacheException: read error');
    });

    test('NetworkException uses default message', () {
      const e = NetworkException();
      expect(e.message, 'No internet connection.');
      expect(e.toString(), 'NetworkException: No internet connection.');
    });

    test('NetworkException stores custom message', () {
      const e = NetworkException('custom');
      expect(e.message, 'custom');
    });

    test('AuthException stores message and toString correctly', () {
      const e = AuthException('token expired');
      expect(e.message, 'token expired');
      expect(e.toString(), 'AuthException: token expired');
    });

    test('FirestoreException stores message and toString correctly', () {
      const e = FirestoreException('permission denied');
      expect(e.message, 'permission denied');
      expect(e.toString(), 'FirestoreException: permission denied');
    });
  });
}
