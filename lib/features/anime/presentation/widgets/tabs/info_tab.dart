import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/widgets/info_row.dart';
import '../../../domain/entities/anime.dart';

import 'package:animes_io/core/utils/app_localization.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_state.dart';
import '../../../../../shared/widgets/translated_text.dart';

class InfoTab extends StatelessWidget {
  const InfoTab({
    super.key,
    required this.anime,
    this.translateAll = false,
  });

  final Anime anime;
  final bool translateAll;

  String _translateStatus(String status) {
    switch (status.toLowerCase()) {
      case 'current':
        return 'Em andamento';
      case 'finished':
        return 'Finalizado';
      case 'upcoming':
        return 'Em breve';
      case 'tba':
        return 'A ser anunciado';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildRow(
              context,
              'anime_info.status',
              _translateStatus(anime.status),
            ),
            _buildRow(
              context,
              'anime_info.episodes',
              anime.episodeCount?.toString() ?? 'N/A',
            ),
            _buildRow(
              context,
              'anime_info.size_ep',
              anime.episodeLength != null
                  ? '${anime.episodeLength} mins'
                  : 'N/A',
            ),
            _buildRow(
              context,
              'anime_info.info',
              anime.ageRating ?? 'N/A',
            ),
            _buildRow(
              context,
              'anime_info.genres',
              anime.rating?.toStringAsFixed(1) ?? 'N/A',
            ),
          ],
        );
      },
    );
  }

  Widget _buildRow(BuildContext context, String labelKey, String value) {
    final label = AppLocalization.translate(labelKey);
    return InfoRow(
      label: label,
      value: value,
      labelWidget: translateAll
          ? TranslatedText(
              label,
              forceTranslate: true,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          : null,
      valueWidget:
          translateAll ? TranslatedText(value, forceTranslate: true) : null,
    );
  }
}
