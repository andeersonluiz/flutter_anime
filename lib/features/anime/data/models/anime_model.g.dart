// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimeModel _$AnimeModelFromJson(Map<String, dynamic> json) => AnimeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      synopsis: json['synopsis'] as String,
      posterImage: json['posterImage'] as String?,
      coverImage: json['coverImage'] as String?,
      youtubeVideoId: json['youtubeVideoId'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      episodeCount: (json['episodeCount'] as num?)?.toInt(),
      episodeLength: json['episodeLength'] as String?,
      status: json['status'] as String,
      ageRating: json['ageRating'] as String?,
      ageRatingGuide: json['ageRatingGuide'] as String?,
    );

Map<String, dynamic> _$AnimeModelToJson(AnimeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'synopsis': instance.synopsis,
      'posterImage': instance.posterImage,
      'coverImage': instance.coverImage,
      'youtubeVideoId': instance.youtubeVideoId,
      'rating': instance.rating,
      'episodeCount': instance.episodeCount,
      'episodeLength': instance.episodeLength,
      'status': instance.status,
      'ageRating': instance.ageRating,
      'ageRatingGuide': instance.ageRatingGuide,
    };
