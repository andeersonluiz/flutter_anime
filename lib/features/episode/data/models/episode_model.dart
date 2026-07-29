import '../../domain/entities/episode.dart';

class EpisodeModel {
  final String id;
  final EpisodeAttributes attributes;

  EpisodeModel({
    required this.id,
    required this.attributes,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'] as String,
      attributes: EpisodeAttributes.fromJson(
          json['attributes'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributes': attributes.toJson(),
    };
  }

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

  factory EpisodeAttributes.fromJson(Map<String, dynamic> json) {
    return EpisodeAttributes(
      canonicalTitle: json['canonicalTitle'] as String?,
      synopsis: json['synopsis'] as String?,
      thumbnail: json['thumbnail'] != null
          ? Thumbnail.fromJson(json['thumbnail'] as Map<String, dynamic>)
          : null,
      number: json['number'] as int?,
      seasonNumber: json['seasonNumber'] as int?,
      airdate: json['airdate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'canonicalTitle': canonicalTitle,
      'synopsis': synopsis,
      'thumbnail': thumbnail?.toJson(),
      'number': number,
      'seasonNumber': seasonNumber,
      'airdate': airdate,
    };
  }
}

class Thumbnail {
  final String? original;

  Thumbnail({this.original});

  factory Thumbnail.fromJson(Map<String, dynamic> json) {
    return Thumbnail(
      original: json['original'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'original': original,
    };
  }
}
