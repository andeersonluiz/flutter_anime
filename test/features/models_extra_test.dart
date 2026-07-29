import 'package:animes_io/core/error/exceptions.dart';
import 'package:animes_io/features/category/data/datasources/category_remote_datasource.dart';
import 'package:animes_io/features/category/data/models/category_model.dart';
import 'package:animes_io/features/character/data/datasources/character_remote_datasource.dart';
import 'package:animes_io/features/character/data/models/character_model.dart';
import 'package:animes_io/features/episode/data/datasources/episode_remote_datasource.dart';
import 'package:animes_io/features/episode/data/models/episode_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CategoryModel JSON & serialization', () {
    test('toJson produces expected structure', () {
      final model = CategoryModel(
        id: '1',
        title: 'Action',
        slug: 'action',
        description: 'Action anime',
        totalMediaCount: 100,
      );
      final json = model.toJson();
      expect(json['id'], '1');
      expect(json['attributes']['title'], 'Action');
      expect(json['attributes']['slug'], 'action');
      expect(json['attributes']['description'], 'Action anime');
      expect(json['attributes']['totalMediaCount'], 100);
    });
  });

  group('CharacterModel JSON & serialization', () {
    test('toJson produces expected structure', () {
      final model = CharacterModel(
        id: 'c1',
        name: 'Goku',
        names: CharacterNamesModel(ja: 'ゴクウ', en: 'Goku'),
        otherNames: ['Kakarot'],
        description: 'Saiyan',
        image: CharacterImageModel(original: 'https://example.com/goku.png'),
        malId: '123',
      );

      final json = model.toJson();
      expect(json['id'], 'c1');
      expect(json['attributes']['canonicalName'], 'Goku');
      expect(json['attributes']['names']['ja'], 'ゴクウ');
      expect(json['attributes']['otherNames'], ['Kakarot']);
      expect(json['attributes']['description'], 'Saiyan');
      expect(json['attributes']['image']['original'],
          'https://example.com/goku.png');
      expect(json['attributes']['malId'], 123);
    });

    test('CharacterNamesModel fromJson and toJson', () {
      final json = {'ja': '日本語', 'en': 'English'};
      final model = CharacterNamesModel.fromJson(json);
      expect(model.ja, '日本語');
      expect(model.en, 'English');
      expect(model.toJson(), json);
    });

    test('CharacterImageModel fromJson and toJson', () {
      final json = {'original': 'https://example.com/img.jpg'};
      final model = CharacterImageModel.fromJson(json);
      expect(model.original, 'https://example.com/img.jpg');
      expect(model.toJson(), json);
    });
  });

  group('EpisodeModel JSON & serialization', () {
    test('toJson produces expected structure', () {
      final model = EpisodeModel(
        id: 'ep1',
        attributes: EpisodeAttributes(
          canonicalTitle: 'Title 1',
          synopsis: 'Synopsis 1',
          thumbnail: Thumbnail(original: 'https://example.com/thumb.jpg'),
          number: 1,
          seasonNumber: 1,
          airdate: '2020-01-01',
        ),
      );

      final json = model.toJson();
      expect(json['id'], 'ep1');
      expect(json['attributes']['canonicalTitle'], 'Title 1');
      expect(json['attributes']['thumbnail']['original'],
          'https://example.com/thumb.jpg');
      expect(json['attributes']['number'], 1);
    });

    test('EpisodeAttributes fromJson handles null thumbnail', () {
      final json = <String, dynamic>{
        'canonicalTitle': 'Title',
        'number': 2,
      };
      final attrs = EpisodeAttributes.fromJson(json);
      expect(attrs.canonicalTitle, 'Title');
      expect(attrs.thumbnail, isNull);
    });
  });
}
