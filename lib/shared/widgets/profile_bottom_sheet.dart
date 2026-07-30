import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/widgets/edit_profile_dialog.dart';
import '../../features/auth/presentation/widgets/login_dialog.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../features/settings/presentation/bloc/settings_event.dart';
import '../../features/settings/presentation/bloc/settings_state.dart';

class ProfileBottomSheet extends StatelessWidget {
  const ProfileBottomSheet({super.key});

  static void show(BuildContext context) {
    unawaited(showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const ProfileBottomSheet(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              final isAuthenticated = authState is Authenticated;
              final user = isAuthenticated ? authState.user : null;

              return Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.deepPurple.shade100,
                    backgroundImage:
                        user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty
                            ? NetworkImage(user.avatarUrl!)
                            : null,
                    child: user?.avatarUrl == null || user!.avatarUrl!.isEmpty
                        ? Icon(
                            isAuthenticated
                                ? Icons.person
                                : Icons.person_outline,
                            size: 36,
                            color: Colors.deepPurple,
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isAuthenticated
                        ? (user?.username ?? 'User')
                        : 'Welcome to Animes IO',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (user != null && user.email.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Divider(),
                  BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, settingsState) {
                      final isDark = settingsState is SettingsLoaded &&
                          settingsState.isDark;
                      return SwitchListTile(
                        secondary: const Icon(Icons.dark_mode_outlined),
                        title: const Text('Dark Mode'),
                        value: isDark,
                        onChanged: (val) {
                          context
                              .read<SettingsBloc>()
                              .add(ToggleThemeEvent(val));
                        },
                      );
                    },
                  ),
                  const Divider(),
                  if (isAuthenticated) ...[
                    ListTile(
                      leading: const Icon(Icons.edit_outlined),
                      title: const Text('Edit Profile'),
                      onTap: () {
                        Navigator.pop(context);
                        unawaited(showDialog<void>(
                          context: context,
                          builder: (_) => const EditProfileDialog(),
                        ));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text('Logout',
                          style: TextStyle(color: Colors.red)),
                      onTap: () {
                        Navigator.pop(context);
                        context.read<AuthBloc>().add(SignOutEvent());
                      },
                    ),
                  ] else ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.login),
                        label: const Text('Login / Sign Up'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          unawaited(showDialog<void>(
                            context: context,
                            builder: (_) => const LoginDialog(),
                          ));
                        },
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
