import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/episode_model.dart';

abstract class EpisodeRemoteDataSource {
  Future<List<EpisodeModel>> getEpisodes(String animeId, {int offset = 0, int limit = 20});
}

class EpisodeRemoteDataSourceImpl implements EpisodeRemoteDataSource {
  final ApiClient apiClient;

  EpisodeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<EpisodeModel>> getEpisodes(String animeId, {int offset = 0, int limit = 20}) async {
    try {
      final response = await apiClient.get(
        '/anime/$animeId/episodes',
        queryParameters: {
          'page[limit]': limit,
          'page[offset]': offset,
        },
      );

      final body = response.data as Map<String, dynamic>?;
      if (body != null && body['data'] != null) {
        final List<dynamic> data = body['data'] as List<dynamic>;
        return data.map((json) => EpisodeModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
