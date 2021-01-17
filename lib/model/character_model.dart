class Character {
  String id;
  String createdAt;
  String japaneseName;
  String name;
  List<String> otherNames;
  String malId;
  String description;
  String image;

  Character(
      {this.id,
      this.createdAt,
      this.japaneseName,
       this.name,
       this.otherNames,
      this.malId,
      this.description,
      this.image});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      createdAt: json['attributes']['createdAt'],
      japaneseName:json['attributes']['names']==null?"":json['attributes']['names']['ja_jp']==null?"":json['attributes']['names']['ja_jp'],
      name: json['attributes']['canonicalName'],
      otherNames:json['attributes']['otherNames'].length>0?json['attributes']['otherNames'].map<String>((value)=> value as String ).toList():[],
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
        'name': name,
        'otherNames':otherNames,
        'malId': malId,
        'description': description,
        'image': image,
      };
}
