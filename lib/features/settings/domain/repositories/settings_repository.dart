import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class SettingsRepository {
  Either<Failure, bool> getTheme();
  Future<Either<Failure, Unit>> saveTheme(bool isDark);
  Either<Failure, String> getLanguage();
  Future<Either<Failure, Unit>> saveLanguage(String code);
}
