import 'dart:convert';
import 'dart:typed_data';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/router/app_router.dart';
import '../../../favorites/presentation/bloc/favorites_bloc.dart';
import '../../../favorites/presentation/bloc/favorites_state.dart';
import '../../../../shared/widgets/translated_text.dart';
import '../../domain/entities/anime.dart';

class AnimeCard extends StatelessWidget {
  const AnimeCard({
    super.key,
    required this.anime,
    this.heroTagPrefix = 'card',
  });

  final Anime anime;
  final String heroTagPrefix;

  static final Uint8List kTransparentImage = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==');

  @override
  Widget build(BuildContext context) {
    final poster = anime.posterImage;
    final hasPoster = poster != null && poster.isNotEmpty;

    return GestureDetector(
      onTap: () {
        unawaited(context.push('/anime/${anime.id}',
            extra: AnimeRouteArgs(anime: anime)));
      },
      child: Hero(
        tag: 'anime_${heroTagPrefix}_${anime.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (hasPoster)
                Image.network(
                  poster,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const ColoredBox(
                    color: Colors.grey,
                    child: Center(
                      child: Icon(Icons.broken_image, color: Colors.white54),
                    ),
                  ),
                )
              else
                const ColoredBox(
                  color: Colors.grey,
                  child: Center(
                    child: Icon(Icons.movie, color: Colors.white54),
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black87, Colors.transparent],
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: TranslatedText(
                    anime.title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        anime.rating?.toStringAsFixed(1) ?? 'N/A',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: BlocBuilder<FavoritesBloc, FavoritesState>(
                  builder: (context, state) {
                    bool isFav = false;
                    if (state is FavoritesLoaded) {
                      isFav = state.favoriteIds.contains(anime.id);
                    }
                    if (!isFav) return const SizedBox.shrink();
                    return const Icon(Icons.favorite,
                        color: Colors.red, size: 16);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fade(duration: 300.ms)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.0, 1.0));
  }
}
