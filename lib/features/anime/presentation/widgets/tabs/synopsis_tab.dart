import 'package:flutter/material.dart';

import '../../../../../core/utils/app_localization.dart';
import '../../../../../shared/widgets/translated_text.dart';
import '../../../domain/entities/anime.dart';

class SynopsisTab extends StatelessWidget {
  const SynopsisTab({
    super.key,
    required this.anime,
  });

  final Anime anime;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalization.translate('anime_info.synopsis'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          TranslatedText(
            anime.synopsis,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}
