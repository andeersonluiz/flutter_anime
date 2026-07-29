/// Base class for all failures in the application.
///
/// Uses sealed classes (Dart 3) for exhaustive pattern matching.
sealed class Failure {
  const Failure(this.message);
  final String message;
}

/// Failure originating from a remote server (HTTP errors, API errors).
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure originating from local cache operations.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Failure when no network connection is available.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

/// Failure from Firebase authentication operations.
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Failure from Firebase Firestore operations.
class FirestoreFailure extends Failure {
  const FirestoreFailure(super.message);
}

/// Unexpected failure — catch-all for unhandled exceptions.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred.']);
}
