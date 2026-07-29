import 'package:animes_io/core/error/exceptions.dart';
import 'package:animes_io/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late ApiClient apiClient;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    apiClient = ApiClient(dio: mockDio);

    registerFallbackValue(RequestOptions(path: ''));
  });

  group('get', () {
    const tUrl = 'https://api.test.com/data';
    final tResponseData = {'key': 'value'};

    test('should return response data when GET is successful', () async {
      when(() => mockDio.get<dynamic>(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: tResponseData,
                statusCode: 200,
                requestOptions: RequestOptions(path: tUrl),
              ));

      final result = await apiClient.get(tUrl);

      expect(result.data, equals(tResponseData));
    });

    test('should throw ServerException when response is 404', () async {
      when(() => mockDio.get<dynamic>(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: tUrl),
        response: Response(
            statusCode: 404, requestOptions: RequestOptions(path: tUrl)),
        type: DioExceptionType.badResponse,
      ));

      final call = apiClient.get;

      expect(() => call(tUrl), throwsA(isA<ServerException>()));
    });

    test('should throw ServerException when connection timeout occurs',
        () async {
      when(() => mockDio.get<dynamic>(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: tUrl),
        type: DioExceptionType.connectionTimeout,
      ));

      final call = apiClient.get;

      expect(() => call(tUrl), throwsA(isA<ServerException>()));
    });
  });
}
