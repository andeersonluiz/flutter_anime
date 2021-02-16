class Categorie {
  String name;
  String code;
  String description;
  String totalMediaCount;

  Categorie({this.name,this.code, this.description, this.totalMediaCount});

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      name: json['attributes']['title'],
      code: json['attributes']['title'],
      description: json['attributes']['description'],
      totalMediaCount: json['attributes']['totalMediaCount'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'code':code,
        'description': description,
        'totalMediaCount': totalMediaCount,
      };
}
