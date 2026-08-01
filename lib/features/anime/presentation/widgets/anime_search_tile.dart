import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/entities/anime.dart';
import '../../../../shared/widgets/translated_text.dart';

class AnimeSearchTile extends StatelessWidget {
  const AnimeSearchTile({super.key, required this.anime});

  final Anime anime;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        anime.posterImage ?? '',
        width: 50,
        height: 70,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.movie),
      ),
      title: TranslatedText(anime.title),
      subtitle: Text('Rating: ${anime.rating?.toStringAsFixed(1) ?? 'N/A'}'),
      onTap: () {
        unawaited(context.push('/anime/${anime.id}',
            extra: AnimeRouteArgs(anime: anime)));
      },
    );
  }
}
