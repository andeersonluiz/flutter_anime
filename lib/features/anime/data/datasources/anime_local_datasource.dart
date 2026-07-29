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
  AnimeLocalDataSourceImpl({Box<dynamic>? hiveBox}) : _hiveBox = hiveBox;
  final Box<dynamic>? _hiveBox;

  Box<dynamic> get _box => _hiveBox ?? Hive.box<dynamic>('anime_cache');

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
      final expiryTime = _box.get('$cacheExpiryPrefix$key') as int?;
      if (expiryTime == null) {
        throw const CacheException('Cache expired or not found');
      }

      final now = DateTime.now().millisecondsSinceEpoch;
      final diffMinutes = (now - expiryTime) / (1000 * 60);

      if (diffMinutes > cacheExpiryMinutes) {
        await _box.delete(key);
        await _box.delete('$cacheExpiryPrefix$key');
        throw const CacheException('Cache expired');
      }

      final rawData = _box.get(key) as String?;
      if (rawData == null) {
        throw const CacheException('Cache data empty');
      }

      final List<dynamic> decoded = jsonDecode(rawData) as List<dynamic>;
      return decoded
          .map((json) => AnimeModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is CacheException) rethrow;
      throw const CacheException('Failed to read cache');
    }
  }

  @override
  Future<void> clearCache() async {
    await _box.clear();
  }
}
