import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/widgets/edit_profile_dialog.dart';
import '../../features/auth/presentation/widgets/login_dialog.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../features/settings/presentation/bloc/settings_event.dart';
import '../../features/settings/presentation/bloc/settings_state.dart';
import 'user_profile_header.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final isAuthenticated = authState is Authenticated;
          final user = isAuthenticated ? authState.user : null;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              if (user != null)
                UserProfileHeader(user: user)
              else
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                  ),
                  child: Center(
                    child: Text(
                      'Animes IO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  context.pop();
                  context.go('/');
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Characters'),
                onTap: () {
                  context.pop();
                  context.go('/characters');
                },
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Categories'),
                onTap: () {
                  context.pop();
                  context.go('/categories');
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Favorites'),
                onTap: () {
                  context.pop();
                  context.go('/favorites');
                },
              ),
              const Divider(),
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, settingsState) {
                  final isDark =
                      settingsState is SettingsLoaded && settingsState.isDark;
                  return SwitchListTile(
                    secondary: const Icon(Icons.dark_mode),
                    title: const Text('Dark Mode'),
                    value: isDark,
                    onChanged: (val) {
                      context.read<SettingsBloc>().add(ToggleThemeEvent(val));
                    },
                  );
                },
              ),
              const Divider(),
              if (isAuthenticated) ...[
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Profile'),
                  onTap: () {
                    context.pop();
                    showDialog(
                      context: context,
                      builder: (_) => const EditProfileDialog(),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title:
                      const Text('Logout', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    context.pop();
                    context.read<AuthBloc>().add(SignOutEvent());
                  },
                ),
              ] else ...[
                ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text('Login'),
                  onTap: () {
                    context.pop();
                    showDialog(
                      context: context,
                      builder: (_) => const LoginDialog(),
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
