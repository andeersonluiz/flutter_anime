import 'package:flutter/material.dart';
import '../../features/auth/domain/entities/app_user.dart';

class UserProfileHeader extends StatelessWidget {
  final AppUser user;

  const UserProfileHeader({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = user.avatarUrl;
    final background = user.backgroundUrl;

    return UserAccountsDrawerHeader(
      accountName: Text(
        user.username,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: Colors.black, blurRadius: 4)],
        ),
      ),
      accountEmail: Text(
        user.email,
        style: const TextStyle(
          shadows: [Shadow(color: Colors.black, blurRadius: 4)],
        ),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundImage: AssetImage(
          avatar != null && avatar.isNotEmpty
              ? avatar
              : 'assets/avatars/avatar1.png',
        ),
        backgroundColor: Colors.grey.shade800,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        image: background != null && background.isNotEmpty
            ? DecorationImage(
                image: AssetImage(background),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withAlpha(80),
                  BlendMode.darken,
                ),
              )
            : null,
      ),
    );
  }
}
