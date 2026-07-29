import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class UpdateUserProfile {
  final AuthRepository repository;

  UpdateUserProfile(this.repository);

  Future<Either<Failure, AppUser>> call({
    String? username,
    String? avatarUrl,
    String? backgroundUrl,
  }) async {
    return await repository.updateUserProfile(
      username: username,
      avatarUrl: avatarUrl,
      backgroundUrl: backgroundUrl,
    );
  }
}
