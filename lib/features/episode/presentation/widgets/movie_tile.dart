import 'package:flutter/material.dart';
import 'package:animes_io/features/episode/domain/entities/episode.dart';

class MovieTile extends StatelessWidget {
  final Episode movie;

  const MovieTile({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Badge(
          label: Text('Movie'),
          child: Icon(Icons.movie),
        ),
        title: Text(movie.title ?? 'Unknown Movie'),
        subtitle: Text(
          movie.episodeLength != null
              ? '${movie.episodeLength} min'
              : 'Unknown duration',
        ),
        trailing: TextButton(
          onPressed: () {
            // Action for movie tile
          },
          child: const Text('Watch'),
        ),
      ),
    );
  }
}
