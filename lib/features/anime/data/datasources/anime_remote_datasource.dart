import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/anime_model.dart';

abstract class AnimeRemoteDataSource {
  Future<List<AnimeModel>> getTrendingAnimes({int offset = 0, int limit = 10});
  Future<List<AnimeModel>> getMostPopularAnimes({int offset = 0, int limit = 10});
  Future<List<AnimeModel>> getTopRatedAnimes({int offset = 0, int limit = 10});
  Future<List<AnimeModel>> getUpcomingAnimes({int offset = 0, int limit = 10});
  Future<List<AnimeModel>> getCurrentlyAiringAnimes({int offset = 0, int limit = 10});
  Future<AnimeModel> getAnimeDetails(String id);
  Future<List<AnimeModel>> searchAnimes(String query, {int offset = 0, int limit = 10});
  Future<List<AnimeModel>> getAnimesByCategory(String categorySlug, {int offset = 0, int limit = 10});
}

class AnimeRemoteDataSourceImpl implements AnimeRemoteDataSource {
  const AnimeRemoteDataSourceImpl({required this.apiClient});
  final ApiClient apiClient;

  @override
  Future<List<AnimeModel>> getTrendingAnimes({int offset = 0, int limit = 10}) async {
    return _fetchList('/trending/anime?page[limit]=$limit&page[offset]=$offset');
  }

  @override
  Future<List<AnimeModel>> getMostPopularAnimes({int offset = 0, int limit = 10}) async {
    return _fetchList('/anime?sort=-userCount&page[limit]=$limit&page[offset]=$offset');
  }

  @override
  Future<List<AnimeModel>> getTopRatedAnimes({int offset = 0, int limit = 10}) async {
    return _fetchList('/anime?sort=-averageRating&page[limit]=$limit&page[offset]=$offset');
  }

  @override
  Future<List<AnimeModel>> getUpcomingAnimes({int offset = 0, int limit = 10}) async {
    return _fetchList('/anime?filter[status]=upcoming&page[limit]=$limit&page[offset]=$offset');
  }

  @override
  Future<List<AnimeModel>> getCurrentlyAiringAnimes({int offset = 0, int limit = 10}) async {
    return _fetchList('/anime?filter[status]=current&page[limit]=$limit&page[offset]=$offset');
  }

  @override
  Future<List<AnimeModel>> searchAnimes(String query, {int offset = 0, int limit = 10}) async {
    return _fetchList('/anime?filter[text]=$query&page[limit]=$limit&page[offset]=$offset');
  }

  @override
  Future<List<AnimeModel>> getAnimesByCategory(String categorySlug, {int offset = 0, int limit = 10}) async {
    return _fetchList('/anime?filter[categories]=$categorySlug&page[limit]=$limit&page[offset]=$offset');
  }

  @override
  Future<AnimeModel> getAnimeDetails(String id) async {
    try {
      final response = await apiClient.get('/anime/$id');
      final body = response.data as Map<String, dynamic>?;
      if (body != null && body['data'] != null) {
        return AnimeModel.fromJson(body['data'] as Map<String, dynamic>);
      }
      throw const ServerException('Failed to parse anime details');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<AnimeModel>> _fetchList(String path) async {
    try {
      final response = await apiClient.get(path);
      final body = response.data as Map<String, dynamic>?;
      if (body != null && body['data'] != null) {
        final dataList = body['data'] as List;
        return dataList.map((e) => AnimeModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
