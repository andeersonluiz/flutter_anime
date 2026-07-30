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
    final attributes = (json['attributes'] as Map<String, dynamic>?) ?? {};
    final canonicalName = attributes['canonicalName']?.toString();
    final nameAttr = attributes['name']?.toString();
    final fallbackName = (canonicalName != null && canonicalName.isNotEmpty)
        ? canonicalName
        : ((nameAttr != null && nameAttr.isNotEmpty)
            ? nameAttr
            : 'Unknown Character');

    return CharacterModel(
      id: (json['id'] ?? '').toString(),
      name: fallbackName,
      names: attributes['names'] != null &&
              attributes['names'] is Map<String, dynamic>
          ? CharacterNamesModel.fromJson(
              attributes['names'] as Map<String, dynamic>)
          : null,
      otherNames: (attributes['otherNames'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .where((e) => e.isNotEmpty)
              .toList() ??
          [],
      description: attributes['description']?.toString(),
      image: attributes['image'] != null &&
              attributes['image'] is Map<String, dynamic>
          ? CharacterImageModel.fromJson(
              attributes['image'] as Map<String, dynamic>)
          : null,
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
      ja: json['ja']?.toString() ?? json['ja_jp']?.toString(),
      en: json['en']?.toString() ?? json['en_us']?.toString(),
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
    final original = json['original']?.toString();
    final medium = json['medium']?.toString();
    final small = json['small']?.toString();
    return CharacterImageModel(
      original: (original != null && original.isNotEmpty)
          ? original
          : ((medium != null && medium.isNotEmpty) ? medium : small),
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
