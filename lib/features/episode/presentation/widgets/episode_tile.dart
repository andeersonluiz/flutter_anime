import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animes_io/features/episode/domain/entities/episode.dart';
import 'package:animes_io/core/di/injection_container.dart';
import 'package:animes_io/core/utils/translation_service.dart';

class EpisodeTile extends StatefulWidget {
  final Episode episode;

  const EpisodeTile({super.key, required this.episode});

  @override
  State<EpisodeTile> createState() => _EpisodeTileState();
}

class _EpisodeTileState extends State<EpisodeTile> {
  bool _isTranslated = false;
  String? _translatedTitle;
  bool _isTranslating = false;

  Future<void> _toggleTranslation() async {
    if (_isTranslated) {
      setState(() => _isTranslated = false);
      return;
    }

    if (_translatedTitle != null) {
      setState(() => _isTranslated = true);
      return;
    }

    setState(() => _isTranslating = true);
    final translator = sl<TranslationService>();
    final title = widget.episode.title;

    if (title != null && title.isNotEmpty) {
      _translatedTitle = await translator.translate(title);
    }

    if (mounted) {
      setState(() {
        _isTranslated = true;
        _isTranslating = false;
      });
    }
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
    final displayTitle = _isTranslated
        ? (_translatedTitle ?? widget.episode.title ?? 'No title')
        : (widget.episode.title ?? 'No title');

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
          Expanded(child: Text(displayTitle)),
          if (_isTranslating)
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: Icon(
                Icons.g_translate,
                color: _isTranslated
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
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
  String? _translatedSynopsis;
  bool _isTranslating = false;

  Future<void> _toggleTranslation() async {
    if (_isTranslated) {
      setState(() => _isTranslated = false);
      return;
    }

    if (_translatedSynopsis != null) {
      setState(() => _isTranslated = true);
      return;
    }

    setState(() => _isTranslating = true);
    final translator = sl<TranslationService>();
    final synopsis = widget.episode.synopsis;

    if (synopsis != null && synopsis.isNotEmpty) {
      _translatedSynopsis = await translator.translate(synopsis);
    }

    if (mounted) {
      setState(() {
        _isTranslated = true;
        _isTranslating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displaySynopsis = _isTranslated
        ? (_translatedSynopsis ??
            widget.episode.synopsis ??
            'No synopsis available.')
        : (widget.episode.synopsis ?? 'No synopsis available.');

    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(widget.episode.title ?? 'Episode')),
          if (_isTranslating)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            IconButton(
              icon: Icon(
                Icons.g_translate,
                color: _isTranslated
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              onPressed: _toggleTranslation,
              tooltip: 'Translate Synopsis',
            ),
        ],
      ),
      content: SingleChildScrollView(
        child: Text(displaySynopsis),
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
