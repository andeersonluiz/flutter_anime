import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/episode.dart';

part 'episode_model.g.dart';

@JsonSerializable()
class EpisodeModel {
  final String id;
  final EpisodeAttributes attributes;

  EpisodeModel({
    required this.id,
    required this.attributes,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) =>
      _$EpisodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeModelToJson(this);

  Episode toEntity() {
    return Episode(
      id: id,
      title: attributes.canonicalTitle,
      synopsis: attributes.synopsis,
      thumbnail: attributes.thumbnail?.original,
      episodeNumber: attributes.number,
      seasonNumber: attributes.seasonNumber,
      airdate: attributes.airdate,
      isMovie: false,
    );
  }
}

@JsonSerializable()
class EpisodeAttributes {
  final String? canonicalTitle;
  final String? synopsis;
  final Thumbnail? thumbnail;
  final int? number;
  final int? seasonNumber;
  final String? airdate;

  EpisodeAttributes({
    this.canonicalTitle,
    this.synopsis,
    this.thumbnail,
    this.number,
    this.seasonNumber,
    this.airdate,
  });

  factory EpisodeAttributes.fromJson(Map<String, dynamic> json) =>
      _$EpisodeAttributesFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeAttributesToJson(this);
}

@JsonSerializable()
class Thumbnail {
  final String? original;

  Thumbnail({this.original});

  factory Thumbnail.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailFromJson(json);

  Map<String, dynamic> toJson() => _$ThumbnailToJson(this);
}
