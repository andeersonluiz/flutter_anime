import 'dart:convert';

import 'package:animes_io/core/error/exceptions.dart';
import 'package:animes_io/features/anime/data/datasources/anime_local_datasource.dart';
import 'package:animes_io/features/anime/data/models/anime_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveBox extends Mock implements Box<dynamic> {}

void main() {
  late AnimeLocalDataSourceImpl dataSource;
  late MockHiveBox mockBox;

  const tKey = 'anime_trending_0';
  const tExpiryKey = 'expiry_$tKey';

  const tAnimeModel = AnimeModel(
    id: '1',
    title: 'Test Anime',
    synopsis: 'Test Synopsis',
    status: 'current',
  );
  final tAnimeList = [tAnimeModel];
  final tJsonEncoded = jsonEncode([tAnimeModel.toJson()]);

  setUp(() {
    mockBox = MockHiveBox();
    dataSource = AnimeLocalDataSourceImpl(hiveBox: mockBox);
  });

  group('cacheAnimes', () {
    test('should store JSON and expiry timestamp in hive box', () async {
      when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

      await dataSource.cacheAnimes(tKey, tAnimeList);

      verify(() => mockBox.put(tKey, any())).called(1);
      verify(() => mockBox.put(tExpiryKey, any())).called(1);
    });

    test('should throw CacheException when put throws', () async {
      when(() => mockBox.put(any(), any())).thenThrow(Exception('disk full'));

      expect(
        () => dataSource.cacheAnimes(tKey, tAnimeList),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('getCachedAnimes', () {
    test('should return list from cache when data is fresh', () async {
      final freshTimestamp = DateTime.now().millisecondsSinceEpoch;
      when(() => mockBox.get(tExpiryKey)).thenReturn(freshTimestamp);
      when(() => mockBox.get(tKey)).thenReturn(tJsonEncoded);

      final result = await dataSource.getCachedAnimes(tKey);

      expect(result, isA<List<AnimeModel>>());
      expect(result.first.id, '1');
    });

    test('should throw CacheException when expiry is null (not found)',
        () async {
      when(() => mockBox.get(tExpiryKey)).thenReturn(null);

      expect(
        () => dataSource.getCachedAnimes(tKey),
        throwsA(isA<CacheException>()),
      );
    });

    test('should throw CacheException and delete entries when cache is expired',
        () async {
      // Timestamp 31 minutes ago
      final expiredTimestamp = DateTime.now()
          .subtract(const Duration(minutes: 31))
          .millisecondsSinceEpoch;
      when(() => mockBox.get(tExpiryKey)).thenReturn(expiredTimestamp);
      when(() => mockBox.delete(any())).thenAnswer((_) async {});

      expect(
        () => dataSource.getCachedAnimes(tKey),
        throwsA(isA<CacheException>()),
      );

      await Future<void>.delayed(Duration.zero);
      verify(() => mockBox.delete(tKey)).called(1);
      verify(() => mockBox.delete(tExpiryKey)).called(1);
    });

    test('should throw CacheException when cached data string is null',
        () async {
      final freshTimestamp = DateTime.now().millisecondsSinceEpoch;
      when(() => mockBox.get(tExpiryKey)).thenReturn(freshTimestamp);
      when(() => mockBox.get(tKey)).thenReturn(null);

      expect(
        () => dataSource.getCachedAnimes(tKey),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('clearCache', () {
    test('should call box.clear()', () async {
      when(() => mockBox.clear()).thenAnswer((_) async => 0);

      await dataSource.clearCache();

      verify(() => mockBox.clear()).called(1);
    });
  });
}
