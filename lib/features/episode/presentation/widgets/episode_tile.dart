import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animes_io/features/episode/domain/entities/episode.dart';
import 'package:animes_io/shared/widgets/translated_text.dart';

class EpisodeTile extends StatelessWidget {
  const EpisodeTile({
    super.key,
    required this.episode,
  });

  final Episode episode;

  void _showSynopsisDialog(BuildContext context) {
    unawaited(showDialog<void>(
      context: context,
      builder: (context) => _SynopsisDialog(
        episode: episode,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final titleText = episode.title ?? 'No title';

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
      title: TranslatedText(
        titleText,
      ),
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

class _SynopsisDialog extends StatelessWidget {
  const _SynopsisDialog({
    required this.episode,
  });

  final Episode episode;

  @override
  Widget build(BuildContext context) {
    final titleText = episode.title ?? 'Episode';
    final synopsisText = episode.synopsis ?? 'No synopsis available.';

    return AlertDialog(
      title: TranslatedText(
        titleText,
      ),
      content: SingleChildScrollView(
        child: TranslatedText(
          synopsisText,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
