import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser>> signInWithEmail(
      String email, String password);
  Future<Either<Failure, AppUser>> signInWithGoogle();
  Future<Either<Failure, AppUser>> signInAsGuest();
  Future<Either<Failure, Unit>> signOut();
  AppUser? getCurrentUser();
  Future<Either<Failure, AppUser>> updateUserProfile({
    String? username,
    String? avatarUrl,
    String? backgroundUrl,
  });
}
