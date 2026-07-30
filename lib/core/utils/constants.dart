/// Application-wide constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'Animes IO';

  // API
  static const int paginationLimit = 10;

  // Animation
  static const int pageTransitionMs = 300;

  // SharedPreferences keys
  static const String themePrefKey = 'isThemeDark';
  static const String languagePrefKey = 'language';

  // Default values
  static const String defaultLanguage = 'en';
  static const String defaultAvatarAsset = 'assets/avatars/default.jpg';
  static const String defaultLoadingAsset = 'assets/loading.gif';
  static const String defaultNoImageUrl = 'https://i.imgur.com/DIhR3Po.jpg';
  static const String noSynopsis = 'No synopsis available.';
}
