import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPreferences prefs;

  setPersistTheme(bool value) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isThemeDark", value);
  }

  getPersistTheme() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isThemeDark");
  }

  persistLanguage(String code) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString("language", code);
  }

  getPersistLanguage() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString("language");
  }
}
