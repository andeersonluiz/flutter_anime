import 'package:animes_io/core/error/exceptions.dart';
import 'package:animes_io/core/network/api_client.dart';
import 'package:animes_io/features/character/data/models/character_model.dart';

abstract class CharacterRemoteDataSource {
  Future<List<CharacterModel>> getCharacters(
      {required int offset, required int limit});
  Future<List<CharacterModel>> getAnimeCharacters(String animeId,
      {required int offset, required int limit});
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final ApiClient apiClient;

  CharacterRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CharacterModel>> getCharacters(
      {required int offset, required int limit}) async {
    try {
      final response = await apiClient.get(
        '/characters',
        queryParameters: {
          'sort': 'name',
          'page[limit]': limit,
          'page[offset]': offset,
        },
      );
      final data = response.data['data'] as List;
      return data
          .map((json) => CharacterModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CharacterModel>> getAnimeCharacters(String animeId,
      {required int offset, required int limit}) async {
    try {
      final relResponse = await apiClient.get(
        '/anime/$animeId/characters',
        queryParameters: {
          'page[limit]': limit,
          'page[offset]': offset,
        },
      );

      final relData = relResponse.data['data'] as List;
      final characterLinks =
          relData.map((e) => e['links']['related'] as String).toList();

      if (characterLinks.isEmpty) {
        return [];
      }

      final characterResponses = await Future.wait(
        characterLinks.map((link) => apiClient.get(link)),
      );

      return characterResponses.map((res) {
        return CharacterModel.fromJson(
            res.data['data'] as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
