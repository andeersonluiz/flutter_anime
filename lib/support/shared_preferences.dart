import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs{
Future<SharedPreferences> prefs;
SharedPrefs(){
  prefs = SharedPreferences.getInstance();
}
}