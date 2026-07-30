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

  Future<Box<dynamic>> _getBox() async {
    if (_hiveBox != null && _hiveBox!.isOpen) {
      return _hiveBox!;
    }
    if (Hive.isBoxOpen('anime_cache')) {
      return Hive.box<dynamic>('anime_cache');
    }
    return await Hive.openBox<dynamic>('anime_cache');
  }

  static const String cacheExpiryPrefix = 'expiry_';
  static const int cacheExpiryMinutes = 30;

  @override
  Future<void> cacheAnimes(String key, List<AnimeModel> animes) async {
    try {
      final box = await _getBox();
      final jsonList = animes.map((a) => a.toJson()).toList();
      await box.put(key, jsonEncode(jsonList));
      await box.put(
          '$cacheExpiryPrefix$key', DateTime.now().millisecondsSinceEpoch);
    } on Exception catch (_) {
      throw const CacheException('Failed to cache data');
    }
  }

  @override
  Future<List<AnimeModel>> getCachedAnimes(String key) async {
    try {
      final box = await _getBox();
      final expiryTime = box.get('$cacheExpiryPrefix$key') as int?;
      if (expiryTime == null) {
        throw const CacheException('Cache expired or not found');
      }

      final now = DateTime.now().millisecondsSinceEpoch;
      final diffMinutes = (now - expiryTime) / (1000 * 60);

      if (diffMinutes > cacheExpiryMinutes) {
        await box.delete(key);
        await box.delete('$cacheExpiryPrefix$key');
        throw const CacheException('Cache expired');
      }

      final rawData = box.get(key) as String?;
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
    final box = await _getBox();
    await box.clear();
  }
}
