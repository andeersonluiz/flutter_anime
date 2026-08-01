// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpisodeModel _$EpisodeModelFromJson(Map<String, dynamic> json) => EpisodeModel(
      id: json['id'] as String,
      attributes: EpisodeAttributes.fromJson(
          json['attributes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EpisodeModelToJson(EpisodeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attributes': instance.attributes.toJson(),
    };

EpisodeAttributes _$EpisodeAttributesFromJson(Map<String, dynamic> json) =>
    EpisodeAttributes(
      canonicalTitle: json['canonicalTitle'] as String?,
      synopsis: json['synopsis'] as String?,
      thumbnail: json['thumbnail'] == null
          ? null
          : Thumbnail.fromJson(json['thumbnail'] as Map<String, dynamic>),
      number: (json['number'] as num?)?.toInt(),
      seasonNumber: (json['seasonNumber'] as num?)?.toInt(),
      airdate: json['airdate'] as String?,
    );

Map<String, dynamic> _$EpisodeAttributesToJson(EpisodeAttributes instance) =>
    <String, dynamic>{
      'canonicalTitle': instance.canonicalTitle,
      'synopsis': instance.synopsis,
      'thumbnail': instance.thumbnail?.toJson(),
      'number': instance.number,
      'seasonNumber': instance.seasonNumber,
      'airdate': instance.airdate,
    };

Thumbnail _$ThumbnailFromJson(Map<String, dynamic> json) => Thumbnail(
      original: json['original'] as String?,
    );

Map<String, dynamic> _$ThumbnailToJson(Thumbnail instance) => <String, dynamic>{
      'original': instance.original,
    };
