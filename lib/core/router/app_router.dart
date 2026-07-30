import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/anime/domain/entities/anime.dart';
import '../../features/anime/presentation/pages/anime_detail_page.dart';
import '../../features/anime/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/category/domain/entities/category.dart';
import '../../features/category/presentation/pages/anime_by_category_page.dart';
import '../../features/category/presentation/pages/category_page.dart';
import '../../features/character/domain/entities/character.dart';
import '../../features/character/presentation/pages/character_detail_page.dart';
import '../../features/character/presentation/pages/character_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import 'main_scaffold.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          // Branch 1: Categories
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/categories',
                name: 'categories',
                builder: (context, state) => const CategoryPage(),
                routes: [
                  GoRoute(
                    path: ':slug',
                    name: 'animesByCategory',
                    builder: (context, state) {
                      final category = state.extra! as Category;
                      return AnimeByCategoryPage(category: category);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Branch 2: Characters
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/characters',
                name: 'characters',
                builder: (context, state) => const CharacterPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: 'characterDetail',
                    builder: (context, state) {
                      final character = state.extra! as Character;
                      return CharacterDetailPage(character: character);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Branch 3: Favorites
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                name: 'favorites',
                builder: (context, state) => const FavoritesPage(),
              ),
            ],
          ),
          // Branch 4: Profile & Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      // Detail routes that stack on top of the whole scaffold (hiding bottom nav)
      GoRoute(
        path: '/anime/:id',
        name: 'animeDetail',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is AnimeRouteArgs) {
            return AnimeDetailPage(
              anime: extra.anime,
              isFavorite: extra.isFavorite,
              fromRoute: extra.fromRoute,
            );
          } else if (extra is Anime) {
            return AnimeDetailPage(
              anime: extra,
              isFavorite: false,
              fromRoute: 'favorites',
            );
          }
          throw Exception(
              'Expected AnimeRouteArgs or Anime in state.extra for /anime/:id, got: ${extra.runtimeType}');
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}

class AnimeRouteArgs {
  const AnimeRouteArgs({
    required this.anime,
    this.isFavorite = false,
    this.fromRoute = 'home',
  });

  final Anime anime;
  final bool isFavorite;
  final String fromRoute;
}
