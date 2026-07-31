import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animes_io/features/episode/domain/entities/episode.dart';
import 'package:animes_io/shared/widgets/translated_text.dart';

class EpisodeTile extends StatefulWidget {
  final Episode episode;

  const EpisodeTile({super.key, required this.episode});

  @override
  State<EpisodeTile> createState() => _EpisodeTileState();
}

class _EpisodeTileState extends State<EpisodeTile> {
  bool _isTranslated = false;

  void _toggleTranslation() {
    setState(() {
      _isTranslated = !_isTranslated;
    });
  }

  void _showSynopsisDialog(BuildContext context) {
    unawaited(showDialog<void>(
      context: context,
      builder: (context) {
        return _SynopsisDialog(episode: widget.episode);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final titleText = widget.episode.title ?? 'No title';

    return ListTile(
      onTap: () => _showSynopsisDialog(context),
      leading: widget.episode.thumbnail != null
          ? Image.network(
              widget.episode.thumbnail!,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported),
            )
          : const SizedBox(
              width: 100,
              child: Icon(Icons.image),
            ),
      title: Row(
        children: [
          Expanded(
            child: TranslatedText(
              titleText,
              forceTranslate: _isTranslated,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.g_translate,
              color:
                  _isTranslated ? Theme.of(context).primaryColor : Colors.grey,
              size: 20,
            ),
            onPressed: _toggleTranslation,
            tooltip: 'Translate Title',
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'S${widget.episode.seasonNumber ?? '-'} E${widget.episode.episodeNumber ?? '-'}'),
          if (widget.episode.airdate != null) Text(widget.episode.airdate!),
        ],
      ),
    );
  }
}

class _SynopsisDialog extends StatefulWidget {
  final Episode episode;

  const _SynopsisDialog({required this.episode});

  @override
  State<_SynopsisDialog> createState() => _SynopsisDialogState();
}

class _SynopsisDialogState extends State<_SynopsisDialog> {
  bool _isTranslated = false;

  void _toggleTranslation() {
    setState(() {
      _isTranslated = !_isTranslated;
    });
  }

  @override
  Widget build(BuildContext context) {
    final titleText = widget.episode.title ?? 'Episode';
    final synopsisText = widget.episode.synopsis ?? 'No synopsis available.';

    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: TranslatedText(
              titleText,
              forceTranslate: _isTranslated,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.g_translate,
              color:
                  _isTranslated ? Theme.of(context).primaryColor : Colors.grey,
            ),
            onPressed: _toggleTranslation,
            tooltip: 'Translate Synopsis',
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: TranslatedText(
          synopsisText,
          forceTranslate: _isTranslated,
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
