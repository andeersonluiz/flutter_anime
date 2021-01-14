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
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
   print("pa"+json['attributes']['episodeLength'].toString());
    print(json['attributes']['episodeLength']==null);
    return Anime(
      id: json['id'].toString(),
      synopsis: json['attributes']['synopsis']==""?"No synopsis at the moment :(":json['attributes']['synopsis'],
      canonicalTitle: json['attributes']['canonicalTitle'],
      ageRatingGuide: json['attributes']['ageRatingGuide']??"-",
      episodeCount: json['attributes']['episodeCount']??0,
      episodeLength: json['attributes']['episodeLength']??0,
      youtubeVideoId: json['attributes']['youtubeVideoId'] ?? "",
      posterImage: json['attributes']['posterImage']['medium'] ??
          json['attributes']['posterImage']['large'] ??
          json['attributes']['posterImage']['original'],
      coverImage: json['attributes']['coverImage'] == null
          ? "https://images6.alphacoders.com/867/thumb-1920-867616.png"
          : json['attributes']['coverImage']['large'],
      status: json['attributes']['status'],
    );
  }

  factory Anime.fromJsonTwo(Map<String, dynamic> json) {
    return Anime(
      id: json['id'],
      synopsis: json['synopsis'],
      canonicalTitle: json['canonicalTitle'],
      ageRatingGuide: json['ageRatingGuide'],
      episodeCount: json['episodeCount'],
      episodeLength: json['episodeLength'],
      youtubeVideoId: json['youtubeVideoId'] ?? "1",
      posterImage: json['posterImage'],
      coverImage: json['coverImage'],
      status: json['status'],
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
      };
  Stream<int> tick() {
    return Stream.periodic(Duration(seconds: 1), (x) => x).take(10);
  }
}
