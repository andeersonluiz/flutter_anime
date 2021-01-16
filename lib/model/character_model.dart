class Character {
  String id;
  String createdAt;
  String japaneseName;
  String cannonicalName;
  String malId;
  String description;
  String image;

  Character(
      {this.id,
      this.createdAt,
      this.japaneseName,
       this.cannonicalName,
      this.malId,
      this.description,
      this.image});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      createdAt: json['attributes']['createdAt'],
      japaneseName:json['attributes']['names']==null?"":json['attributes']['names']['ja_jp']==null?"":json['attributes']['names']['ja_jp'],
      cannonicalName: json['attributes']['canonicalName'],
      malId: json['attributes']['malId'].toString(),
      description: json['attributes']['description'].toString(),
      image: json['attributes']['image'] == null
          ? "https://i.imgur.com/DIhR3Po.jpg"
          : json['attributes']['image']['original'],
      
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt,
        'cannonicalName': cannonicalName,
        'malId': malId,
        'description': description,
        'image': image,
      };
}
