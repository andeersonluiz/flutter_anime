import 'package:flutter/material.dart';
import 'package:animes_io/features/anime/domain/entities/anime.dart';

class SynopsisTab extends StatelessWidget {
  final Anime anime;

  const SynopsisTab({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TODO: Add translation toggle button here in the future
          Text(
            anime.synopsis,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
