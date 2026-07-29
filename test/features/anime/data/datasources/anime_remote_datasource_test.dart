import 'package:animes_io/core/error/exceptions.dart';
import 'package:animes_io/core/network/api_client.dart';
import 'package:animes_io/features/anime/data/datasources/anime_remote_datasource.dart';
import 'package:animes_io/features/anime/data/models/anime_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late AnimeRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = AnimeRemoteDataSourceImpl(apiClient: mockApiClient);
  });

  // Fixture helpers
  Response<dynamic> makeListResponse(List<Map<String, dynamic>> items) {
    return Response(
      data: {'data': items},
      statusCode: 200,
      requestOptions: RequestOptions(path: '/'),
    );
  }

  Response<dynamic> makeDetailResponse(Map<String, dynamic> item) {
    return Response(
      data: {'data': item},
      statusCode: 200,
      requestOptions: RequestOptions(path: '/'),
    );
  }

  Response<dynamic> makeEmptyResponse() {
    return Response(
      data: <String, dynamic>{},
      statusCode: 200,
      requestOptions: RequestOptions(path: '/'),
    );
  }

  const tAnimeJson = {
    'id': '1',
    'attributes': {
      'canonicalTitle': 'Test Anime',
      'synopsis': 'Test Synopsis',
      'status': 'current',
      'averageRating': '80.5',
      'episodeCount': 12,
      'posterImage': {'medium': 'https://img.com/poster.jpg'},
    },
  };

  final tAnimeModel = AnimeModel.fromJson(tAnimeJson);

  group('getTrendingAnimes', () {
    test('should return list of AnimeModel on success', () async {
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => makeListResponse([tAnimeJson]));

      final result = await dataSource.getTrendingAnimes(offset: 0, limit: 10);

      expect(result, isA<List<AnimeModel>>());
      expect(result.first.id, '1');
      expect(result.first.title, 'Test Anime');
    });

    test('should return empty list when response has no data key', () async {
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => makeEmptyResponse());

      final result = await dataSource.getTrendingAnimes();

      expect(result, isEmpty);
    });

    test('should throw ServerException when apiClient throws', () async {
      when(() => mockApiClient.get(any()))
          .thenThrow(const ServerException('timeout'));

      expect(
        () => dataSource.getTrendingAnimes(),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getMostPopularAnimes', () {
    test('should return list of AnimeModel on success', () async {
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => makeListResponse([tAnimeJson]));

      final result =
          await dataSource.getMostPopularAnimes(offset: 0, limit: 10);

      expect(result, isA<List<AnimeModel>>());
    });

    test('should throw ServerException on error', () async {
      when(() => mockApiClient.get(any()))
          .thenThrow(const ServerException('error'));

      expect(
        () => dataSource.getMostPopularAnimes(),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getTopRatedAnimes', () {
    test('should return list of AnimeModel on success', () async {
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => makeListResponse([tAnimeJson]));

      final result = await dataSource.getTopRatedAnimes(offset: 0, limit: 10);

      expect(result, isA<List<AnimeModel>>());
    });
  });

  group('getUpcomingAnimes', () {
    test('should return list of AnimeModel on success', () async {
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => makeListResponse([tAnimeJson]));

      final result = await dataSource.getUpcomingAnimes(offset: 0, limit: 10);

      expect(result, isA<List<AnimeModel>>());
    });
  });

  group('getCurrentlyAiringAnimes', () {
    test('should return list of AnimeModel on success', () async {
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => makeListResponse([tAnimeJson]));

      final result =
          await dataSource.getCurrentlyAiringAnimes(offset: 0, limit: 10);

      expect(result, isA<List<AnimeModel>>());
    });
  });

  group('searchAnimes', () {
    test('should return list of AnimeModel on success', () async {
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => makeListResponse([tAnimeJson]));

      final result =
          await dataSource.searchAnimes('Naruto', offset: 0, limit: 10);

      expect(result, isA<List<AnimeModel>>());
    });

    test('should throw ServerException on error', () async {
      when(() => mockApiClient.get(any()))
          .thenThrow(const ServerException('error'));

      expect(
        () => dataSource.searchAnimes('Naruto'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getAnimesByCategory', () {
    test('should return list of AnimeModel on success', () async {
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => makeListResponse([tAnimeJson]));

      final result =
          await dataSource.getAnimesByCategory('action', offset: 0, limit: 10);

      expect(result, isA<List<AnimeModel>>());
    });
  });

  group('getAnimeDetails', () {
    test('should return AnimeModel on success', () async {
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => makeDetailResponse(tAnimeJson));

      final result = await dataSource.getAnimeDetails('1');

      expect(result, isA<AnimeModel>());
      expect(result.id, tAnimeModel.id);
      expect(result.title, tAnimeModel.title);
    });

    test('should throw ServerException when data key is missing', () async {
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => makeEmptyResponse());

      expect(
        () => dataSource.getAnimeDetails('1'),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw ServerException when apiClient throws', () async {
      when(() => mockApiClient.get(any()))
          .thenThrow(const ServerException('error'));

      expect(
        () => dataSource.getAnimeDetails('1'),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
