import 'package:animes_io/features/anime/data/models/anime_model.dart';
import 'package:animes_io/features/anime/domain/entities/anime.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tJson = {
    'id': '1',
    'attributes': {
      'canonicalTitle': 'Test Anime',
      'synopsis': 'A great synopsis',
      'status': 'current',
      'averageRating': '82.5',
      'episodeCount': 24,
      'episodeLength': 23,
      'ageRating': 'PG',
      'ageRatingGuide': 'Teens 13 or older',
      'youtubeVideoId': 'abc123',
      'posterImage': {'medium': 'https://img.com/poster.jpg'},
      'coverImage': {'large': 'https://img.com/cover.jpg'},
    },
  };

  const tJsonMinimal = {
    'id': '2',
    'attributes': <String, dynamic>{},
  };

  group('AnimeModel.fromJson', () {
    test('should parse all fields from full JSON', () {
      final model = AnimeModel.fromJson(tJson);

      expect(model.id, '1');
      expect(model.title, 'Test Anime');
      expect(model.synopsis, 'A great synopsis');
      expect(model.status, 'current');
      expect(model.rating, 82.5);
      expect(model.episodeCount, 24);
      expect(model.episodeLength, '23');
      expect(model.ageRating, 'PG');
      expect(model.ageRatingGuide, 'Teens 13 or older');
      expect(model.youtubeVideoId, 'abc123');
      expect(model.posterImage, 'https://img.com/poster.jpg');
      expect(model.coverImage, 'https://img.com/cover.jpg');
    });

    test('should use default values when optional fields are absent', () {
      final model = AnimeModel.fromJson(tJsonMinimal);

      expect(model.id, '2');
      expect(model.title, 'No Title');
      expect(model.synopsis, 'No Synopsis');
      expect(model.status, 'tba');
      expect(model.rating, isNull);
      expect(model.episodeCount, isNull);
      expect(model.posterImage, isNull);
      expect(model.coverImage, isNull);
    });
  });

  group('AnimeModel.toJson', () {
    test('should serialize to map with all fields', () {
      const model = AnimeModel(
        id: '1',
        title: 'Test Anime',
        synopsis: 'A great synopsis',
        status: 'current',
        rating: 82.5,
        episodeCount: 24,
        episodeLength: '23',
        posterImage: 'https://img.com/poster.jpg',
        coverImage: 'https://img.com/cover.jpg',
        youtubeVideoId: 'abc123',
        ageRating: 'PG',
        ageRatingGuide: 'Teens 13 or older',
      );

      final json = model.toJson();

      expect(json['id'], '1');
      expect(json['title'], 'Test Anime');
      expect(json['synopsis'], 'A great synopsis');
      expect(json['status'], 'current');
      expect(json['rating'], 82.5);
      expect(json['episodeCount'], 24);
      expect(json['episodeLength'], '23');
      expect(json['posterImage'], 'https://img.com/poster.jpg');
      expect(json['coverImage'], 'https://img.com/cover.jpg');
      expect(json['youtubeVideoId'], 'abc123');
      expect(json['ageRating'], 'PG');
      expect(json['ageRatingGuide'], 'Teens 13 or older');
    });

    test('should serialize nullable fields as null', () {
      const model = AnimeModel(
        id: '1',
        title: 'Test',
        synopsis: 'Test',
        status: 'current',
      );

      final json = model.toJson();

      expect(json['posterImage'], isNull);
      expect(json['coverImage'], isNull);
      expect(json['rating'], isNull);
    });
  });

  group('AnimeModel.toEntity', () {
    test('should convert to Anime entity correctly', () {
      const model = AnimeModel(
        id: '1',
        title: 'Test Anime',
        synopsis: 'Great anime',
        status: 'current',
        rating: 80.0,
        episodeCount: 12,
        posterImage: 'https://img.com/poster.jpg',
      );

      final entity = model.toEntity();

      expect(entity, isA<Anime>());
      expect(entity.id, '1');
      expect(entity.title, 'Test Anime');
      expect(entity.synopsis, 'Great anime');
      expect(entity.status, 'current');
      expect(entity.rating, 80.0);
      expect(entity.episodeCount, 12);
      expect(entity.posterImage, 'https://img.com/poster.jpg');
    });

    test('toEntity preserves null optional fields', () {
      const model = AnimeModel(
        id: '2',
        title: 'Minimal',
        synopsis: 'Minimal',
        status: 'tba',
      );

      final entity = model.toEntity();

      expect(entity.rating, isNull);
      expect(entity.posterImage, isNull);
      expect(entity.coverImage, isNull);
    });
  });

  group('AnimeModel roundtrip', () {
    test('fromJson -> toJson preserves all data', () {
      final model = AnimeModel.fromJson(tJson);
      final json = model.toJson();

      // Re-read from the plain toJson format (not API format)
      expect(json['id'], model.id);
      expect(json['title'], model.title);
      expect(json['synopsis'], model.synopsis);
      expect(json['status'], model.status);
      expect(json['rating'], model.rating);
    });
  });
}
