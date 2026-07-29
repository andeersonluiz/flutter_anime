import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String email,
    required String username,
    String? avatarUrl,
    String? backgroundUrl,
    @Default(false) bool isAnonymous,
    @Default([]) List<String> favoriteAnimeIds,
  }) = _AppUser;
}
