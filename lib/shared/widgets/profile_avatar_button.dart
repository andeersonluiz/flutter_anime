import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import 'profile_bottom_sheet.dart';

class ProfileAvatarButton extends StatelessWidget {
  const ProfileAvatarButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final isAuthenticated = authState is Authenticated;
    final user = isAuthenticated ? authState.user : null;

    return IconButton(
      icon: CircleAvatar(
        radius: 14,
        backgroundColor: Colors.deepPurple.shade100,
        backgroundImage: user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty
            ? NetworkImage(user.avatarUrl!)
            : null,
        child: user?.avatarUrl == null || user!.avatarUrl!.isEmpty
            ? Icon(
                isAuthenticated ? Icons.person : Icons.person_outline,
                size: 16,
                color: Colors.deepPurple,
              )
            : null,
      ),
      onPressed: () => ProfileBottomSheet.show(context),
    );
  }
}
