import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class SignInAsGuest {
  final AuthRepository repository;

  SignInAsGuest(this.repository);

  Future<Either<Failure, AppUser>> call() async {
    return await repository.signInAsGuest();
  }
}
