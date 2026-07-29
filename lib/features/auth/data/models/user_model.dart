import '../../domain/entities/app_user.dart';

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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      backgroundUrl: json['backgroundUrl'] as String?,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      favoriteAnimeIds: (json['favoriteAnimeIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'avatarUrl': avatarUrl,
      'backgroundUrl': backgroundUrl,
      'isAnonymous': isAnonymous,
      'favoriteAnimeIds': favoriteAnimeIds,
    };
  }

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
