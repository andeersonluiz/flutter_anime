import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animes_io/features/episode/domain/entities/episode.dart';

class EpisodeTile extends StatelessWidget {
  final Episode episode;

  const EpisodeTile({super.key, required this.episode});

  void _showSynopsisDialog(BuildContext context) {
    unawaited(showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(episode.title ?? 'Episode'),
          content: SingleChildScrollView(
            child: Text(episode.synopsis ?? 'No synopsis available.'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _showSynopsisDialog(context),
      leading: episode.thumbnail != null
          ? Image.network(
              episode.thumbnail!,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported),
            )
          : const SizedBox(
              width: 100,
              child: Icon(Icons.image),
            ),
      title: Text(episode.title ?? 'No title'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'S${episode.seasonNumber ?? '-'} E${episode.episodeNumber ?? '-'}'),
          if (episode.airdate != null) Text(episode.airdate!),
        ],
      ),
    );
  }
}
