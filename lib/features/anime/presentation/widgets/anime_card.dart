import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../favorites/presentation/bloc/favorites_bloc.dart';
import '../../../favorites/presentation/bloc/favorites_state.dart';
import '../../domain/entities/anime.dart';

class AnimeCard extends StatelessWidget {
  const AnimeCard({super.key, required this.anime});

  final Anime anime;

  static final Uint8List kTransparentImage = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/anime/${anime.id}', extra: AnimeRouteArgs(anime: anime));
      },
      child: Hero(
        tag: 'anime_${anime.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: anime.posterImage ?? '',
                fit: BoxFit.cover,
                imageErrorBuilder: (_, __, ___) => const ColoredBox(color: Colors.grey),
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
                  child: Text(
                    anime.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                        style: const TextStyle(color: Colors.white, fontSize: 12),
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
                    return const Icon(Icons.favorite, color: Colors.red, size: 16);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
