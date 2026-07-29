// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterModel _$CharacterModelFromJson(Map<String, dynamic> json) =>
    CharacterModel(
      id: json['id'] as String,
      name: json['canonicalName'] as String,
      names: json['names'] == null
          ? null
          : CharacterNamesModel.fromJson(json['names'] as Map<String, dynamic>),
      otherNames: (json['otherNames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      description: json['description'] as String?,
      image: json['image'] == null
          ? null
          : CharacterImageModel.fromJson(json['image'] as Map<String, dynamic>),
      malId: _malIdFromJson(json['malId']),
    );

Map<String, dynamic> _$CharacterModelToJson(CharacterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'canonicalName': instance.name,
      'names': instance.names,
      'otherNames': instance.otherNames,
      'description': instance.description,
      'image': instance.image,
      'malId': _malIdToJson(instance.malId),
    };

CharacterNamesModel _$CharacterNamesModelFromJson(Map<String, dynamic> json) =>
    CharacterNamesModel(
      ja: json['ja'] as String?,
      en: json['en'] as String?,
    );

Map<String, dynamic> _$CharacterNamesModelToJson(
        CharacterNamesModel instance) =>
    <String, dynamic>{
      'ja': instance.ja,
      'en': instance.en,
    };

CharacterImageModel _$CharacterImageModelFromJson(Map<String, dynamic> json) =>
    CharacterImageModel(
      original: json['original'] as String?,
    );

Map<String, dynamic> _$CharacterImageModelToJson(
        CharacterImageModel instance) =>
    <String, dynamic>{
      'original': instance.original,
    };
