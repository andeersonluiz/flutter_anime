import 'package:animes_io/features/character/domain/entities/character.dart';

class CharacterModel {
  final String id;
  final String name;
  final CharacterNamesModel? names;
  final List<String> otherNames;
  final String? description;
  final CharacterImageModel? image;
  final String? malId;

  CharacterModel({
    required this.id,
    required this.name,
    this.names,
    required this.otherNames,
    this.description,
    this.image,
    this.malId,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] as Map<String, dynamic>;
    return CharacterModel(
      id: json['id'] as String,
      name: attributes['canonicalName'] as String,
      names: attributes['names'] != null ? CharacterNamesModel.fromJson(attributes['names'] as Map<String, dynamic>) : null,
      otherNames: (attributes['otherNames'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      description: attributes['description'] as String?,
      image: attributes['image'] != null ? CharacterImageModel.fromJson(attributes['image'] as Map<String, dynamic>) : null,
      malId: _malIdFromJson(attributes['malId']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributes': {
        'canonicalName': name,
        'names': names?.toJson(),
        'otherNames': otherNames,
        'description': description,
        'image': image?.toJson(),
        'malId': _malIdToJson(malId),
      }
    };
  }

  Character toEntity() {
    return Character(
      id: id,
      name: name,
      japaneseName: names?.ja,
      otherNames: otherNames,
      description: description,
      image: image?.original ?? 'https://i.imgur.com/DIhR3Po.jpg',
      malId: malId,
    );
  }
}

class CharacterNamesModel {
  final String? ja;
  final String? en;

  CharacterNamesModel({this.ja, this.en});

  factory CharacterNamesModel.fromJson(Map<String, dynamic> json) {
    return CharacterNamesModel(
      ja: json['ja'] as String?,
      en: json['en'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ja': ja,
      'en': en,
    };
  }
}

class CharacterImageModel {
  final String? original;

  CharacterImageModel({this.original});

  factory CharacterImageModel.fromJson(Map<String, dynamic> json) {
    return CharacterImageModel(
      original: json['original'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'original': original,
    };
  }
}

String? _malIdFromJson(dynamic malId) {
  if (malId == null) return null;
  return malId.toString();
}

dynamic _malIdToJson(String? malId) {
  if (malId == null) return null;
  return int.tryParse(malId);
}
