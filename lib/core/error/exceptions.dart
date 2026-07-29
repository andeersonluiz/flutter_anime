/// Exception thrown when the remote server returns an error.
class ServerException implements Exception {
  const ServerException(this.message);
  final String message;

  @override
  String toString() => 'ServerException: $message';
}

/// Exception thrown when cache read/write fails.
class CacheException implements Exception {
  const CacheException(this.message);
  final String message;

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when there is no network connection.
class NetworkException implements Exception {
  const NetworkException([this.message = 'No internet connection.']);
  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when a Firebase Auth operation fails.
class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => 'AuthException: $message';
}

/// Exception thrown when a Firestore operation fails.
class FirestoreException implements Exception {
  const FirestoreException(this.message);
  final String message;

  @override
  String toString() => 'FirestoreException: $message';
}
