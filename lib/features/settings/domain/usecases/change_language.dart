import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/settings_repository.dart';

class ChangeLanguage {
  final SettingsRepository repository;

  ChangeLanguage(this.repository);

  Future<Either<Failure, Unit>> call(String code) async {
    return await repository.saveLanguage(code);
  }
}
