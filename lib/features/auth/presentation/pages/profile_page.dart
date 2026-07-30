import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_localization.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../settings/presentation/bloc/settings_event.dart';
import '../../../settings/presentation/bloc/settings_state.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/edit_profile_dialog.dart';
import '../widgets/login_dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  ImageProvider _getImageProvider(String? path, String defaultAsset) {
    if (path == null || path.isEmpty) {
      return AssetImage(defaultAsset);
    }
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }
    return AssetImage(path);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        final languageCode =
            settingsState is SettingsLoaded ? settingsState.languageCode : 'en';

        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalization.translate('drawer_options.settings')),
          ),
          body: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              final isAuthenticated = authState is Authenticated;
              final user = isAuthenticated ? authState.user : null;
              final hasBackground = user?.backgroundUrl != null &&
                  user!.backgroundUrl!.isNotEmpty;

              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // User Card Header with dynamic Background Image
                  Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    child: Container(
                      decoration: hasBackground
                          ? BoxDecoration(
                              image: DecorationImage(
                                image: _getImageProvider(
                                  user.backgroundUrl,
                                  'assets/background/background (1).png',
                                ),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withAlpha(120),
                                  BlendMode.darken,
                                ),
                              ),
                            )
                          : null,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.deepPurple.shade100,
                            backgroundImage: _getImageProvider(
                              user?.avatarUrl,
                              'assets/avatars/default.jpg',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            isAuthenticated
                                ? (user?.username ?? 'User')
                                : AppLocalization.translate(
                                    'drawer_options.guest'),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: hasBackground ? Colors.white : null,
                                  shadows: hasBackground
                                      ? const [
                                          Shadow(
                                              color: Colors.black,
                                              blurRadius: 6)
                                        ]
                                      : null,
                                ),
                          ),
                          if (user?.email != null &&
                              user!.email.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              user.email,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: hasBackground
                                        ? Colors.white70
                                        : Colors.grey,
                                    shadows: hasBackground
                                        ? const [
                                            Shadow(
                                                color: Colors.black,
                                                blurRadius: 4)
                                          ]
                                        : null,
                                  ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          if (isAuthenticated)
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    hasBackground ? Colors.white : null,
                                side: BorderSide(
                                  color: hasBackground
                                      ? Colors.white70
                                      : Theme.of(context).primaryColor,
                                ),
                              ),
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text('Edit Profile'),
                              onPressed: () {
                                unawaited(showDialog<void>(
                                  context: context,
                                  builder: (_) => const EditProfileDialog(),
                                ));
                              },
                            )
                          else
                            ElevatedButton.icon(
                              icon: const Icon(Icons.login),
                              label: Text(AppLocalization.translate(
                                  'drawer_options.login')),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(44),
                              ),
                              onPressed: () {
                                unawaited(showDialog<void>(
                                  context: context,
                                  builder: (_) => const LoginDialog(),
                                ));
                              },
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 8.0),
                    child: Text(
                      AppLocalization.translate('drawer_options.preferences'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  // Settings Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          secondary: const Icon(Icons.dark_mode_outlined),
                          title: Text(AppLocalization.translate(
                              'drawer_options.dark_mode')),
                          value: settingsState is SettingsLoaded &&
                              settingsState.isDark,
                          onChanged: (val) {
                            context
                                .read<SettingsBloc>()
                                .add(ToggleThemeEvent(val));
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.language_outlined),
                          title: Text(AppLocalization.translate(
                              'dialog_settings.language')),
                          trailing: DropdownButton<String>(
                            value: languageCode,
                            underline: const SizedBox.shrink(),
                            items: [
                              DropdownMenuItem(
                                value: 'en',
                                child: Text(AppLocalization.translate(
                                    'dialog_settings.english_item')),
                              ),
                              DropdownMenuItem(
                                value: 'pt',
                                child: Text(AppLocalization.translate(
                                    'dialog_settings.portuguese_item')),
                              ),
                            ],
                            onChanged: (newLang) {
                              if (newLang != null) {
                                context
                                    .read<SettingsBloc>()
                                    .add(ChangeLanguageEvent(newLang));
                                AppLocalization.setLanguage(newLang);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (isAuthenticated) ...[
                    const SizedBox(height: 24),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: Text(
                          AppLocalization.translate('drawer_options.logout'),
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          context.read<AuthBloc>().add(SignOutEvent());
                        },
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        );
      },
    );
  }
}
