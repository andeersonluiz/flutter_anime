import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/app_user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String uid;
  final String email;
  final String username;
  final String? avatarUrl;
  final String? backgroundUrl;
  final bool isAnonymous;
  final List<String> favoriteAnimeIds;

  const UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.avatarUrl,
    this.backgroundUrl,
    this.isAnonymous = false,
    this.favoriteAnimeIds = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  AppUser toEntity() {
    return AppUser(
      uid: uid,
      email: email,
      username: username,
      avatarUrl: avatarUrl,
      backgroundUrl: backgroundUrl,
      isAnonymous: isAnonymous,
      favoriteAnimeIds: favoriteAnimeIds,
    );
  }

  factory UserModel.fromEntity(AppUser user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      username: user.username,
      avatarUrl: user.avatarUrl,
      backgroundUrl: user.backgroundUrl,
      isAnonymous: user.isAnonymous,
      favoriteAnimeIds: user.favoriteAnimeIds,
    );
  }
}
