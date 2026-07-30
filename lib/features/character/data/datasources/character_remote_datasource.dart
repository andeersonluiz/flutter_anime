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

      final responseData = response.data as Map<String, dynamic>?;
      final data = responseData?['data'] as List<dynamic>? ?? [];

      final list = <CharacterModel>[];
      for (final item in data) {
        if (item is Map<String, dynamic>) {
          try {
            list.add(CharacterModel.fromJson(item));
          } on Exception catch (_) {
            // Skip invalid character entry gracefully
          }
        }
      }
      return list;
    } on Exception catch (e) {
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
          'include': 'character',
        },
      );

      final responseData = relResponse.data as Map<String, dynamic>?;
      if (responseData == null) {
        return [];
      }

      // Check compound document pattern ('included' contains character entities directly)
      if (responseData.containsKey('included') &&
          responseData['included'] is List) {
        final included = responseData['included'] as List<dynamic>;
        final characters = <CharacterModel>[];
        for (final item in included) {
          if (item is Map<String, dynamic> && item['type'] == 'characters') {
            try {
              characters.add(CharacterModel.fromJson(item));
            } on Exception catch (_) {
              // Skip malformed item
            }
          }
        }
        if (characters.isNotEmpty) {
          return characters;
        }
      }

      // Fallback: extract related links with strict null-safety
      final relData = responseData['data'] as List<dynamic>? ?? [];
      final characterLinks = <String>[];
      for (final e in relData) {
        if (e is Map<String, dynamic>) {
          final links = e['links'] as Map<String, dynamic>?;
          final related = links?['related']?.toString();
          if (related != null && related.isNotEmpty) {
            characterLinks.add(related);
          }
        }
      }

      if (characterLinks.isEmpty) {
        return [];
      }

      final characterResponses = await Future.wait(
        characterLinks.map((link) => apiClient.get(link)),
      );

      final result = <CharacterModel>[];
      for (final res in characterResponses) {
        final resData = res.data as Map<String, dynamic>?;
        final charMap = resData?['data'] as Map<String, dynamic>?;
        if (charMap != null) {
          try {
            result.add(CharacterModel.fromJson(charMap));
          } on Exception catch (_) {
            // Skip invalid character payload
          }
        }
      }
      return result;
    } on Exception catch (e) {
      throw ServerException(e.toString());
    }
  }
}
