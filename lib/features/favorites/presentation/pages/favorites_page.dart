import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_localization.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/widgets/login_dialog.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../settings/presentation/bloc/settings_state.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../bloc/favorites_bloc.dart';
import '../bloc/favorites_event.dart';
import '../bloc/favorites_state.dart';
import '../widgets/favorite_anime_tile.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<FavoritesBloc>().add(LoadFavorites(authState.user.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        if (authState is! Authenticated) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                  AppLocalization.translate('drawer_options.my_favorites')),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EmptyStateWidget(
                    message: AppLocalization.translate(
                        'errors.toast_favorite_error'),
                    icon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.login),
                    label:
                        Text(AppLocalization.translate('drawer_options.login')),
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (_) => const LoginDialog(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }

        final userId = authState.user.uid;

        return Scaffold(
          appBar: AppBar(
            title:
                Text(AppLocalization.translate('drawer_options.my_favorites')),
          ),
          body: BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              if (state is FavoritesLoading) {
                return const LoadingWidget();
              }

              if (state is FavoritesError) {
                return AppErrorWidget(
                  message: state.message,
                  onRetry: () {
                    context.read<FavoritesBloc>().add(LoadFavorites(userId));
                  },
                );
              }

              if (state is FavoritesLoaded) {
                if (state.favoriteIds.isEmpty) {
                  return const EmptyStateWidget(
                    message: 'Nenhum anime favorito adicionado ainda.',
                    icon: Icons.favorite_border,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: state.favoriteIds.length,
                  itemBuilder: (context, index) {
                    final animeId = state.favoriteIds.elementAt(index);
                    return FavoriteAnimeTile(
                      animeId: animeId,
                      onRemove: () {
                        context
                            .read<FavoritesBloc>()
                            .add(ToggleFavoriteEvent(userId, animeId));
                      },
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}
