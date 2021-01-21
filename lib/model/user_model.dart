import 'package:project1/model/anime_model.dart';
import 'package:project1/model/categorie_model.dart';

class Person {
  String id;
  String email;
  String password;
  String nickname;
  String background;
  List<Anime> favoritesAnimes;
  List<Categorie> favoritesCategories;

  Person(
      {this.id,
      this.password,
      this.email,
      this.nickname,
      this.background,
      this.favoritesAnimes,
      this.favoritesCategories});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      nickname: json['nickname'],
      background: json['background'],
      favoritesAnimes: List<Anime>.from(json['favoritesAnimes']),
      favoritesCategories: List<Categorie>.from(json['favoritesCategories']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'password': password,
        'nickname': nickname,
        'background': background,
        'favoritesAnimes': favoritesAnimes,
        'favoritesCategories': favoritesCategories,
      };
}
