import 'dart:convert';
import 'package:hive/hive.dart';
import '../../../../core/error/exceptions.dart';
import '../models/anime_model.dart';

abstract class AnimeLocalDataSource {
  Future<void> cacheAnimes(String key, List<AnimeModel> animes);
  Future<List<AnimeModel>> getCachedAnimes(String key);
  Future<void> clearCache();
}

class AnimeLocalDataSourceImpl implements AnimeLocalDataSource {
  AnimeLocalDataSourceImpl({Box? hiveBox}) : _hiveBox = hiveBox;
  final Box? _hiveBox;

  Box get _box => _hiveBox ?? Hive.box('anime_cache');

  static const String cacheExpiryPrefix = 'expiry_';
  static const int cacheExpiryMinutes = 30;

  @override
  Future<void> cacheAnimes(String key, List<AnimeModel> animes) async {
    try {
      final jsonList = animes.map((a) => a.toJson()).toList();
      await _box.put(key, jsonEncode(jsonList));
      await _box.put(
          '$cacheExpiryPrefix$key', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw const CacheException('Failed to cache data');
    }
  }

  @override
  Future<List<AnimeModel>> getCachedAnimes(String key) async {
    try {
      final timestamp = _box.get('$cacheExpiryPrefix$key') as int?;
      if (timestamp != null) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final difference = DateTime.now().difference(cacheTime).inMinutes;

        if (difference < cacheExpiryMinutes) {
          final jsonString = _box.get(key) as String?;
          if (jsonString != null) {
            final decoded = jsonDecode(jsonString) as List<dynamic>;
            return decoded
                .map((e) => AnimeModel.fromJson(e as Map<String, dynamic>))
                .toList();
          }
        }
      }
      throw const CacheException('Cache expired or empty');
    } catch (e) {
      throw const CacheException('Failed to get cache');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _box.clear();
    } catch (e) {
      throw const CacheException('Failed to clear cache');
    }
  }
}
