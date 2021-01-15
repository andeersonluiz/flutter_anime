class Episode {
  String id;
  String createdAt;
  String updateAt;
  String synopsis;
  String description;
  String canonicalTitle;
  String seasonNumber;
  String number;
  String relativeNumber;
  String airDate;
  String length;
  String thumbnail;

  Episode({
    this.id,
    this.createdAt,
    this.updateAt,
    this.synopsis,
    this.description,
    this.canonicalTitle,
    this.seasonNumber,
    this.number,
    this.relativeNumber,
    this.airDate,
    this.length,
    this.thumbnail,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    //print("id:${json['id']}, createdAt:${json['attributes']['createdAt']}, updateAt:${json['attributes']['updatedAt']},synopsis:${json['attributes']['synopsis'].split('a')[0]}, description:${json['attributes']['description'].split('a')[0]}, canonicalTitleid:${json['attributes']['canonicalTitle']}, seasonNumber:${json['attributes']['seasonNumber']}, number:${json['attributes']['number']}, relativeNumber:${json['attributes']['relativeNumber']},airDate:${json['attributes']['airdate']}, length:${json['attributes']['length']}, thumbnail:${json['attributes']['thumbnail']['original']}");
    return Episode(
      id: json['id'],
      createdAt: json['attributes']['createdAt'] ?? "-",
      updateAt: json['attributes']['updatedAt'] ?? "-",
      synopsis: json['attributes']['synopsis'] ?? "-",
      description: json['attributes']['description'] ?? "-",
      canonicalTitle: json['attributes']['canonicalTitle'] ?? "-",
      seasonNumber: json['attributes']['seasonNumber'].toString() ?? "-",
      number: json['attributes']['number'].toString() ?? "-",
      relativeNumber: json['attributes']['relativeNumber'].toString() ?? "-",
      airDate: json['attributes']['airdate'] ?? "-",
      length: json['attributes']['length'].toString() ?? "-",
      thumbnail: json['attributes']['thumbnail'] != null
          ? json['attributes']['thumbnail']['original']
          : "https://i.imgur.com/DIhR3Po.jpg",
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt,
        'updateAt': updateAt,
        'synopsis': synopsis,
        'description': description,
        'canonicalTitle': canonicalTitle,
        'seasonNumber': seasonNumber,
        'number': number,
        'relativeNumber': relativeNumber,
        'airDate': airDate,
        'length': length,
        'thumbnail': thumbnail,
      };
}
