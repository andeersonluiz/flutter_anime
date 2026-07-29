import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  bool getTheme();
  Future<void> saveTheme(bool isDark);
  String getLanguage();
  Future<void> saveLanguage(String code);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  bool getTheme() {
    return sharedPreferences.getBool('isDarkTheme') ?? false;
  }

  @override
  Future<void> saveTheme(bool isDark) async {
    await sharedPreferences.setBool('isDarkTheme', isDark);
  }

  @override
  String getLanguage() {
    return sharedPreferences.getString('languageCode') ?? 'en';
  }

  @override
  Future<void> saveLanguage(String code) async {
    await sharedPreferences.setString('languageCode', code);
  }
}
