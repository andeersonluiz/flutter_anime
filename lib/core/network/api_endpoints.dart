/// All Kitsu API endpoints centralized.
///
/// Previously hardcoded as strings scattered across 7+ MobX stores.
class ApiEndpoints {
  ApiEndpoints._();

  static const String kitsuBase = 'https://kitsu.io/api/edge';

  // Anime
  static const String trendingAnime = '/trending/anime';
  static const String anime = '/anime';

  // Characters
  static const String characters = '/characters';

  // Categories
  static const String categories = '/categories';

  // Pagination defaults
  static const int defaultPageLimit = 10;
  static const int defaultCharacterPageLimit = 20;
  static const int defaultCategoryPageLimit = 20;

  // Query param helpers
  static String animeById(String id) => '/anime/$id';
  static String animeCharacters(String animeId) => '/anime/$animeId/relationships/characters';
  static String animeEpisodes(String animeId) => '/anime/$animeId/episodes';
}
