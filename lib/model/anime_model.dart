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
  String linkCharacterList;
  bool isFavorite;
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
    this.linkCharacterList,
    this.isFavorite,
  });

  factory Anime.fromJson(Map<String, dynamic> json, {bool isFavorite = false}) {
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
      linkCharacterList: json['relationships']['characters']['links']
          ['related'],
      isFavorite: isFavorite,
    );
  }

  factory Anime.fromJsonFirebase(Map<String, dynamic> json) {
    return Anime(
      id: json['id'].toString(),
      synopsis: json['synopsis'],
      canonicalTitle: json['canonicalTitle'],
      ageRatingGuide: json['ageRatingGuide'],
      episodeCount: json['episodeCount'],
      episodeLength: json['episodeLength'],
      youtubeVideoId: json['youtubeVideoId'],
      posterImage: json['posterImage'],
      coverImage: json['coverImage'],
      status: json['status'],
      linkEpisodeList: json['linkEpisodeList'],
      linkCharacterList: json['linkCharacterList'],
      isFavorite: json['isFavorite'],
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
        'linkCharacterList': linkCharacterList,
        'isFavorite': isFavorite
      };

  @override
  String toString() {
    return "id: $id,synopsis: $synopsis,canonicalTitle: $canonicalTitle,ageRatingGuide: $ageRatingGuide, episodeCount: $episodeCount," +
        "episodeLength: $episodeLength,youtubeVideoId: $youtubeVideoId,posterImage: $posterImage, coverImage: $coverImage," +
        "status: $status,linkEpisodeList: $linkEpisodeList,linkCharacterList: $linkCharacterList,isFavorite: $isFavorite";
  }
}
