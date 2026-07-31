import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_event.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_state.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Settings'),
      content: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoaded) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: state.isDark,
                  onChanged: (value) {
                    context.read<SettingsBloc>().add(ToggleThemeEvent(value));
                  },
                ),
                SwitchListTile(
                  title: const Text('Tradução Automática'),
                  subtitle: const Text('Traduzir conteúdos em segundo plano'),
                  value: state.autoTranslate,
                  onChanged: (value) {
                    context
                        .read<SettingsBloc>()
                        .add(ToggleAutoTranslateEvent(value));
                  },
                ),
                ListTile(
                  title: const Text('Language'),
                  trailing: DropdownButton<String>(
                    value: state.languageCode,
                    items: const [
                      DropdownMenuItem(
                        value: 'en',
                        child: Text('English'),
                      ),
                      DropdownMenuItem(
                        value: 'pt',
                        child: Text('Português'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        context
                            .read<SettingsBloc>()
                            .add(ChangeLanguageEvent(value));
                      }
                    },
                  ),
                ),
              ],
            );
          } else if (state is SettingsError) {
            return Text('Error: ${state.message}');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
