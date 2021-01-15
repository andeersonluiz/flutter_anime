import 'package:project1/model/episode_model.dart';

class Anime {
  String id;
  String synopsis;
  String canonicalTitle;
  String ageRatingGuide;
  String posterImage;
  String coverImage;
  int episodeCount;
  int episodeLength;
  String youtubeVideoId;
  String status;
  List<Episode> episodes;
  String linkEpisodeList;
  Anime({
    this.id,
    this.synopsis,
    this.canonicalTitle,
    this.ageRatingGuide,
    this.posterImage,
    this.coverImage,
    this.episodeCount,
    this.episodeLength,
    this.youtubeVideoId,
    this.status,
    this.linkEpisodeList,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['id'].toString(),
      synopsis: json['attributes']['synopsis'] == ""
          ? "No synopsis at the moment :("
          : json['attributes']['synopsis'],
      canonicalTitle: json['attributes']['canonicalTitle'],
      ageRatingGuide: json['attributes']['ageRatingGuide'] ?? "-",
      episodeCount: json['attributes']['episodeCount'] ?? 0,
      episodeLength: json['attributes']['episodeLength'] ?? 0,
      youtubeVideoId: json['attributes']['youtubeVideoId'] ?? "",
      posterImage: json['attributes']['posterImage']['medium'] ??
          json['attributes']['posterImage']['large'] ??
          json['attributes']['posterImage']['original'],
      coverImage: json['attributes']['coverImage'] == null
          ? json['attributes']['posterImage']['medium'] ??
          json['attributes']['posterImage']['large'] ??
          json['attributes']['posterImage']['original']
          : json['attributes']['coverImage']['large'],
      status: json['attributes']['status'],
      linkEpisodeList: json['relationships']['episodes']['links']['related'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'synopsis': synopsis,
        'canonicalTitle': canonicalTitle,
        'ageRatingGuide': ageRatingGuide,
        'episodeCount': episodeCount,
        'episodeLength': episodeLength,
        'youtubeVideoId': youtubeVideoId,
        'posterImage': posterImage,
        'coverImage': coverImage,
        'status': status,
        'linkEpisodeList': linkEpisodeList,
      };
}
