import 'package:freezed_annotation/freezed_annotation.dart';

part 'anime.freezed.dart';

@freezed
class Anime with _$Anime {
  const factory Anime({
    required String id,
    required String title,
    required String synopsis,
    String? posterImage,
    String? coverImage,
    String? youtubeVideoId,
    double? rating,
    int? episodeCount,
    String? episodeLength,
    required String status,
    String? ageRating,
    String? ageRatingGuide,
    @Default(false) bool isFavorite,
  }) = _Anime;
}
