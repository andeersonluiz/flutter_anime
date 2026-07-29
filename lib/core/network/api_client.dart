import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../error/exceptions.dart';
import 'api_endpoints.dart';

/// Configured Dio client for the Kitsu API.
///
/// Includes logging interceptor (debug only), error interceptor,
/// and base configuration. Replaces 7+ direct http.get() calls
/// previously scattered across MobX stores.
class ApiClient {
  ApiClient({Dio? dio}) : _dio = dio ?? _createDio();

  final Dio _dio;

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.kitsuBase,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/vnd.api+json',
          'Content-Type': 'application/vnd.api+json',
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          responseBody: false,
          requestBody: false,
          error: true,
        ),
      );
    }

    dio.interceptors.add(_ErrorInterceptor());

    return dio;
  }

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  ServerException _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const ServerException(
            'Connection timeout. Check your internet.');
      case DioExceptionType.connectionError:
        return const ServerException('No internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        return ServerException('Server error: $statusCode');
      default:
        return ServerException(e.message ?? 'Unknown network error.');
    }
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('API Error [${err.response?.statusCode}]: ${err.message}');
    }
    handler.next(err);
  }
}
