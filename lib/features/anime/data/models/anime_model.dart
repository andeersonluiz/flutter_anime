import '../../domain/entities/anime.dart';

class AnimeModel {
  const AnimeModel({
    required this.id,
    required this.title,
    required this.synopsis,
    this.posterImage,
    this.coverImage,
    this.youtubeVideoId,
    this.rating,
    this.episodeCount,
    this.episodeLength,
    required this.status,
    this.ageRating,
    this.ageRatingGuide,
  });

  final String id;
  final String title;
  final String synopsis;
  final String? posterImage;
  final String? coverImage;
  final String? youtubeVideoId;
  final double? rating;
  final int? episodeCount;
  final String? episodeLength;
  final String status;
  final String? ageRating;
  final String? ageRatingGuide;

  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] as Map<String, dynamic>? ?? {};
    return AnimeModel(
      id: json['id'] as String,
      title: attributes['canonicalTitle'] as String? ?? 'No Title',
      synopsis: attributes['synopsis'] as String? ?? 'No Synopsis',
      posterImage: (attributes['posterImage']
          as Map<String, dynamic>?)?['medium'] as String?,
      coverImage: (attributes['coverImage'] as Map<String, dynamic>?)?['large']
          as String?,
      youtubeVideoId: attributes['youtubeVideoId'] as String?,
      rating: attributes['averageRating'] != null
          ? double.tryParse(attributes['averageRating'].toString())
          : null,
      episodeCount: attributes['episodeCount'] as int?,
      episodeLength: attributes['episodeLength']?.toString(),
      status: attributes['status'] as String? ?? 'tba',
      ageRating: attributes['ageRating'] as String?,
      ageRatingGuide: attributes['ageRatingGuide'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'synopsis': synopsis,
      'posterImage': posterImage,
      'coverImage': coverImage,
      'youtubeVideoId': youtubeVideoId,
      'rating': rating,
      'episodeCount': episodeCount,
      'episodeLength': episodeLength,
      'status': status,
      'ageRating': ageRating,
      'ageRatingGuide': ageRatingGuide,
    };
  }

  Anime toEntity() {
    return Anime(
      id: id,
      title: title,
      synopsis: synopsis,
      posterImage: posterImage,
      coverImage: coverImage,
      youtubeVideoId: youtubeVideoId,
      rating: rating,
      episodeCount: episodeCount,
      episodeLength: episodeLength,
      status: status,
      ageRating: ageRating,
      ageRatingGuide: ageRatingGuide,
    );
  }
}
