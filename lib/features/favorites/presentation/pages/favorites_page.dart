import 'package:animes_io/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:animes_io/features/auth/presentation/bloc/auth_state.dart';
import 'package:animes_io/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:animes_io/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:animes_io/features/favorites/presentation/bloc/favorites_state.dart';
import 'package:animes_io/shared/widgets/empty_state_widget.dart';
import 'package:animes_io/shared/widgets/error_widget.dart';
import 'package:animes_io/shared/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    if (authState is! Authenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Favorites')),
        body: const EmptyStateWidget(
          message: 'Please login to view your favorites',
          icon: Icons.lock_outline,
        ),
      );
    }

    final userId = authState.user.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
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
                message: 'No favorite animes yet',
                icon: Icons.favorite_border,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.favoriteIds.length,
              itemBuilder: (context, index) {
                final animeId = state.favoriteIds.elementAt(index);
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.movie, color: Colors.purple),
                    title: Text('Anime ID: $animeId'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context
                            .read<FavoritesBloc>()
                            .add(ToggleFavoriteEvent(userId, animeId));
                      },
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
