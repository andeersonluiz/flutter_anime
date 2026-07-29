import 'package:animes_io/core/error/exceptions.dart';
import 'package:animes_io/core/network/api_client.dart';
import 'package:animes_io/features/category/data/models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getTrendingCategories({required int limit});
  Future<List<CategoryModel>> getAllCategories(
      {required int offset, required int limit});
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiClient apiClient;

  CategoryRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CategoryModel>> getTrendingCategories(
      {required int limit}) async {
    try {
      final response = await apiClient.get(
        '/categories',
        queryParameters: {
          'sort': '-totalMediaCount',
          'page[limit]': limit,
        },
      );
      final data = response.data['data'] as List;
      return data
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CategoryModel>> getAllCategories(
      {required int offset, required int limit}) async {
    try {
      final response = await apiClient.get(
        '/categories',
        queryParameters: {
          'sort': 'title',
          'page[limit]': limit,
          'page[offset]': offset,
        },
      );
      final data = response.data['data'] as List;
      return data
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
