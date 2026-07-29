import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/settings_repository.dart';

class ToggleTheme {
  final SettingsRepository repository;

  ToggleTheme(this.repository);

  Future<Either<Failure, Unit>> call(bool isDark) async {
    return await repository.saveTheme(isDark);
  }
}
