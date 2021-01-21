class Categorie {
  String name;
  String description;
  String totalMediaCount;

  Categorie({this.name, this.description, this.totalMediaCount});

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      name: json['attributes']['title'],
      description: json['attributes']['description'],
      totalMediaCount: json['attributes']['totalMediaCount'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'totalMediaCount': totalMediaCount,
      };
}
