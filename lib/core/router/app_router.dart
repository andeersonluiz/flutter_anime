import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/anime/domain/entities/anime.dart';
import '../../features/anime/presentation/pages/anime_detail_page.dart';
import '../../features/anime/presentation/pages/home_page.dart';
import '../../features/category/domain/entities/category.dart';
import '../../features/category/presentation/pages/anime_by_category_page.dart';
import '../../features/category/presentation/pages/category_page.dart';
import '../../features/character/domain/entities/character.dart';
import '../../features/character/presentation/pages/character_detail_page.dart';
import '../../features/character/presentation/pages/character_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/anime/:id',
        name: 'animeDetail',
        builder: (context, state) {
          final anime = state.extra! as AnimeRouteArgs;
          return AnimeDetailPage(
            anime: anime.anime,
            isFavorite: anime.isFavorite,
            fromRoute: anime.fromRoute,
          );
        },
      ),
      GoRoute(
        path: '/characters',
        name: 'characters',
        builder: (context, state) => const CharacterPage(),
      ),
      GoRoute(
        path: '/character/:id',
        name: 'characterDetail',
        builder: (context, state) {
          final character = state.extra! as Character;
          return CharacterDetailPage(character: character);
        },
      ),
      GoRoute(
        path: '/categories',
        name: 'categories',
        builder: (context, state) => const CategoryPage(),
      ),
      GoRoute(
        path: '/categories/:slug',
        name: 'animesByCategory',
        builder: (context, state) {
          final category = state.extra! as Category;
          return AnimeByCategoryPage(category: category);
        },
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesPage(),
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
