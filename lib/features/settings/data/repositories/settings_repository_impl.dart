import 'package:animes_io/core/error/failures.dart';
import 'package:animes_io/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:animes_io/features/settings/domain/repositories/settings_repository.dart';
import 'package:dartz/dartz.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);

  @override
  Either<Failure, bool> getTheme() {
    try {
      final isDark = localDataSource.getTheme();
      return Right(isDark);
    } on Exception catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveTheme(bool isDark) async {
    try {
      await localDataSource.saveTheme(isDark);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Either<Failure, String> getLanguage() {
    try {
      final lang = localDataSource.getLanguage();
      return Right(lang);
    } on Exception catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveLanguage(String code) async {
    try {
      await localDataSource.saveLanguage(code);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Either<Failure, bool> getAutoTranslate() {
    try {
      final autoTranslate = localDataSource.getAutoTranslate();
      return Right(autoTranslate);
    } on Exception catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveAutoTranslate(bool autoTranslate) async {
    try {
      await localDataSource.saveAutoTranslate(autoTranslate);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
