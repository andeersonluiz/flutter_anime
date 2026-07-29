import 'package:freezed_annotation/freezed_annotation.dart';

part 'episode.freezed.dart';

@freezed
class Episode with _$Episode {
  const factory Episode({
    required String id,
    String? title,
    String? synopsis,
    String? thumbnail,
    int? episodeNumber,
    int? seasonNumber,
    String? airdate,
    int? episodeLength,
    @Default(false) bool isMovie,
  }) = _Episode;
}
